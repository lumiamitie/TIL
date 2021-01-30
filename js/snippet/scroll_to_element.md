# 특정한 id를 가진 엘리먼트로 스크롤 이동하기

- Q) 특정한 id값을 가지는 엘리먼트로 스크롤를 이동하려면 어떻게 해야 할까?
- A) `element.scrollIntoView` 를 사용하면 된다.

```javascript
const el = document.getElementById("item")
el.scrollIntoView({ behavior: "smooth" })
```

- [StackOverflow: scroll to id element when using "?" in url, vue.js](https://stackoverflow.com/a/53352209)
- [MDN: element.scrollIntoView](https://developer.mozilla.org/ko/docs/Web/API/Element/scrollIntoView)
