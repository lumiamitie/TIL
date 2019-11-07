# JS에서 문자열에 replaceAll 적용하기

## 문제상황

- 다음과 같이 문자열에서 특정한 값/패턴을 전부 치환하려고 한다
- 하지만 replace 메서드를 사용하면 첫 번째 등장한 패턴에 대해서만 치환이 이루어진다

```javascript
'2019-01-01'.replace('-', '')
// expected : "20190101"
// result   : "201901-01"
```

## 해결방법

- 자바스크립트 정규표현식의 global 플래그를 사용한다
- `/<regex_pattern>/g`

```javascript
'2019-01-01'.replace(/-/g, '')
// expected : "20190101"
// result   : "20190101"
```

## 참고자료

- [MDN : 정규 표현식](https://developer.mozilla.org/ko/docs/Web/JavaScript/Guide/%EC%A0%95%EA%B7%9C%EC%8B%9D)
- [JavaScript에서 string을 replaceAll 하고싶을 때](https://tech.songyunseop.com/post/2016/09/javascript-replace-all/)
