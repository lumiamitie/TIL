# reduce를 사용해 find를 구현해보자

- 다음 글을 보고 JS에서 `find` 함수를 직접 구현해보기로 했다
    - [Implementing map, filter and find with reduce in JavaScript](https://maurobringolf.ch/2017/06/implementing-map-filter-and-find-with-reduce-in-javascript/)

```javascript
let a = [0, 1, 2, 3, 4];
let b = ['abc', 'bc', 'cde', 'dd', 'bbc'];
let c = [-1, -2, 0, 3, 4];

const find = (arr, fn) => {
    let checkIfNotUndefined = (x) => {
        // 입력받은 값이 undefined, null, false 라면 true 반환. 아니면 false 반환
        // * 0 같은 falsy 값이 들어왔을 때 값이 있다고 판정하기 위해 사용
        if (x === false) return false;
        return x === undefined || x === null ? false : true;
    }

    let or = (a, b) => {
        // 0 || undefined 의 결과가 undefined가 되는 문제 해결을 위해 사용
        return checkIfNotUndefined(a) ? a : b;
    }
    // * a의 초기값은 undefined
    // * fn(b) 값이 있으면,
    //   -> a에 값이 있다면 그냥 a를 넘김
    //   -> a에 값이 없다면 b를 넘김
    // * fn(b) 값이 없으면, 그냥 a를 넘김
    return arr.reduce((a, b) => {
        return checkIfNotUndefined(fn(b)) ? or(a, b) : a
    }, undefined)
}

console.log( find(a, (x) => x >= 0) )            // 0
console.log( find(b, (x) => x.startsWith('c')) ) // cde
console.log( find(c, (x) => x >= 0) )            // 0
```
