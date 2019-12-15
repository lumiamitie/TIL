# 특정 변수가 함수인지 확인하기

특정한 변수가 함수인지 여부를 파이썬에서 어떻게 확인할 수 있을까?

## 해결 방법

- `types.FunctionType`을 통해 확인한다
- <https://stackoverflow.com/a/624948>

```python
import types

isinstance(lambda d: d, types.FunctionType)
# True

isinstance('Other type', types.FunctionType)
# False
```
