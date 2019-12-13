# funcy rcompose로 function pipeline 구성하기

R의 파이프 연산자(`%>%`)에 너무 익숙해지다보니 파이썬에서도 비슷한 것이 없는지 찾게 되었다. 
`funcy` 라는 라이브러리에서 `rcompose` 함수를 통해 비슷한 기능을 수행할 수 있을 것 같아서 테스트해보았다.

다음과 같은 list가 있을 때 임의의 작업을 진행한다고 생각해보자.

```python
import funcy as fn
import requests

api_url = 'https://api.npmjs.org/downloads/range/2019-12-01:2019-12-12/vue'
data = (requests.get(api_url)
    .json()
    .get('downloads')
)
# [{'downloads': 53197,  'day': '2019-12-01'},
#  {'downloads': 233465, 'day': '2019-12-02'},
#  {'downloads': 228301, 'day': '2019-12-03'},
#  {'downloads': 231529, 'day': '2019-12-04'},
#  {'downloads': 226026, 'day': '2019-12-05'},
#  {'downloads': 196791, 'day': '2019-12-06'},
#  {'downloads': 52444,  'day': '2019-12-07'},
#  {'downloads': 59922,  'day': '2019-12-08'},
#  {'downloads': 225175, 'day': '2019-12-09'},
#  {'downloads': 231782, 'day': '2019-12-10'},
#  {'downloads': 234763, 'day': '2019-12-11'},
#  {'downloads': 224719, 'day': '2019-12-12'}]
```

리스트에 여러 함수를 적용하다보면 코드가 상당히 복잡해진다.

중간 변수를 두거나 여러 방법으로 해결할 수 있지만, 주피터 등 분석 환경에서는 불필요한 변수를 생성하는 것을 되도록 피하고 싶다.
파이프 같은 방식으로는 해결할 수 없을까?

```python
dict(
    fn.walk_values(
        lambda v: len(v),
        fn.group_by(fn.identity, fn.lmap(lambda d: d["downloads"] > 100000, data)),
    )
)
# {False: 3, True: 9}
```

`funcy.rcompose` 를 사용하면 여러 함수를 깔끔하게 조합할 수 있다. 위 코드를 다음과 같이 정리할 수 있다.

```python
fn.rcompose(
    lambda seq: fn.lmap(lambda d: d['downloads'] > 100000, seq),
    lambda seq: fn.group_by(fn.identity, seq),
    lambda seq: fn.walk_values(lambda v: len(v), seq),
    dict
)(data)
```

R의 파이프 연산자와 유사한 형태의 흐름을 만들고 싶다. 데이터가 먼저 제시되고, 그에 적용될 함수가 순서대로 등장했으면 좋겠다.

```
data %>%
  function1() %>%
  function2() %>%
  function3() %>%
  ...
```

`chain` 이라는 래퍼 함수를 만들어보자. `rcompose` 와 동일한 기능을 수행하지만 함수보다 데이터를 먼저 명시하게 된다.

```python
def chain(x):
    def func_composed(*args):
        return fn.rcompose(*args)(x)
    return func_composed

# chain 래퍼함수를 사용하면 data로부터 함수들이 적용되는 순서를 더 직관적으로 나타낼 수 있다
chain(data)(
    lambda seq: fn.lmap(lambda d: d['downloads'] > 100000, seq),
    lambda seq: fn.group_by(fn.identity, seq),
    lambda seq: fn.walk_values(lambda v: len(v), seq),
    dict
)

# partial 함수를 사용해서 처리하면 다음과 같다
chain(data)(
    fn.partial(fn.lmap, lambda d: d['downloads'] > 100000),
    fn.partial(fn.group_by, fn.identity),
    fn.partial(fn.walk_values, lambda v: len(v)),
    dict
)
```
