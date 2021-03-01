# 정규표현식으로 두 단어 중 하나라도 포함되는 항목 찾기

## 문제상황

- 크롬 개발자 도구의 Network 탭에서 요청항목을 검색하는데 두 가지 항목을 동시에 검색하려고 한다
- 예를 들어 analytics 또는 ecommerce 두 단어 중 하나를 포함하는 요청을 검색하려면 어떻게 해야 할까?

## 해결방법

```javascript
// 제일 단순하게
/(analytics|ecommerce)/

// 바운더리 탐지(맨앞 또는 공백) + 캡처링
/\b(analytics|ecommerce)\b/

// 패턴으로만 사용하고 캡처링 하지 않을 경우에는 ?: 메타문자를 사용한다
/\b(?:analytics|ecommerce)\b/
```

# 참고자료

- [Regular Expressions Cookbook, 2nd Edition](https://www.oreilly.com/library/view/regular-expressions-cookbook/9781449327453/ch05s02.html)
- [정규 표현식](https://velog.io/@koseungbin/%EC%A0%95%EA%B7%9C-%ED%91%9C%ED%98%84%EC%8B%9D)
