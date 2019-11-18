# 특정 DOM Node가 존재하는지 확인하기

## 문제상황

- DOM 내에 특정 엘리먼트(특히 특정 id)가 존재하는지 확인하고자 한다
- 예를 들면
    - 화면의 로드가 완료되면 스크립트를 통해 `<div id="abc"></div>` 를 생성한다
    - 스크립트를 통해 동적으로 생성된 엘리먼트가 존재하는지 확인하려면 어떻게 해야할까?

## 해결방법

[StackOverflow: How to check if element exists in the visible DOM?](https://stackoverflow.com/questions/5629684/how-to-check-if-element-exists-in-the-visible-dom)

### 방법 1: getElementById 를 사용한다

- <https://stackoverflow.com/a/5629761>
- `document.getElementById` 는 해당 엘리먼트가 존재하지 않을 때 null을 반환한다고 한다
- 따라서 id값으로 특정할 수 있다면, 결과가 null인지만 확인하면 된다

```javascript
var element =  document.getElementById('elementId');
if (typeof(element) != 'undefined' && element != null) {
    // exists
};
```

### 방법 2: contains DOM API 를 사용한다

- <https://stackoverflow.com/a/16820058>
- IE에서는 `document` 객체에 `contains` 메서드가 없기 때문에, `document.body.contains` 를 사용해야 한다

```javascript
document.body.contains(document.getElementById('elementId'));
```
