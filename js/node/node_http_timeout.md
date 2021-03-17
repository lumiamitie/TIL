# node.js HTTPS 요청에 Timeout 설정하기

- GET 요청에 대해 Timeout 설정하려면 `request.setTimeout` 을 사용한다.

```javascript
const https = require('https');
const targetUrl = '<URL>'
const request = https.get(targetUrl, res => {
    console.log(`status: ${res.status}`)
    console.log(`content-type: ${res.headers['content-type']}`)
    console.log(`content-length: ${res.headers['content-length']}`)

    // Timeout 동작을 확인하기 위해 4초 뒤에 실행되도록 한다
    setTimeout(() => {
        res.on('data', (data) => {})
    },4000)
})

// 3초 내에 작업이 완료되지 않으면 timeout이 발생한다
request.setTimeout(3000, () => {
    console.log('Timeout!') 
    request.abort()
})
```

# 참고자료

- [StackOverflow | How to set a timeout on a http.request() in Node?](https://stackoverflow.com/a/11221332)
