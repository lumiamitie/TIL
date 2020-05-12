# 파이썬에서 쿼리스트링 파싱하기

파이썬에서 URL의 쿼리 스트링을 파싱하는 방법에 대해서 알아보자.

1. `urllib.parse.urlparse` 로 URL을 파싱한다
2. `urllib.parse` 의 `parse_qs` 또는 `parse_qsl` 을 통해 쿼리 스트링을 파싱한다

```python
from urllib.parse import urlparse, parse_qs, parse_qsl

sample_url = 'https://sample.api?param1=01&param2=02&param3=03'

# (1) urllib.parse.urlparse 를 사용해 URL을 파싱한다
parsed_url = urlparse(sample_url)
# ParseResult(
#   scheme='https', 
#   netloc='sample.api', 
#   path='',
#   params='',
#   query='param1=01&param2=02&param3=03',
#   fragment=''
# )

# (2-1) 파싱 결과에서 query 프로퍼티를 추출하여 urllib.parse.parse_qs 로 파싱한다
parse_qs(parsed_url.query)
# {'param1': ['01'], 'param2': ['02'], 'param3': ['03']}

# (2-2) (key, value) 포맷의 리스트로 추출하려면 parse_qsl 함수를 사용한다
parse_qsl(parsed_url.query)
# [('param1', '01'), ('param2', '02'), ('param3', '03')]
```

- [StackOverflow Answer | Python-Requests, extract url parameters from a string](https://stackoverflow.com/a/28328919)
- [파이썬 URL 다루는 법 (Python urllib)](https://dololak.tistory.com/254)
