# babel/register 사용시 발생하는 regeneratorRuntime is not defined 에러

## 문제상황

- 다음과 같이 ES6 module을 사용하는 테스트 스크립트가 있다
- 그런데 간단한 테스트를 실행해보면 ReferenceError가 발생하며 테스트가 실패한다
    - `ReferenceError: regeneratorRuntime is not defined`
    - 참고로 아래 함수에서 async 키워드를 제거하면 오류없이 제대로 동작한다
- 어떻게 하면 해결할 수 있을까?

```bash
npm run test -- --require @babel/register test.js
# Test : 
#     1) Launch test

# 0 passing (12ms)
# 1 failing

# 1) Test : 
#     Launch test:
#     ReferenceError: regeneratorRuntime is not defined
#     ...
```

```javascript
// test.js
import { expect } from 'chai';

describe('Test', () => {
    it('Launch test', async function() {
    // 참고 : async를 제거하면 오류없이 동작한다
    // it('Launch test', function() {
        let value = true;
        expect(value).to.exist;
    });
});
```

## 해결방법

- 정확한 원인은 모르겠지만, async/await 키워드와 관련된 문제로 보인다
- 일단 다음과 같이 `@babel/polyfill` 을 통해 해결했다

```javascript
// test.js
import { expect } from 'chai';
import "@babel/polyfill";

describe('Test', () => {
    it('Launch test', async function() {
        let value = true;
        expect(value).to.exist;
    });
});

// npm run test -- --require @babel/register test.js
// ------
//  Test ItemParser (Basic) : 
//    ✓ Launch itemParserTest
//
//
//  1 passing (9ms)
```

# 참고자료

[Async functions are always transformed to regenerator runtime · Issue #871 · parcel-bundler/parcel](https://github.com/parcel-bundler/parcel/issues/871#issuecomment-367899522)
