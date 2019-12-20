# NodeList 객체에 Array의 메서드 사용하기

## NodeList

`querySelectorAll` 함수를 사용해서 다양한 노드를 추출하면, 배열이 아니라 NodeList 객체로 값을 가져온다.

```javascript
document.querySelectorAll('a')
// NodeList(16) [a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a]
```

[MDN: NodeList](https://developer.mozilla.org/ko/docs/Web/API/NodeList)

NodeList 객체에는 다양한 메서드가 존재하는데, 배열과 비슷해보이지만 map, filter 등의 메서드가 존재하지 않는다. 
NodeList를 배열로 변환하거나 NodeList에 배열의 메서드를 적용할 수 있을까?

## NodeList to Array

NodeList를 배열로 변화시키면 배열의 메서드를 자연스럽게 사용할 수 있다.

### Array.prototype.slice.call

```javascript
let nodelinks = document.querySelectorAll('a')
let arrayLinks = Array.prototype.slice.call(nodelinks)
```

### Array.from

- 유사 배열과 순회 가능한 객체를 얕게 복사해서 배열로 만든다
- ES6에서 추가되었다

```javascript
let nodelinks = document.querySelectorAll('a')
Array.from(nodelinks)
```

[MDN: Array.from()](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Array/from)

## Apply Array methods to NodeList

`Function.call` 이나 `Function.apply` 를 통해 배열의 메서드를 직접 호출할 수 있다.

```javascript
let nodelinks = document.querySelectorAll('a')
Array.prototype.map.call(nodelinks, l => l.href)
```

[MDN: querySelectorAll로 수집한 객체들을 map으로 처리하기](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Array/map#Example_using_map_generically_querySelectorAll)