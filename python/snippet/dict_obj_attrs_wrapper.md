# Python 딕셔너리의 key를 프로퍼티처럼 접근하기

## 문제 상황

- 원래 파이썬의 딕셔너리는 key를 통해서 접근할 수 있지만 클래스처럼 프로퍼티로 접근할 수는 없다
- 프로퍼티로 접근하려 하면 아래와 같이 `AttributeError` 가 발생한다

```python
some_dict = {
    'a': 10,
    'b': 20
}

some_dict['a']
# 10

some_dict.a
# ---------------------------------------------------------------------------
# AttributeError                            Traceback (most recent call last)
# <ipython-input-328-e766569a53e1> in <module>
# ----> 1 some_dict.a

# AttributeError: 'dict' object has no attribute 'a'
```

## 해결 방법

- 다음과 같이 Wrapper Class를 생성하는 방식으로 해결할 수 있다
    - [Accessing dict keys like an attribute?](https://stackoverflow.com/a/15979044)
    - [Python tricks: accessing dictionary items as object attributes](https://goodcode.io/articles/python-dict-object/)

```python
class Objectviewer(object):
    def __init__(self, d):
        self.__dict__ = d

Objectviewer(some_dict).a
# 10
Objectviewer(some_dict).b
# 20
```
