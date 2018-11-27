# JavaScript Array Methods: Mutating vs. Non-Mutating

다음 글을 간단하게 정리하였다.

[JavaScript Array Methods: Mutating vs. Non-Mutating](https://lorenstewart.me/2017/01/22/javascript-array-methods-mutating-vs-non-mutating/)

## 1. Add

### Mutating

- `array.push()` : array의 끝에 항목을 추가한다
- `array.ushift()` : array의 시작 부분에 항목을 추가한다

```javascript
// array을 변이 시킬 것이기 때문에 const 보다는 let을 사용한다
let mutatingAdd = ['a', 'b', 'c', 'd', 'e'];

mutatingAdd.push('f'); // ['a', 'b', 'c', 'd', 'e', 'f']
mutatingAdd.unshift('z'); // ['z', 'a', 'b', 'c', 'd', 'e' 'f']
```

### Non-Mutating

- `array.concat()`

```javascript
// array를 변이시키지 않기 때문에 const를 사용한다
const arr1 = ['a', 'b', 'c', 'd', 'e'];

const arr2 = arr1.concat('f'); // ['a', 'b', 'c', 'd', 'e'. 'f']  
console.log(arr1); // ['a', 'b', 'c', 'd', 'e']
```

- spread operator (`...`)

```javascript
const arr1 = ['a', 'b', 'c', 'd', 'e'];

const arr2 = [...arr1, 'f']; // ['a', 'b', 'c', 'd', 'e', 'f']
const arr3 = ['z', ...arr1]; // ['z', 'a', 'b', 'c', 'd', 'e']
```

## 2. Remove

### Mutating

- `array.pop()` : array의 마지막 항목을 제거한다
- `array.shift()` : array의 첫 번째 항목을 제거한다

```javascript
let mutatingRemove = ['a', 'b', 'c', 'd', 'e'];  

mutatingRemove.pop(); // ['a', 'b', 'c', 'd']
mutatingRemove.shift(); // ['b', 'c', 'd']
```

`array.pop()` 과 `array.shift()` 는 제거하는 항목을 반환한다. 따라서 제거되는 항목을 변수로 잡아낼 수 있다.

```javascriptlet
let mutatingRemove = ['a', 'b', 'c', 'd', 'e'];

const returnedValue1 = mutatingRemove.pop();  
console.log(mutatingRemove); // ['a', 'b', 'c', 'd']  
console.log(returnedValue1); // 'e'

const returnedValue2 = mutatingRemove.shift();  
console.log(mutatingRemove); // ['b', 'c', 'd']  
console.log(returnedValue2); // 'a'
```

- `array.splice()`
    - 두 개의 파라미터를 받는다
        - 첫 번째 : 시작점
        - 두 번째 : 제거할 항목의 개
    - `.pop()` 과 `.shift()` 와 마찬가지로 제거하는 항목을 반환한다

```javascript
let mutatingRemove = ['a', 'b', 'c', 'd', 'e'];  
let returnedItems = mutatingRemove.splice(0, 2);  

console.log(mutatingRemove); // ['c', 'd', 'e']  
console.log(returnedItems) // ['a', 'b']
```

### Non-Mutating

- `array.filter()`

```javascript
const arr1 = ['a', 'b', 'c', 'd', 'e'];

const arr2 = arr1.filter(a => a !== 'e');
// ['a', 'b', 'c', 'd']
```

- `array.slice()`
    - 두 개의 파라미터를 받는다
        - 첫 번째 : 복사를 시작할 지점
        - 두 번째 : 복사가 끝나는 지점 (해당 인덱스를 포함하지 않는다)
    - 두 번째 파라미터를 제공하지 않을 경우, 시작 인덱스 이후의 항목들로 복사한다

```javascript
const arr1 = ['a', 'b', 'c', 'd', 'e'];
const arr2 = arr1.slice(1, 5) // ['b', 'c', 'd', 'e']
const arr3 = arr1.slice(2) // ['c', 'd', 'e']
```

## 3. Replace

### Mutating

- `array.splice()`
    - 파라미터 세 개를 사용한다
    - 세 번째 파라미터 : 중간에 추가할 항목

```javascript
let mutatingReplace = ['a', 'b', 'c', 'd', 'e'];

mutatingReplace.splice(2, 1, 30); // ['a', 'b', 30, 'd', 'e']
// OR
mutatingReplace.splice(2, 1, 30, 31); // ['a', 'b', 30, 31, 'd', 'e']
```

### Non-Mutating

- `array.map()`

```javascript
const arr1 = ['a', 'b', 'c', 'd', 'e']  

const arr2 = arr1.map(item => {  
  if(item === 'c') {
    item = 'CAT';
  }
  return item;
});
// ['a', 'b', 'CAT', 'd', 'e']
```
