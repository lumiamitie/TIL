# 함수자 (Functor)

> 함수형 자바스크립트 챕터 5의 내용 일부를 요약.

함수자는 값을 wrapper로 감싸고, 특정한 로직으로 수정한 다음에도 wrapper로 감싼 결과물을 반환하기 위한 목적으로 사용하는 자료구조다. 
일반적으로 다음과 같이 정의할 수 있다.

```
fmap :: (A -> B) -> Wrapper(A) -> Wrapper(B)
```

```javascript
class Wrapper {
    #value
    constructor(value) {
        this.#value = value
    }
    map(f) {
        return f(this.#value)
    }
    fmap(f) {
        return new Wrapper(f(this.#value))
    }
}
```

`.fmap` 은 같은 타입을 반환하기 때문에 반복적으로 체이닝을 적용할 수 있다.

```javascript
const two = new Wrapper(2)
two.fmap(x => x+3)                // -> Wrapper(5)
two.fmap(x => x+3).map(x => x)    // -> 5
two.fmap(x => x+3).fmap(x => x+5) // -> Wrapper(10)
```

함수자를 사용하기 위해서는 두 가지 전제조건이 필요하다.

1. Side Effect가 없어야 한다. (identity 함수를 사용할 경우 동일한 결과를 얻어야 한다)
2. 함수를 합성할 수 있어야 한다. (fmap 체이닝한 결과와 합성함수를 사용한 결과가 동일해야 한다)

함수자를 사용하면 원본 값을 건드리지 않은 상태로 안전하게 값을 꺼내서 연산을 수행할 수 있다.
