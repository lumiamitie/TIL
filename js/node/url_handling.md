# Node 에서 URL 다루기

- 기존에 URL에서 프로토콜을 파싱하기 위해서 사용하던 url.parse 가 deprecated 되었다고 한다.
- WHATWG API를 사용하도록 코드를 수정한다.

```javascript
const targetUrl = 'https://path-to-image.gif'

// legacy url.parse
const url = require('url');
url.parse(targetUrl)

// using URL class
new URL(targetUrl)
```

<https://nodejs.org/api/url.html#url-strings-and-url-objects>
