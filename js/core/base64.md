# Base64란 무엇인가?

- 8비트 이진 데이터를 공통 Ascii 영역의 문자로만 구성된 문자열로 바꾸는 인코딩 방식을 말한다.
    - [Wiki | Base64](https://ko.wikipedia.org/wiki/베이스64)
- 알파벳 대소문자와 숫자, 그리고 `+`, `/` 의 64개 문자로 구성되고, 끝을 알리는 코드로 `=` 를 사용한다.

# JS 에서 Base64 변환하기

```javascript
btoa('Miika')
// "TWlpa2E="

btoa('미카')
// 유니코드 등 btoa가 인식할 수 없는 문자열을 입력하면 에러가 발생한다!
// Uncaught DOMException: Failed to execute 'btoa' on 'Window': The string to be encoded contains characters outside of the Latin1 range.

atob('TWlpa2E=')
// "Miika"

atob('미카')
// Uncaught DOMException: Failed to execute 'atob' on 'Window': The string to be decoded contains characters outside of the Latin1 range.
```

유니코드를 URI 컴포넌트로 변경 후 다시 Base64로 변경하는 것은 가능하다.

```javascript
btoa(encodeURIComponent('미카'))
// "JUVCJUFGJUI4JUVDJUI5JUI0"

decodeURIComponent(atob('JUVCJUFGJUI4JUVDJUI5JUI0'))
// 미카
```

# 참고자료

[Base 64 간단 정리하기](https://pks2974.medium.com/base-64-간단-정리하기-da50fdfc49d2)
