# 라이브러리를 특정한 이름으로 import 하기

- 기본적으로 R에서는 Python의 `import library as lib` 과 같은 구문을 제공하지 않는다
- `namespace` 라이브러리를 이용해 원하는 이름의 namespace를 만들어서 강제로 함수들을 옮겨담는 방식으로 구현해보았다
- 테스트를 제대로 해보지는 않았기 때문에, 실제로 사용하면서 무언가 문제가 생길 수 있음

```r
import_as = function(lib, as) {
  ns = namespace::makeNamespace(as)
  env_ns = namespace::getRegisteredNamespace(lib)
  lapply(ls(env_ns), function(x) assign(x, get(x, env_ns), ns))
  namespaceExport(ns, ls(ns))
  invisible(NULL)
}

import_as('arules', as = 'ar')
```
