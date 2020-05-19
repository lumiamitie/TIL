# Puppeteer에서 로컬 html 파일 열기

- API 호출을 하지 않는 간단한 HTML 파일을 Puppeteer에서 직접 로딩해서 사용하려면 어떻게 해야 할까?
- 그냥 `file://` 을 통해 해당 파일의 주소를 입력해주면 된다!
- 다만 이 경우 보안상의 제약으로 인해 모든 것이 동작하지 않을 수 있다 (아래 Stackoverflow 링크)

```javascript
let localFilePath = '/Users/miika/Documents/project/test/itemParserTest.html'
await page.goto('file://' + localFilePath);
```

- [puppeteer/puppeteer Issue #578 | Is there a way to open local pages?](https://github.com/puppeteer/puppeteer/issues/578)
- [Chrome browser: Security implications of "--allow-file-access-from-files"](https://stackoverflow.com/questions/29371600/chrome-browser-security-implications-of-allow-file-access-from-files)
