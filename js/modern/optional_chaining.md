# Optional Chaining

`?.` 을 사용하면 앞의 대상이 `undefined` 또는 `null` 일 때 `undefined`를 반환한다.

```javascript
const userInfo = {}

console.log(userInfo.client.isMobile)
// Uncaught TypeError: Cannot read property 'isMobile' of undefined

console.log(userInfo && userInfo.client && userInfo.client.isMobile)
// undefined

console.log(userInfo?.client?.isMobile)
// undefined
```

# 참고자료

- [Javascript Info | Optional Chaining](https://ko.javascript.info/optional-chaining)
