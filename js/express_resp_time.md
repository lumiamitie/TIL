# Node Express 에서 Response에 걸리는 시간 기록하기

## 문제상황

API를 만들었는데 Request부터 Response 완료될때까지 걸리는 시간을 측정하고자 한다

## 해결방법

- <http://www.sheshbabu.com/posts/measuring-response-times-of-express-route-handlers/>
- 다음과 같은 미들웨어를 추가한다

```javascript
//// server.js ////

const express = require('express');
const app = express();
const PORT = 18889;

// Middleware : Measuring response Time ////
app.use((req, res, next) => {
    let startHrTime = process.hrtime();
    res.on("finish", () => {
        let elapsedHrTime = process.hrtime(startHrTime);
        let elapsedTimeInMs = elapsedHrTime[0] * 1000 + elapsedHrTime[1] / 1e6;
        console.log("%s : %fms", req.path, elapsedTimeInMs);
    });
    next();
});
/////////////////////////////////////////////////

// API
app.use('/api/v0/func', require('./api/func'));

app.listen(PORT, () => {
  console.log(`listening on port:${PORT}`);
});
```
