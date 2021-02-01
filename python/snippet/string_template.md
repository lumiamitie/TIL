# Python 에서 ${...} 문자열 템플릿 사용하는 방법

## 문제상황

- html 파일을 불러와서 파이썬의 문자열 템플릿으로 원하는 변수의 값을 치환하려고 한다
- 근데 파이썬에서는 기본적으로 `{ ... }` 패턴을 사용하기 때문에, HTML의 CSS 문과 형식이 겹친다
- JS의 `${ ... }` 등 다른 템플릿을 사용하거나, 사용자가 사전에 정의한 방식을 사용할 수 없을까?

## 해결방법

- `string.Template` 을 사용한다
- 템플릿에서 필요로 하는 정보를 필수적으로 제공해야 하는가에 따라서  `.substitute` 와 `.safe_substitute` 메서드를 사용할 수 있다

```python
from string import Template

# $ 를 사용한 문자열 치환
Template('String ubstitution using $name').substitute(name='string.Template')
# String ubstitution using string.Template

# ${...} 를 사용한 문자열 치환
Template('String ubstitution using ${method}').substitute(method='string.Template')
# 'String ubstitution using string.Template'

# .substitute() 메서드는 템플릿에서 필요로하는 Key가 제공되지 않으면 KeyError를 발생시킨다
Template('${key} => ${value} , ${some_variable}').substitute(key='item_id', value='123456')
# KeyError: 'some_variable'

# .safe_substitute() 메서드를 사용하면 Key가 존재하지 않더라도 무시하고 결과를 반환한다
Template('${key} => ${value} , ${some_variable}').safe_substitute(key='item_id', value='123456')
# 'item_id => 123456 , ${some_variable}'
```

# 참고자료

- [StackOverflow : Ignore str.format(**foo) if key doesn't exist in foo](https://stackoverflow.com/a/28094894)
- [Python 3.8.5 docs : string - Common string operations](https://docs.python.org/ko/3/library/string.html#template-strings)
- [PEP 292 : Simpler String Substitutions](https://www.python.org/dev/peps/pep-0292/)
- [StackOverflow : Example of subclassing string.Template in Python?](https://stackoverflow.com/questions/1336786/example-of-subclassing-string-template-in-python)
