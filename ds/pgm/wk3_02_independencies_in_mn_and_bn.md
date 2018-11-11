# Independencies in Markov Networks and Bayesian Networks

## Independencies in Markov Networks

베이지안 네트워크에서 독립성과 factorization의 관계에 대해서 이야기한 적이 있었다. Markov Network 에서도 비슷한 관계를 살펴볼 수 있다. 우선, 그래피컬 모형에서 독립성을 어떤 방식으로 표현할 수 있을까?

### Separation in MNs

* 베이지안 네트워크에서 보았던 **D-separation**과 비슷한 **Separation** 에 대해 살펴보자
    * 다양한 방향으로 흘러가는 영향력을 고려할 필요가 없기 때문에 훨씬 간결하다
* X와 Y는 그래프 H에서 Z가 주어졌을 때, 다음과 같은 조건을 만족할 경우 separated 되었다고 한다
    * => H 안에 active trail이 없는 경우!
    * => Trail 사이에 관측된 값이 없는 경우를 active trail이라고 한다. 따라서 각 케이스를 나누어 확인

### Factorization => Independence: MNs

* BN에서 증명했던 것과 거의 동일한 내용의 theorem을 증명해보자
* X와 Y가 Z가 주어졌을 때 separate 되어 있고 P가 H를 factorize 한다면, X와 Y는 Z가 주어졌을 때 조건부 독립이 성립한다
    * **theorem** : If P factorizes over H, and `sep_H(X, Y | Z)` then P satisfies `(X ㅗ Y | Z)`
* I-map의 개념을 이용해 정리할 수도 있다
    * If P satisfies I(H), H is an I-map (Independency map) of P
    * `I(H) = {(X ㅗ Y | Z) : sep_H(X, Y | Z)}`
    * **theorem** : If P factorizes over H, then H is an I-map of P

### Independence => Factorization

* 베이지안 네트워크와 마찬가지로 반대의 정리가 존재한다
* **Theorem** : For a positive distribution P, if H is an I-map for P, then P factorizes over H
    * positive distribution 이란 모든 경우에 0보다 큰 값을 가지는 분포를 말한다
        * P(X) > 0 for all assignment X
    * 따라서 deterministic한 관계에서는 성립하지 않는다

### Summary

* 그래프 구조를 바라보는 두 가지 동일한 관점이 있다 (positive distribution 일 경우 동일하다)
    * Factorization : 그래프 H를 P를 통해 표현한다
    * I-map : H를 통해 독립성을 표현하고, P를 만족한다
* P가 H를 factorize 한다면 I-map 을 통해 독립성을 표현할 수 있다
