# 프론트엔드 테스트 코드 작성 (puppeteer, mocha, chai)

## 테스트를 위한 라이브러리 소개

- 다음과 같은 라이브러리를 사용하여 프론트엔드 테스트 코드를 작성하고자 한다
    - mocha
    - chai
    - puppeteer

TODO 각 라이브러리에 대한 설명

## 프로젝트 세팅하기

- npm 프로젝트를 시작하고 테스트를 위한 디펜던시를 설치한다
- puppeteer는 최신 버전의 크로미움을 다운받아서 설치한다 (운영체제에 따라 200~300 MB 가량 필요하다)

```bash
# npm 프로젝트 시작
npm init

# mocha, puppeteer, chai 설치
npm i --save-dev mocha puppeteer chai
```

설치가 완료되면 다음과 같이 package.json 파일이 작성된다

```json
{
    "name": "test_test",
    "version": "0.0.1",
    "description": "",
    "main": "index.js",
    "scripts": {
        "test": "echo \"Error: no test specified\" && exit 1"
    },
    "author": "",
    "license": "ISC",
    "devDependencies": {
        "chai": "^4.2.0",
        "mocha": "^6.2.2",
        "puppeteer": "^2.0.0"
    }
}
```

# 테스트 코드 작성하기

- `/test/test.first.js` 파일을 생성하고 다음과 같이 작성한다

```javascript
const { expect } = require('chai');
const puppeteer = require('puppeteer');

describe('First tests with puppeteer: ', () => {
    let browser;
    let page;

    before(async function() {
        browser = await puppeteer.launch();
        page = await browser.newPage();
    });

    beforeEach(async function() {
        page = await browser.newPage();
        await page.goto('https://www.naver.com/');
    });

    afterEach(async function() {
        await page.close();
    });

    after(async function() {
        await browser.close();
    });

    it('Search panel should exist on the page', async function() {
        const expectedClass = 'search';
        const bannerClass = await page.evaluate(() => {
            return document.getElementById('search').classList.value;
        });
        expect(bannerClass).to.equal(expectedClass);
    })
});
```

- `mocha` 명령어를 통해 테스트 코드를 실행시킨다

```bash
node_modules/.bin/mocha --recursive test

#  First tests with puppeteer: 
#    ✓ Search panel should exist on the page
#
#  1 passing (2s)
```

# 참고자료

- [End-to-end testing with Headless Chrome API](https://codeburst.io/end-to-end-testing-with-headless-chrome-api-d564cb4150c3)
- [Testing with mocha, chai, and puppeteer](http://verbosity.ca/javascript/2018-07-23-testing-with-mocha-chai-and-puppeteer)
