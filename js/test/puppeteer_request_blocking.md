# puppeteer 에서 특정한 도메인에 대한 Request Blocking 하기

- 크롬의 개발자 도구에는 특정한 도메인에 대한 요청을 막아버리는 Request Blocking 기능이 있다.
- 같은 기능을 puppeteer 에서 수행하려면 어떻게 해야 할까?

## 해결방법

- `page.setRequestInterception(true)` 옵션을 추가한다.
- 모든 요청에 대해서 도메인을 확인하고, `request.abort()` 를 사용해 특정한 요청을 막는다.

## 코드

```javascript
// run.js
const puppeteer = require('puppeteer');

// 요청을 막아야 하는 대상 도메인 목록을 배열로 관리한다
const blockedResources = [
    'localhost',
];

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    // 아래 옵션을 true로 설정하면, request 객체의 세가지 메서드를 사용할 수 있게 된다
    // request.abort, request.continue, request.respond
    await page.setRequestInterception(true);

    // 페이지에서 리소스에 대한 요청이 발생할 때마다 동작한다
    page.on('request', (request) => {
        let currentReqUrl = request.url();
        if (blockedResources.some(resource => currentReqUrl.includes(resource))) {
            // Block Certain Domains
            console.log(`Request Blocked! : ${currentReqUrl}`)
            request.abort();
        } else {
            // Allow Other Requests
            request.continue();
        }    
    });
    // 여기서도 localhost 도메인을 사용하면 html 로딩이 실패해서 에러가 발생한다
    await page.goto('http://127.0.0.1:8888/test.html');
    await browser.close();
})()
```

# 참고자료

## 참고한 문서들

- [BetterStack | Block specific requests from loading in Puppeteer](https://betterstack.dev/blog/block-requests-from-loading-in-puppeteer/)
- [Apify | Block requests in Puppeteer](https://help.apify.com/en/articles/2423246-block-requests-in-puppeteer)

## 테스트를 위해 작성한 코드들

- puppeteer 가 불러올 샘플 HTML 파일

```html
<!-- test.html -->
<html lang="ko">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    </head>
    <body>
        <script>
            fetch('http://localhost:3000/target')
                .catch((e) =>{
                    console.log(e);
                })
        </script>
    </body>
</html>
```

```javascript
// server.js
const express = require('express')
const app = express()
const port = 3000

app.use(function (req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.header('Access-Control-Allow-Headers', 'content-type');
    next();
});

app.get('/target', (req, res) => {
    console.log('Request!!')
    res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
```
