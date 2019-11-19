# Puppeteer 에서 브라우징 정보 초기화하기

- <https://stackoverflow.com/a/55872001>
- 다음과 같은 세 가지 방법이 있다
    1. 시크릿모드로 실행하기
    2. Chrome DevTools Protocol을 사용해서 직접 히스토리 삭제하기
    3. 브라우저 다시 실행하기

그 중에서 2번은 다음과 같이 사용할 수 있다.

```javascript
const client = await page.target().createCDPSession();
await client.send('Network.clearBrowserCookies');
await client.send('Network.clearBrowserCache');
```

- `mocha` + `puppeteer` 테스트 코드에 적용하면 다음과 같은 형태가 된다
- `afterEach` 훅에 적용해서 매 테스트가 끝날 때마다 쿠키를 삭제하도록 한다

```javascript
const { expect } = require('chai');
const puppeteer = require('puppeteer');

describe('Dummy Test Code', () => {
    let browser;
    let page;

    before(async function() {
        browser = await puppeteer.launch();
        page = await browser.newPage();
    });

    beforeEach(async function() {
        page = await browser.newPage();
    });

    afterEach(async function() {
        // Cookie 포함 전체 히스토리 삭제
        const client = await page.target().createCDPSession();
        await client.send('Network.clearBrowserCookies');
        await client.send('Network.clearBrowserCache');
        
        // 쿠키 삭제 후 페이지 종료
        await page.close();
    });

    after(async function() {
        await browser.close();
    });

    it('Some Test', async function() {
        // Test Code
    });

    // ....

});
```
