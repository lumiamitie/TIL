# 모나드 (Monad)

> 함수형 자바스크립트 챕터 5의 내용 일부를 요약.

모나드는 입력받은 값이 어떤 상태인지 전혀 모르는 상태로 일련의 계산 과정을 서술하는 디자인 패턴이다.
함수자로 값을 보호하면서, 합성할 때도 데이터를 안전하고 부수효과 없이 전달하기 위해서는 모나드가 필요하다.

간단한 예시를 통해 확인해보자. 다음과 같은 상황에서 짝수에만 half를 적용하려면 어떻게 해야 할까?

```javascript
// half :: Number -> Number
Wrapper(2).fmap(half) // Wrapper(1)
Wrapper(3).fmap(half) // Wrapper(1.5)
```

입력값이 홀수인 경우 null을 반환하거나 예외를 발생시킬 수 있다. 
하지만 짝수가 들어올 때 유효한 숫자를 반환하고, 그렇지 않을 경우 무시하는 방식으로 구현해보자.

Empty 컨테이너를 작성한다.

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

    toString() {
        return `Wrapper(${this.#value})`
    }
}

class Empty {
    map(f) {
        return this
    }
    fmap(_) {
        return new Empty()
    }
    toString() {
        return `Empty()`
    }
}

const empty = () => new Empty()
const wrap = (val) => new Wrapper(val)

const isEven = (n) => Number.isFinite(n) && (n % 2 === 0)
const half = (n) => isEven(n) ? wrap(n / 2) : empty()

half(4) // -> Wrapper(2)
half(3) // -> Empty()
```

앞에서 잘못된 값이 넘어와도 Empty 컨테이너가 반환되는 것을 볼 수 있다.

```javascript
half(4).fmap(n => n+3) // -> Wrapper(5)
half(3).fmap(n => n+3) // -> Empty()
```

모든 모나드형(Monadic Type)은 다음과 같은 인터페이스를 준수해야 한다.

- **Type Constructor** : 모나드형을 생성한다. (Wrapper와 비슷)
- **Unit Function** : 값을 모나드에 삽입한다. 보통 `of` 라는 이름의 함수를 사용한다.
- **Bind Function** : 연산을 체이닝한다. 함수자의 `fmap` 에 해당하며, `flatMap` 이라고도 한다.
- **Join Operation** : 모나드 자료구조의 계층을 평탄화 시킨다. 

위 인터페이스에 맞게 `Wrapper` 를 다시 작성해보자.

```javascript
class Wrapper {
    #value

    // Type Constructor
    constructor(value) {
        this.#value = value
    }

    // Unit Function
    static of(a) {
        return new Wrapper(a)
    }

    // Bind Function
    map(f) {
        return Wrapper.of(f(this.#value))
    }

    // Join Operation
    join() {
        if (!(this.#value instanceof Wrapper)) {
            return this
        } else {
            return this.#value.join()
        }
    }

    get() {
        return this.#value
    }

    toString() {
        return `Wrapper(${this.#value})`
    }
}
```

```javascript
Wrapper.of('Monad!')
    .map((str) => str.toUpperCase())
    .map((str) => str)
// -> Wrapper(MONAD!)
```
