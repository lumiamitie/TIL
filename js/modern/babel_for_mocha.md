# mocha 테스트를 위해 babel 세팅하기

mocha로 테스트 코드를 작성하는데, ES6 모듈로 된 코드를 테스트하려고 하니 import 문에서 에러가 발생했다. 
문제를 해결하기 위해 babel을 적용해보자.

```bash
# babel 관련 디펜던시를 설치한다
npm install --save-dev @babel/core @babel/cli @babel/register @babel/node @babel/preset-env @babel/polyfill
# polyfill은 dev가 아닌 일반 디펜던시로 설치해야 한다
npm install @babel/polyfill
```

`babel.config.js` 파일을 작성한다.

```javascript
const presets = [
    [
      "@babel/env"
    ],
];
  
module.exports = { presets };
```

다음 명령어를 통해 mocha 테스트에 babel을 적용할 수 있다.

```bash
mocha --require @babel/register test/something.to.test.js
# ./node_modules/.bin/mocha --require @babel/register test/something.to.test.js
```
