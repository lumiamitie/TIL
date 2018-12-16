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


## General Gibbs Distribution

앞에서 살펴본 Pairwise Markov Networks 보다 조금 더 일반화된 모형인 Gibbs Distribution에 대해서 알아보자.
4가지 변수 A,B,C,D 가 있을 때 2개씩 서로 연결하여 쌍을 구성할 수 있다. 
이렇게 표현하면 모든 경우를 표현할 수 있을까? 다시 말하면, 4개의 확률 변수로 이루어진 모든 확률 분포를 나타낼 수 있을까? 

X1, ... , Xn 까지의 n개의 노드가 있고 각각의 노드가 d가지 값을 가질 수 있는 Fully Connected Pairwise Markov Network를 가정해보자. 
네트워크가 가질 수 있는 파라미터의 수는 `nC2 edges x d^2` 로 O(n^2 * d^2) 이다.
일반적인 경우, 그러니까 d가지 값을 가지는 n개의 노드 전체를 가정하면 몇 가지 파라미터가 존재할 수 있을까? O(d^n)이다. 
O(n^2 * d^2)에 비해 훨씬 큰 값이라는 것을 알 수 있다. ( `O(d^n) >> O(n^2 * d^2)` ) 
따라서 Pairwise Markov Network는 모든 종류의 확률 분포를 충분히 설명할 수 있을 정도로 표현력이 좋은 모형이 아니라는 점을 알 수 있다.

그렇다면 Undirected 그래프를 이용한 네트워크 모형의 커버리지를 높이기 위해서는 어떻게 해야 할까? 일단 Pairwise Edge 부터 포기해야 한다.

### Gibbs Distribution

* 2개 이상의 파라미터를 가지는 general factor를 이용해보자
    * 지금까지는 2개의 쌍으로 이루어진 factor만 사용했다면 3개, 4개, 또는 그 이상으로 이루어진 general factor를 사용한다
    * 이제는 모든 확률분포를 표현할 수 있을까? 할 수 있다.
* **Gibb Distribution**은 factor들의 집합인 Phi로 나타낼 수 있다. 세 가지 단계를 통해 분포를 정의해보자
    * 1) 모든 factor를 곱한다 (factor product)
        * 아직은 확률 분포는 아니다 (Unnormalized Measure)
    * 2) Partition Function을 정의한다
        * 1번의 결과에서 모든 값을 더한다
        * Normalizing constant의 역할을 수행한다
    * 3) 모든 값을 Partition Function의 결과값으로 나눈다
        * 이제 Normalize 된 결과를 얻을 수 있다

### Induced Markov Network

* 두 개의 factor phi1(A,B,C) 와 phi2(B, C, D) 로 구성된 네트워크가 있다
    * phi1 : scope가 {A, B, C}
    * phi2 : scope가 {B, C, D}
* 두 factor를 네트워크 상에 표현할 경우 phi1은 A, B, C를 edge로, ph2는 B, C, D를 edge로 연결한 형태가 된다
    * 강의자료에서 phi1은 파란색 선, phi2는 빨간색 선으로 표시되어 있다
* 이것을 **Induced Markov Network**라고 한다
    * factor로 구성된 집합 Phi가 있다고 해보자. 각각의 factor `phi_i`의 scope는 `D_i` 이다
    * `Phi = { phi_1(D1), ... , phi_k(Dk) }`
* Induced Markov network `H_phi` 는 변수 Xi, Xj가 factor `phi_m`의 scope `Dm`에 포함될 경우, 항상 Xi - Xj 로 이어지는 edge를 갖는다
    * 다시 말하자면, 두 변수가 동일한 scope에 존재할 경우 두 변수는 서로 연결되어 있다

### Factorization

* factor들의 집합인 Phi가 존재한다면, P는 H에 대해 factorize 할 수 있다
    * 단 `P = P_phi` (normalize된 factor product)
    * H는 phi에 대한 induced Markov Network 일 경우
* 그래프로부터는 factorization 을 파악할 수 없다

### Flow of Influence

* 그런데 그래프가 왜 동일한 것일까?
    * 그래프가 factorization이나 구조를 표현하지 못한다면, 그래프는 무엇을 나타내고 있는 것일까?
* 그래프 내부에 있는 factor 들의 influence 흐름을 살펴보자
    * 하나의 변수가 다른 변수에 영향력을 행사할 수 있는 때는 언제일까?
        * 두 변수가 trail로 연결되어 있을 때 (다른 factor에 속해 있더라도 상관없다)
    * factor 구성에 따라 각 분포의 파라미터는 달라지지만, 그래프 내부에서 영향력의 흐름을 나타내는 trail (path) 은 동일하다

### Active Trails

Markov Network에서 active trail을 정의해보자. 베이지안 네트워크에서의 정의보다 훨씬 간단한다.

* Trail X1 - ... - Xn 의 노드 중 관측된 것이 없다면 (no Xi in Z) active trail 이다
* 관측된 변수가 있다면 영향력의 흐름이 끊긴다
    * D - A - B 의 path가 있다고 하면, A가 관측되지 않았을 경우 active trail에 해당된다

### Summary

* Gibbs distribution은 확률분포를 factor product 형태로 표현한다
* Induced Markov Network에서는 동일한 factor에 속한 노드를 서로 연결한다
* Markov Network 구조는 특정한 형태로 factorize 되지 않는다
* 하지만 active trail은 그래프 구조에만 의존한다


## Conditional Random Fields

Markov Network를 활용한 기법 중에서 가장 중요한 것 중 하나는 바로 **Conditional Random Field** 이다. Markov Network와 비슷하게 생겼지만, 상당히 다른 목적으로 사용된다. 

### Task-specific prediction

이러한 종류의 모형은 task-specific prediction 이라고 불리는 문제를 다루기 위해 사용된다. 관측치를 나타내는 입력변수 X가 있고, 예측하고자 하는 목표 변수 Y가 있다. 입력변수의 타입은 항상 동일하고, 목표 변수의 타입 또한 항상 동일하다. 두 가지 예제를 통해 자세한 내용을 살펴보자.

* Image Segmentation
    * Input : 픽셀 (항상 픽셀값이다) 과 픽셀을 통해 가공한 값들 (히스토그램 등)
    * Output : 각 픽셀에 대한 클래스 값 (들판, 하늘, 소 등등)
    * X를 통해 Y를 예측하는 것이 우리가 하고자 하는 목표이다
* Text Processing
    * Input : 문장 내의 단어들
    * Output : 단어에 대한 레이블 값 (인명, 장소, 단체 등등)
* 각각의 예제에서 input과 output은 항상 동일한 형태의 타입을 갖는다

### Correlated Features

그렇다면 왜 기존의 방법을 쓰지 않겠다는 것일까? 무엇이 문제일까? 관련된 이슈를 함께 살펴보자.

* Image Segmentation 문제에서 Superpixel Ci 의 클래스를 예측한다고 생각해보자.
    * 색상과 질감 등 feature 들을 사용하여 모형을 구성한다
    * Ci가 여기서는 Y (예측하려는 목표 변수) 에 해당된다
* 문제는 예측을 위해 사용되는 feature 들이 서로 강한 상관관계로 얽혀 있다는 것이다
    * 예를 들면, 텍스쳐의 경우 특정한 superpixel 내에서 선의 방향을 표현한다
    * superpixel의 내부적인 구조나 텍스쳐의 종류에 따라 여러 feature에 중복된 정보들이 포함되어 있다
    * 따라서 이러한 모형을 각각의 feature들이 독립적인 나이브 베이즈로 표현할 경우, 각 피쳐들의 상관관계 구조를 무시하는 것이 된다
* feature 들의 관계를 (서로 중복된 정보가 많다는 점) 무시하는 것이 왜 나쁠까?
    * 동일한 feature를 반복해서 사용하는 것과 비슷한 상태가 되기 때문에 나쁘다
    * 따라서 잘못된 독립성 가정을 바탕으로 한 결과, 결과적으로 실제와는 다르게 굉장히 치우친 확률 분포를 얻게 된다
* 그렇다면 이제 올바른 가정을 세워보자
    * 각 변수들의 상관관계를 찾아내기 위한 edge 들을 모형에 추가한다
    * 하지만 이러한 상관관계를 찾아낸다는 것은 굉장히 어려운 작업이다
    * 또, edge 들을 추가하려다보니 모형이 더 복잡해진다
* 그렇다면 아예 다른 해결방법을 찾아보자

### CRF Representation

* 일단 이미지의 feature 들에 대해서는 신경쓰지 말자
    * 픽셀의 확률 분포를 예측하고자 하는 것이 아니다
    * 녹색 픽셀 옆에 또 다른 녹색 픽셀이 있고, 그 옆에 갈색 픽셀이 있을 확률을 구하려는 것이 아니다
    * feature X가 주어졌을 때, Y의 분포만을 고려하면 된다
* 모형을 바꾸는 대신에 문제를 다시 정의해보자
    * X와 Y의 Joint Distribution을 구하는 대신 X가 주어졌을 때 Y의 조건부 확률분포를 구한다
        * model P(X, Y) => model P(X | Y)
    * 이제 X의 분포에 대해서는 신경쓰지 않는다. 따라서 feature들 간의 관련성에 대해서도 신경 쓸 필요가 없다
* 이제 CRF (Conditional Random Field) 의 수학적인 정의를 살펴보자
    * 각각 scope를 가지고 있는 factor 들의 집합이 있다
    * Gibbs Distribution을 구했던 것 처럼, factor 들을 모두 곱하면 unnormalized measure를 얻을 수 있다
    * 위에서 구한 unnormalized measure 를 가지고 Y에 대한 합계를 구한다
        * 이렇게 얻은 Partition Function은 X에 대한 함수가 된다
        * 이 함수는 X가 주어졌을 때 Y의 합계를 반환한다
    * Unnormalized measure를 Partition Function으로 나누면 normalize 된 확률 분포를 얻을 수 있다
        * X에 따라 달라지는 Family of Conditional Distribution

### CRFs and Logistic Model

CRF는 다른 머신러닝 모형들과도 밀접한 관련이 있다. 또한 logisitc 함수를 사용하는 베이지안 네트워크 모형도 떠오른다. X와 Y 모두 바이너리 확률 변수인 경우에 대해 살펴보자

* X, Y는 바이너리 변수이고, factor는 지수함수로 표현되는 모형이 존재한다
* CASE1 : `phi_i(Xi, Y = 1)`
    * Xi = 0 일 수도 있고,  Xi = 1일 수도 있다
    * 따라서 모형은 다음과 같이 표현된다
    * `phi_i(Xi, Y=1) = exp(Wi * Xi)`
* CASE2 : `phi_i(Xi, Y = 0)`
    * 우변이 무조건 exp(0)이 된다
    * `phi_i(Xi, Y = 0) = 1`
* 각 케이스에 따라 unnormalized density를 구할 수 있다
* Unnormalized density를 Partition Function으로 나누어보면 익숙한 형태의 식을 얻게 된다
    * 바로 Sigmoid 함수이다 ( e^z / (1 + e^z) )
* 여기서 알 수 있는 것은 바로 로지스틱 모형이 아주 단순한 형태의 CRF라는 사실을 알 수 있다
* 조건부 확률을 도입함으로써 X간의 상관관계를 고려하지 않고 모형을 구성할 수 있다
    * X 변수들이 모여서 Y 변수의 확률에 어떤 영향을 미치는지에 대해서만 고려할 수 있게 된다
    * feature의 개수가 늘어나더라도 각 입력변수들 사이에 어떤 상관이 있는지 고려할 필요가 없다

### CRFs for Image Segmentation

* Image Segmentation 문제에서는 보통 굉장히 다양한 feature를 사용한다
    * 색상 히스토그램
    * 질감
    * Discriminative patches (소의 눈 부분 같은)
* 위와 같은 feature 들은 서로 연관되어 있지만, CRF를 사용할 경우 그러한 연관성을 고려하지 않아도 된다
* 또한 SVM이나 부스팅같은 discriminative classifier를 사용할 경우 성능을 높일 수 있다
    * `P(Yi | X_bar)` : Y 변수에 대한 higher order features

### CRFs for Language

* 여기도 서로 관련성이 높은 다양한 feature 들이 존재한다
* P(labels | words) 를 구한다

### Summary

* CRF는 Gibbs Distribution과 같은 방식으로 표현되지만, normalize 방식이 다르다
    * 하나의 변수에 대해서만 Partition Function을 구하기 때문에 조건부 확률 형태로 표현된다
    * Logistic Regression 모형을 일반화한 형태이다
* 변수들 간의 분포에 대해서는 고려할 필요가 없다
* 잘못된 독립성 가정을 세우는 것에 대한 걱정 없이 높은 표현력을 가진 모형을 구성할 수 있다
