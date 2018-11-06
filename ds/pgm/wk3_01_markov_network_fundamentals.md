# Markov Network Fundamentals

## Pairwise Markov Networks

강의가 시작될 때, 그래피컬 모델에는 크게 두 가지 종류가 있다고 언급했다. 하나는 DAG를 통한 directed graph 기반의 모형, 그리고 또 한 가지는 undirected graph를 바탕으로 한 모형이다. Undirected Graphical Model은 보통 **Markov Network** (또는 Markov Random Field) 라고 부른다. 우선 간단한 모형인 Pairwise Markov Network에 대해서 살펴보고, 차츰 일반화해 나가도록 한다.

* 스터디 그룹 예제
    * 스터디 그룹에 4명이 있다
    * 각각 2명씩만 페어로 공부한다
    * 각자 어떤 의견을 가지고 있는지 0과 1로 나타낸다
* 위와 같은 그래프는 directed graph와는 결이 맞지 않는다
    * flow가 양쪽 방향으로 모두 발생한다 (따라서 edge에 화살표가 없다)
    * 따라서 조건을 부여할 수 없기 때문에 Conditional CPD를 정의할 수 없다
    * 어떻게 표현해야 할까??
* General Factor를 사용해서 표현해보자
    * general factor를 사용하기 때문에 각 수치가 [0, 1] 사이에 있을 필요가 없다
    * factor는 무엇을 의미하는 것일까?
        * 다양한 이름을 가지고 있다
            * Infinity Functions
            * Compatibility Functions
            * Soft Constraints
        * 위 예제에서 각 factor의 값은 변수 A와 B가 함께 과제를 수행할 때의 행복도를 의미한다
            * a0 b0 위치에 있는 값은 A가 0, B가 0의 의견을 가지고 있을 때의 행복도를 의미한다
    * 이제 모든 factor를 구해서 서로 곱한다
        * 각 factor들의 범위가 [0, 1] 이 아니기 때문에, factor를 곱한 값의 범위도 [0, 1] 이 아니다
        * 따라서 P대신 `P tilda` 로 표기한다
            * tilda는 formalized measure이다
    * Unnormalized measure를 어떻게 확률 분포로 바꿀 수 있을까??
        * Normalize 하면 된다!
        * P(A, B, C, D) = (1/Z) * Ptilda(A, B, C, D)
            * Z는 Partition Function 이라고 한다. 전체의 합을 1로 맞춰주기 위한 상수 값이다
            * 따라서 전체 항목을 모두 더한 값을 Z라고 두면 된다
            * Unnormalized measure를 Z로 나누면 정규화된 확률값을 구할 수 있다
        * 해당 결과가 바로 그래프를 통해 정의된 확률 분포다

* A와 B 사이의 행복도가 확률 분포와 어떤 관계에 있는지 살펴보자
    * factor ph1의 값과 marginal distribution의 확률값을 비교해보자
        * factor ph1에서 행복도가 가장 높은 값은 a0, b0 = 30
        * P(A, B) 에서 가장 높은 값은 a0, b1 = 0.69
    * 왜 차이가 발생하는 걸까??
        * 확률 분포는 4개의 factor를 모두 곱해서 만들어졌기 때문이다
        *  factor들의 값을 보면 B,C는 매우 밀접하게 연결되어 있고, A,D 도 의견이 비슷해보인다
        * C,D의 의견은 매우 다르다. 그리고 이 경우의 값이 매우 크다
        * 어딘가에서 사이클이 깨져야 한다. 그리고 깨져야 한다면 가장 약한 연결고리가 깨질 것이다
            * 여기에서는 A와 B가 가장 약하게 연결되어 있는 factor다
    * `P_{phi}(A, B)`는 사실 네트워크를 구성하는 다양한 factor 들을 종합한 값이라고 볼 수 있다
    * 확률 분포와 factor 사이에는 자연스러운 mapping이 존재하지 않는다
        * 이것이 베이지안 네트워크와의 큰 차이점이다
        * 베이지안 네트워크에서는 각각의 노드 자체가 조건부 확률 분포를 나타내고 있고, 확률을 계산하기만 하면 된다

### Pairwise Markov Networks

* Pairwise Markov Networks는 노드 X1, ... , Xn 으로 구성된 Undirected Graph이다
    * Xi - Xj 가 순서대로 연결되어 edge를 구성한다
    * 각각의 edge는 factor `phi_ij` 와 연결되어 있다
