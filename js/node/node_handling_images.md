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

## GET으로 전달받은 Buffer로 이미지 바로 처리하기

- GET 요청을 통해 전달받은 이미지를 base64 인코딩 없이 Buffer 수준에서 바로 처리할 수 있을까?
- Buffer 정보를 모아서 Image 객체를 바로 생성해보자

```javascript
const https = require('https')
const { createCanvas, Image } = require('canvas')
const imageUrl = 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'

https.get(imageUrl, res => {
    console.log(`status: ${res.statusCode}`)
    console.log(`content-type: ${res.headers['content-type']}`)
    console.log(`content-length: ${res.headers['content-length']}`)

    const dataBufferArray = []
    res.on('data', (data) => {
        dataBufferArray.push(data)
    })
    res.on('end', () => {
        console.log('Loading Ended!!')
        const dataBuffer = Buffer.concat(dataBufferArray)

        const canvas = createCanvas(200, 200)
        const ctx = canvas.getContext('2d')

        let imageObj = new Image()
        imageObj.onload = () => { 
            // 정상적인 경우 여기까지 도달해야 작업이 완료되는데,
            // 이미지 사이즈가 큰 경우 FATAL ERROR가 발생한다
            console.log('Image Loaded') 
        }
        imageObj.onerror = err => { throw err }
        imageObj.src = dataBuffer
    })
})
```

- 이슈
    - 작은 이미지에서는 아래 코드가 잘 동작하는데, Node.js v12.14.0 환경에서 큰 이미지를 불러올 때 다음과 같은 에러가 발생한다.
        - `FATAL ERROR: v8::ToLocalChecked Empty MaybeLocal.`
    - Node-Canvas 의 비슷한 이슈를 확인해보니, 메모리 부족으로 인한 crash 일 가능성이 높아보인다

- [StackOverflow | Getting binary content in node.js with http.request](https://stackoverflow.com/a/21024737)
- [node-canvas Issue 1525 | Crash on Image::SetSource](https://github.com/Automattic/node-canvas/issues/1525)
