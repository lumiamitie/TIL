# Node에서 HTTP 요청을 통해 가져온 이미지 데이터 다루기

GET 요청을 통해 네트워크 상의 이미지를 가져온 다음에, Node 상에서 직접 핸들링하면서 발생한 각종 케이스를 정리해보자.

## Base64로 인코딩하기

GET 요청을 통해 받아온 이미지를 base64 로 인코딩하기!

```javascript
const https = require('https');
const imageUrl = 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'

const request = https.get(imageUrl, res => {
    console.log(`status: ${res.statusCode}`)
    console.log(`content-type: ${res.headers['content-type']}`)
    console.log(`content-length: ${res.headers['content-length']}`)

    res.setEncoding('base64')
    let b64Start = `data:${res.headers['content-type']};base64,`
    let body = b64Start
    
    res.on('data', (data) => {
        body += data
    })

    res.on('end', () => {
        console.log('Loading Ended!!')
        // body 변수에 Base64로 인코딩된 이미지의 Data URI 가 담겨있다
        // console.log(body)
    })
})
```

[StackOverflow | Node.js get image from web and encode with base64](https://stackoverflow.com/a/47567280)
