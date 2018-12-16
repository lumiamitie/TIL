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


## I-maps and perfect maps

이전 강의에서 그래프 구조가 독립성을 가지는 항목들의 집합으로 표현될 수 있고, 베이지안 네트워크로 표현될 수 있는 모든 확률 분포들은 그러한 성질을 만족한다는 사실을 확인했다. 이제는 독립성을 가지는 특정한 집합을 그래프 구조 내에서 어떻게 표현할 수 있을지 살펴보자.

### Capturing Independencies in P

* 우선 확률 분포의 독립성에 대해 이해해보자
* I(P) : Set of all independent statements
    * `I(P) = {(X ㅗ Y | Z) : P ㅑ (X ㅗ Y | Z}`
    * Independencies that hold in P
* P가 그래프 G를 factorize 한다는 것은 G가 P에 대한 I-map이라는 것을 의미한다
    * P factorizes over G => G is an I-map for P
    * 따라서 I(P)는 I(G)와 같거나 I(G)를 포함한다
    * 하지만 항상 역이 성립하는 것은 아니다
        * I(G)에는 속하지 않는 독립성이 I(P)에 존재할 수 있다

### Want a Sparse Graph

* 어떤 부분이 문제가 될까?
* 그래프 내에서 독립적인 부분이 적을 수록 그래프가 복잡해질 수 밖에 없다
* 다시 말하면 그래프가 sparse 해질 수록 ( = 독립성이 많을 수록 = 파라미터가 적을수록)
    * 훨씬 효과적인 추론이 가능해진다
    * 또한 그래프가 P에 대해 더 많은 정보를 제공할 수 있게 된다는 것을 의미한다
* 따라서 이러한 구조를 최대한 많이 잡아낼 수 있는 그래프를 얻고자 한다

### Minimal I-map

* Sparsity 관점에서는 어떻게 볼 수 있을까?
* Minimal I-map
    * 중복되는 edge가 없는 I-map을 말한다
        * X -> Y 의 구조가 있을 때, `P(Y | x0) = P(Y | x1)` 이라면 X의 값과는 상관없이 Y가 정해진다
        * 이러한 경우에는 X에서 Y로 이어지는 edge를 제거할 수 있다
    * 우리는 가장 sparse한 형태인 minimal I-map을 얻고자 한다
* Minimal I-map을 얻는 전략은 합리적인 것처럼 보이지만, 우리가 원하는 만큼의 sparsity를 만족하지는 않을 수도 있다 ( Minimal I-map may still not capture I(P) )
    * D->G, I->G 구조로 된 그래프를 살펴보자
        * 이 구조는 해당 분포에 대한 유일한 minimal I-map 이 아니다
        * D->G, I->G, D->I 또한 minimal I-map에 해당된다
    * 따라서 Minimal I-map은 분포 내의 구조를 찾아내기 위한 최선의 도구가 아니다

### Perfect Map

* 우리가 찾고 싶은 것은 바로 Perfect Map이다
    * Perfect Map은 I(G) = I(P)인 경우를 말한다
        * G에서의 독립성과 P에서의 독립성이 일치하는 경우
        * 따라서 G가 P의 독립성을 완벽하게 파악한다
    * 하지만 굉장히 이상적인 상황이다
    * perfect map을 구하는 것이 굉장히 어려울 때가 종종 있다
* Perfect map을 가지지 않는 경우를 살펴보자
    * Pairwise Markov Network로 표현된 분포 P가 존재한다 : `{A-B, B-C, C-D, A-D}`
    * 해당 그래프가 Markov Network의 성질로 인해 특정한 독립성을 가진다는 것을 알고 있다
        * `P ㅑ {AㅗC | B,D, BㅗD | A,C} `
        * `ㅑ` 는 satisfies 를 의미한다
    * 베이지안 네트워크를 통해 Perfect Map으로 표현해보자
        * CASE 1) `{A->D, A->B, D->C, B->C}`
            * `BㅗD | A` : 원래 그래프와 다른 독립성이다
            * 따라서 I-map이 아니다
        * CASE 2) `{A->B, A->D, C->B, C->D}`
            * `BㅗD | A,C` : 원래 그래프와 동일하다
            * 하지만 다른 독립성들은 만족하지 않는다
                * 예를 들면 여기서는 A ㅗ C 가 marginally 독립이다
            * 따라서 이것도 I-map이 아니다
        * CASE 3) `{A->B, A->D, B->C, D->C, D->B}`
            * AㅗC | B,D 를 만족한다. 다른 조건은 만족하지 않는다
            * `I(G) ⊆ I(P)` : I(G)는 I(P)의 subset이다
        * 따라서 이 분포에서는 베이지안 네트워크의 perfect map이 존재하지 않는다

### Another imperfect map

* 이번에는 Bayesian Network 뿐만 아니라 Markov Network에서도 Perfect Map을 구할 수 없는 경우에 대해 알아보자
* 유명한 XOR 예제를 가지고 살펴보자
    * 두 개의 확률 변수 X1, X2가 있다
        * 각각의 변수는 Binary 변수이고, 50:50의 확률을 갖는다
    * Y는 X1과 X2에 대해서 XOR 연산을 취한 값이다
        * X1과 X2 둘 중에 하나가 1이면 Y가 1이다
    * 이 분포의 독립성 관계는 어떻게 될까?
        * X1 ㅗ X2 이다 : marginally independent
        * 하지만 X1과 X2는 서로 대칭이기 때문에 다음이 성립한다
            * X1 ㅗ Y, X2 ㅗ Y
            * 세 변수 모두 독립이다!
    * 따라서 `{X1->Y, X2->Y}` 라는 기존의 그래프도 Perfect map이 아니라는 사실을 알 수 있다

### MN as a perfect map

* 그동안 BN에서의 perfect map에 대해 다루었다. 그렇다면 Markov Network에서는 어떻게 될까?
* 기본적인 정의는 동일하다
    * Markov Network H에 대해서 I(H) = I(P) 인 경우 Perfect Map이라고 한다
* BN으로는 표현되지만 MN으로는 표현되지 않는 상황을 살펴보자
    * V-Structure 구조를 가지고 확인해보자 `{D->G, I->G}` : D ㅗ I
    * 일단 {D-G, I-G} 를 연결해보면 D ㅗ I | G 가 된다. 따라서 I-map 이 아니다
    * {D-G, I-G, D-I} 로 연결해야만 I-map이 구성된다
    * 따라서 Markov Network로는 Perfect map을 구성할 수 없다

### Uniqueness of Perfect Map

* 분포 P를 perfect map을 통해 표현했다고 해보자. 이것은 unique 한 것일까?
* 간단한 예제를 통해 확인해보자 
    * G1 {X->Y} : I(G1) 는 empty set이다 (독립성이 없다)
    * G2 {X<-Y} : I(G2) 또한 empty set이다 (독립성이 없다)
    * 두 그래프는 동일한 분포를 나타내고 있지만, 두 가지 다른 형태로 표현하고 있다
    * 따라서 Perfect map은 고유하지 않다
* edge의 방향이 바뀌더라도 동일한 분포를 나타내는 경우가 존재한다
* 세 개의 노드가 존재하는 경우를 생각해보자
    * 총 네 가지 시나리오가 존재한다
        * 1) X->Y->Z : `{X ㅗ Z | Y}`
        * 2) X<-Y->Z : `{X ㅗ Z | Y}`
        * 3) X->Y<-Z (V-structure) : `{X ㅗ Z}`
        * 4) X<-Y<-Z : `{X ㅗ Z | Y}`
    * V-structure는 다른 경우를 나타내고 있지만, 나머지는 동일하다

### I-equivalence

* 이것을 조금 더 엄밀하게 정의한 것을 I-equivalence 라고 한다
    * 두 그래프 G1, G2가 동일한 독립성 집합을 갖는다면, 다시 말해  `I(G1) = I(G2)` 라면 I-equivalent하다고 표현한다
    * 앞서 살펴보았던 예제를 기준으로 보면 `{X->Y->Z}` 는 `{X<-Y->Z}`, `{X<-Y<-Z}` 와 I-equivalent 하다
* 이 표현이 왜 중요할까?
    * 사전 지식이 없다면 동일한 여러 표현 중에서 어떤 것이 가장 적합한지 알 수 없다는 것을 의미한다
* 대부분 그래프는 많은 I-equivalent 그래프를 가지고 있다

### Summary

* 더 많은 독립성을 포함하는 그래프가 더 간결하고, 더 많은 정보를 제공한다
* Minimal I-map은 그래프 상에 존재하는 구조를 잡아내지 못할 수도 있다
    * 베이지안 네트워크나 다른 모형으로는 표현할 수 있는 것들도 놓칠 수 있다
* Perfect map은 더 좋지만, 실제로는 존재하지 않을 수 있다
* BN과 MN을 서로 변환할 경우 일부 독립성을 잃게 될 수 있다
    * BN -> MN : V-structure로 인한 독립성을 잃는다
    * MN -> BN : 루프 구조를 가로지르는 edge를 추가해야 한다
        * {A-B, B-C, C-D, D-A} 구조에서 {B-C}를 추가해야 한다
