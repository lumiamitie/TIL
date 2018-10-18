# Bayesian Network Fundamentals

## Semantics and Factorization

### Student Example

어떤 학생이 수업을 듣고 성적을 받았다. 이에 대한 모형을 구축해보자

- 다음과 같은 다섯 가지 변수가 존재한다
- **G**rade, Course **D**ifficulty, Student **I**ntelligence, Student **S**AT, Reference **L**etter
- => P(G, D, I, S, L)
- Grade 변수를 제외한 나머지는 Binary 형태로 되어 있다


학생의 성적은 어떤 변수의 영향을 받을까?

- 직관적으로 생각해보면 다음과 같은 변수의 영향을 받을 것이다
    - (1) 수업의 난이도 (D -> G)
    - (2) 학생의 지능 (I -> G)
- SAT 점수는 학생의 지능으로부터 영향을 받을 것이다 (I -> S)
- 추천서의 수준은 학생 성적의 영향을 받을 것이다 (G -> L)

네트워크 상에서 각각의 노드를 CPD(Conditional probability distribution)로 구성해보자

- 5개의 노드 => 5개의 CPD
    - P(D)
    - P(I)
    - D -> G : P(G | I, D)
    - I -> S : P(S | I)
    - G -> L : P(L | G)
- 이러한 방식으로 정의하면 Fully Parametrized Bayesian network가 된다.

### Chain Rule for Bayesian Networks

- Chain Rule : 모든 CPD를 곱한다
    - P(D, I, G, S, L) = P(D) P(I) P(G | I, D) P(S | I) P(L | G)
    - 이것은 scope가 {D, I, G, S, L}인 factor를 결과로 하는 factor product가 된다.

### Bayesian Network

베이지안 네트워크란 다음과 같다

- 확률변수 X1, ... Xn 을 표현하는 DAG (directed acyclic graph) 를 말한다
   - *acyclic* 이란 사이클이 없는 것을 말한다. 따라서 시작한 곳보다 뒤쪽 방향의 엣지로는 향할 수 없다
- 각각의 node Xi에 대해 Xi가 의존하는 노드와 Xi의 부모 노드를 포함하는 CPD를 가진다
- 베이지안 네트워크는 체인 룰을 이용하여 joint distribution을 구성한다

### Is BN a legal distribution?

베이지안 네트워크는 joint distribution을 표현한다고 했다. 어떻게 증명할 수 있을까?

TODO

## Reasoning Patterns