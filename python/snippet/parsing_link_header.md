# Python Link Header 파싱하기

API를 사용하다 보면, HTTP의 Link 헤더를 통해 응답 결과에 링크를 반환하는 경우가 있다.
`requests` 라이브러리를 사용해 HTTP 요청을 할 때, Link Header의 결과를 파싱하려면 어떻게 해야 할까?

```python
import requests

response = requests.get(API_URL)
response.headers['Link']
```

다음과 같이 links 프로퍼티에 접근하면 Link 헤더의 파싱 결과를 딕셔너리 형태로 제공한다.

```python
response.links
```

- [MDN | HTTP headers - Link](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Link)
- [StackOverflow Answer | python requests link headers](https://stackoverflow.com/a/50269860)
