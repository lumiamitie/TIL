# Chrome Client Hints

기존에는 브라우저의 환경 정보를 확인하기 위해 User Agent 정보를 활용했다. 
하지만 구글 크롬에서 단계적으로 User Agent 사용을 중단하겠다고 발표하면서, 그 대안으로 공개한 것이 바로 **Client Hints** 다.

JS 에서는 `navigator.userAgentData` 를 통해 접근하여 값을 확인할 수 있다.

- **Low entropy value** : 값을 바로 조회할 수 있다.
- **High entropy value** : Promise를 통해 비동기적으로 값을 조회할 수 있다.

## Low entropy value

```javascript
navigator.userAgentData.brands
// [
//     {brand: "Google Chrome", version: "87"},
//     {brand: " Not;A Brand", version: "99"},
//     {brand: "Chromium", version: "87"}
// ]

navigator.userAgentData.mobile
// false
```

## High entropy value

```javascript
navigator.userAgentData.getHighEntropyValues([
  "platform",
  "platformVersion",
  "architecture",
  "model",
  "uaFullVersion"
]).then(res => {
    console.log(res)
})
// {
//     architecture: "x86", 
//     model: "", 
//     platform: "Mac OS X", 
//     platformVersion: "10_14_6", 
//     uaFullVersion: "87.0.4280.141"
// }
```

# 참고자료

- [User-Agent Client Hints의 도입, UA 프리징을 대비하라](https://d2.naver.com/helloworld/6532276)
- [UA가 가고 Client Hints가 온다](https://amati.io/bye-user-agent-hello-client-hints/)
