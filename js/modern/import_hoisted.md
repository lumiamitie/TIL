# ES6 에서 import 문은 호이스팅된다..?

## 궁금증

웹팩으로 이것저것 실행하다보니, import 문을 사용해 모듈을 가져올 때 import 문의 위치와 상관없이 코드들이 잘 동작하는 것 같았다.

그렇다면 import 문도 호이스팅되는 것일까 ???

## 확인 결과

module import 문도 호이스팅된다고 합니다.

<https://exploringjs.com/es6/ch_modules.html#_imports-are-hoisted>

> Module imports are hoisted (internally moved to the beginning of the current scope). 
> Therefore, it doesn’t matter where you mention them in a module and the following code works without any problems:

```javascript
foo();
import { foo } from 'my_module';
```
