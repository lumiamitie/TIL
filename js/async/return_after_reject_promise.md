# JS Promise 내부에서 reject 하더라도 뒷 부분 코드들이 계속해서 실행되는 문제

## 문제상황

- 다음과 같은 비동기 함수가 있다
- reject 조건을 만족할 경우 비동기 작업을 reject 해야하는데, reject 뒷 부분까지 모두 수행하는 것을 볼 수 있다
- 어떻게 처리해야 할까?

```javascript
const testPromise = (reject) => {
    return new Promise((resolve, reject) => {
        console.log('aaa')
        if (reject) {
            reject('Reject Everything')
        }
        console.log('bbb')
        resolve('Resolve this promise')
        console.log('ccc')
    })
}

testPromise(true)
// aaa
// bbb
// ccc
// Promise { <rejected> 'Reject Everything' }
```

## 해결방법

- 가장 간단한 방법은 reject 뒤에 `return;` 을 추가해서 함수를 강제로 종료하는 것이다
    - 또는 `return reject('Reject Everything')` 으로 처리할 수도 있다
- 혹은 if 문에서는 reject, else 안에서는 resolve 로직만 사용하는 방식으로 분리하면 된다

[Stackoverflow: Do I need to return after early resolve/reject?](https://stackoverflow.com/a/32536083)

```javascript
// (1) return 으로 처리
const testPromise2 = (reject=true) => {
    return new Promise((resolve, reject) => {
        console.log('aaa')
        if (reject) {
            reject('Reject Everything')
            return;
            // 또는 
            // return reject('Reject Everything')
        }
        console.log('bbb')
        resolve('Resolve this promise')
        console.log('ccc')
    })
}

testPromise2()
// aaa
// Promise { <rejected> 'Reject Everything' }

// (2) if-else 로 처리
const testPromise3 = (reject=true) => {
    return new Promise((resolve, reject) => {
        console.log('aaa')
        if (reject) {
            reject('Reject Everything')
        } else {
            console.log('bbb')
            resolve('Resolve this promise')
        }
        console.log('ccc')
    })
}

testPromise3()
// aaa
// ccc
// Promise { <rejected> 'Reject Everything' }
```
