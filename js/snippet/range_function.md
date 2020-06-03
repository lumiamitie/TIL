# JS에서 range 함수 구현하기

주어진 시작점으로부터 정수 n개를 추출하는 함수를 JS로 작성해보자

```javascript
const range = function(start, length) {
    return Array.from(Array(length).keys()).map(n => n + start);
};

range(1, 5)   // [ 1, 2, 3, 4, 5 ]
range(5, 2)   // [ 5, 6 ]
range(10, 4)  // [ 10, 11, 12, 13 ]
range(-11, 5) // [ -11, -10, -9, -8, -7 ]
```

[How to create an array containing 1...N](https://stackoverflow.com/a/33352604)
