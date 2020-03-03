# asyncPool 직접 구현하기

- promise를 배열 개수대로 생성하다보니, 비동기 작업이 너무 많이 생성되었을 때 프로세스가 죽는 현상이 발생했다
- 그래서 동시에 진행되는 비동기 작업 개수를 제한하는 방식으로 컨트롤해보기로 한다
- 다음 자료를 참고하여 진행
    - <https://stackoverflow.com/a/51020535>

## 구현 결과

- 어떤 방식으로 구현했을까?
    1. 원하는 동시 작업 개수대로 배열을 생성하고, 실행하려는 작업 내역을 iterator로 만들어 각 배열에 넣는다
    2. 기존 작업이 완료될 때마다 iterator를 통해 남아있는 작업 내역을 받아와서 실행한다
    3. 모든 작업이 완료되면 promise를 통해 데이터와 함께 다음 단계로 resolve 한다
- 파라미터 설명
    - `n` : 최대 동시 작업 개수
    - `arr` : 데이터가 들어있는 배열
    - `taskFn` : 실제 작업이 정의된 함수
    - `throwErrorWhenFailed` : `true` 이면, 에러가 발생했을 때 `taskResult` 결과가 반환되지 않는다

```javascript
const promisePool = function(n, arr, taskFn, throwErrorWhenFailed = false) {
    // 전체 task의 promise를 저장하기 위한 배열을 선언한다
    // * workers 배열에는 모든 task에 대한 Promise가 남지 않는다
    // * 따라서 workers와는 별개로 전체 Promise를 저장하는 배열을 따로 둔다
    // * workers 만으로 처리하면 작업이 실패해도 파악하지 못하는 경우가 발생할 수 있다
    //   (workers 배열의 길이는 n이기 때문에, reject된 promise가 남아있지 않다면 그냥 넘어간다)
    let taskResult = new Array(arr.length);

    // iterator에 들어있는 값을 받아서 실제 작업을 트리거하는 함수
    // * 작업이 완료되면 taskResult 배열의 지정된 인덱스에 promise를 추가한다
    let runTask = async function(iterator) {
        for (let [index, item] of iterator) {
            try {
                taskResult[index] = await taskFn(item);
            } catch (e) {
                console.error(`[ Failed ] ${item}`);
                if (throwErrorWhenFailed) {
                    throw e;
                };
            }
        }
    }
    // * n개의 항목을 가지는 배열을 생성한다 (각각의 항목이 worker 역할을 한다)
    // * arr.entries() 를 통해 입력받은 배열을 순서대로 출력하는 iterator를 생성하고, 
    //   worker 배열의 모든 항목을 해당 값으로 채운다
    let workers = new Array(n).fill(arr.entries()).map(runTask);

    // 작업이 모두 완료되면 resolve 되는 promise를 반환한다
    // * 우선 작업이 종료되었는지 여부는 workers로 확인한다
    // * 전체 task 중에서 실패한 작업이 있는지 여부는 taskResult
    return (
        Promise.all(workers)
            // throwErrorWhenFailed=true 이면, 에러가 발생했을 때 taskResult 결과가 반환되지 않는다
            .then(() => taskResult.filter(d => d))
            .catch(e => {
                throw e;
            })
    )
}
```

## 사용 방법

```javascript
// 이상한 데이터가 섞여있다 (4번째 항목에는 b가 없음)
let arrr = [
    {a: 10, b: 20},
    {a: 11, b: 21},
    {a: 12, b: 22},
    {a: 13, c: 23},
    {a: 14, b: 24},
]

// (1) 3개의 worker 사용, 에러 throw하지 않는 경우
// - promisePool(3, arr, taskFn, false)
// - 에러가 발생해도 catch 대신 then으로 넘어간다
promisePool(3, arrr, (d) => {
    return new Promise((resolve, reject) => setTimeout(() => {
        console.log(d.a / d.b)
        if (typeof d.b === 'undefined') {
            reject('no b')
        }
        resolve(d.a / d.b)
    }, 1000))
}).then((item) => {
    console.log('Done')
    console.log(item)
}).catch(e => {
    console.error('Job Failed')
})
// 0.5
// 0.5238095238095238
// 0.5454545454545454
// NaN
// [ Failed ] [object Object]
// NaN
// [ Failed ] [object Object]
// Done
// [ { a: 10, b: 20 }, { a: 11, b: 21 }, { a: 12, b: 22 } ]


// (2) 3개의 worker 사용, 에러 throw 하는 경우
// - promisePool(3, arr, taskFn, true)
// - 마지막 catch 문으로 바로 넘어간다
promisePool(3, arrr, (d) => {
    return new Promise((resolve, reject) => setTimeout(() => {
        console.log(d.a / d.b)
        if (typeof d.b === 'undefined') {
            reject('no b')
        }
        resolve(d.a / d.b)
    }, 1000))
}, true).then((item) => {
    console.log('Done')
    console.log(item)
}).catch(e => {
    console.error('Job Failed')
})
// 0.5
// 0.5238095238095238
// 0.5454545454545454
// NaN
// [ Failed ] [object Object]
// Job Failed
// NaN
// [ Failed ] [object Object]
```

- 주의!
    - 각 비동기 작업에서 에러를 어떻게 처리하는가에 따라 동작하는 결과가 많이 달라졌다
    - 위 코드에서는 실패한 작업이 하나라도 있을 때 전체 작업이 실패해야하는지 여부를 `throwErrorWhenFailed` 파라미터를 통해 구분하도록 했다

# 참고자료

- 위 코드와는 조금 다른 방식으로 해결한 라이브러리 (이쪽도 코드는 짧다)
    - <https://github.com/rxaviers/async-pool>
