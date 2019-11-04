# Vue Error : Unexpected console statement (no-console)

## 문제상황

- Vue 작업 중 다음과 같은 에러가 발생했다
- console.log 에서 에러가 발생했는데 도대체 왜 발생한 것인지 알 수가 없다...

```
ERROR  Failed to compile with 1 errors                                                                                                                
    error  in ./src/components/component.vue

Module Error (from ./node_modules/eslint-loader/index.js):
error: Unexpected console statement (no-console) at src/components/component.vue:128:17:
    126 |         axios.get('http://127.0.0.1:8888/api/v0/sample')
    127 |             .then((res) => {
  > 128 |                 console.log(res.data.result);
        |                 ^
    129 |                 this.data = res.data.result;
    130 |             })
    131 |     }

1 error found.
```

## 해결방법

- **Unexpected console statement (no-console)**
- ESLint 에서 기본적으로 console 객체를 사용하지 않도록 강제해서 발생한 에러

### (1) 스크립트에서 처리

- 일단은 스크립트에서 `/* eslint-disable no-console */` 을 추가해주면 해당 옵션을 잠깐 끌 수 있다

```html
<script>
/* eslint-disable no-console */

...

</script>
```

### (2) 옵션으로 처리

- `packages.json` 에서 `eslintConfig` 의 `rules` 에 `"no-console": "off"` 옵션을 추가한다

```json
"eslintConfig": {
    "root": true,
    "env": {
        "node": true
    },
    "extends": [
        "plugin:vue/essential",
        "eslint:recommended"
    ],

    "rules": {
        "no-console": "off" // "no-console": "off" 옵션을 추가하면 전체 스크립트에서 옵션을 해제한다
    },

    "parserOptions": {
        "parser": "babel-eslint"
    }
},
```
