# webpack 으로 환경변수를 스크립트 내에 추가하기

- 브라우저 스크립트 내에서 `process.env.SERVICE_ID` 값을 사용하기 위해 다음과 같이 webpack 스크립트를 수정했다.
- 다음과 같이 `webpack.DefinePlugin` 으로 `process.env.SERVICE_ID` 에 들어갈 값을 정의한다.

```javascript
// webpack.custom.config.js
const webpack = require('webpack');
const SERVICE_ID = process.env.SERVICE_ID;

module.exports = {
    // ...
    plugins: [
        new webpack.DefinePlugin({
            'process.env.SERVICE_ID': JSON.stringify(SERVICE_ID)
        }),
    ],
    // ...
}
```

<https://stackoverflow.com/questions/30030031/passing-environment-dependent-variables-in-webpack>
