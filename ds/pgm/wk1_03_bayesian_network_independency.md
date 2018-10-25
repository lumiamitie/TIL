# Bayesian Networks: Independencies

## Conditional Independence

그동안 graphical model을 확률 분포를 통해 표현하는 구조로 정의해왔다. 하지만 완전히 다른 시각에서 접근할 수도 있다. 이번에는 확률 분포가 따라야 하는 "독립성"을 바탕으로 표현해보려고 한다.

### Independence

- 다음과 같은 경우에 alpha와 beta는 독립이다 :
    - 1) P(a, b) = P(a) * P(b)
    - 2) P(a | b) = P(a)
        - 확률의 영향은 대칭이기 때문에 다음도 마찬가지로 성립한다
        - P(b | a) = P(b)
- 확률변수 X, Y는 다음과 같은 경우에 독립이다:
    - P(X, Y) = P(X) P(Y)
    - P(X | Y) = P(X)
    - P(Y | X) = P(Y)

### Conditional Independence

독립성은 매우 드물게 나타나는 현상이기 때문에 강력하게 사용할 수 있는 개념이 아니다. 이번에는 **조건부 독립** 이라는 더 넓은 범위의 개념에 대해서 살펴보자. 

- P satisfies X is independent of Y given Z if:
    - P(X, Y | Z) = P(X | Z) * P(Y | Z)
    - P(X | Y, Z) = P(X | Z)
        - Z가 주어졌을 때, Y는 P(X)에 대한 추가적인 정보를 제공하지 못한다
    - P(Y | X, Z) = P(Y | Z)
    - P(X, Y, Z) \propto factor1(X,Y) factor2(X,Y)
        - X, Y, Z의 joint distribution은 factor 두 개의 곱으로 표현할 수 있다
- Example
    - 동전이 하나 있고 Fair Coin 이거나 Biased Coin이다 (동전의 상태는 모른다)
    - 동전을 두 번 던진다 (X1, X2)
        - X1에서 H가 나왔다면, X2에서 H가 나올 확률은 더욱 상승한다
        - Fair Coin 이라면 50:50이지만 Biased Coin이라면 더 높은 확률을 가질 것이기 때문
    - 가지고 있는 동전이 무엇인지 알고 있다면 어떻게 될까?
        - Fair Coin이라는 것을 알았다면, X1에서 H가 나왔다고 해도 X2와는 무관하다
        - Biased Coin이라고 해도 마찬가지. X2에서 H가 나올 확률은 X1의 결과와 무관하다
    - 따라서, X1과 X2는 독립이 아니다
        - 다만 Coin의 상태가 주어진다면, X1과 X2는 독립이다

단순히 조건을 부여한다고 해서 독립성이 생기는 것은 아니다. 오히려 상태가 주어져서 독립이 깨지는 경우도 있다. `I = i1` 으로 조건을 줄 때는 독립이지만 `I = i0`으로 조건을 줄 경우 독립이 아닐 수도 있다.


## Dependencies in Bayesian Networks

확률분포 P를 factorization 한다는 것은 분해되는 두 변수가 독립이라는 것을 의미한다. 그래프 내에서 분해가 가능한 경우에 변수들 간의 독립성을 어떻게 확인할 수 있는지 살펴보자.

### d-separation

- Z값이 주어지고 두 노드 X와 Y 사이에 active trail이 없다면, X와 Y는 **d-separated** 되었다고 정의한다. 
- Z가 주어지고, X와 Y가 d-separated 된다면 X와 Y는 조건부 독립이다

### I-map (Independency map)

그래프 내의 모든 변수에 대한 확률 분포 P가 독립인 경우, 그래프 G를 P의 **I-map** 이라고 정의한다.

- 그래프 G의 확률 분포 P가 factorize 된다면, G는 P의 I-map이다
- 그래프 G가 P의 I-map 이라면, P는 factorize된다

따라서 P가 factorize되어 그래프를 통해 베이지안 네트워크로 표현할 수 있다면, 각 변수들 사이의 독립성을 파악할 수 있다. 그렇다면 각 변수가 다른 변수에 미치는 영향을 알 수 있다.
