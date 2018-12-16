# Introduction

## Motivation

두 가지 예시를 중심으로 살펴보자.

- 의료 진단 (Medical diagnosis)
    - 환자로부터 다양한 정보를 수집한다
    - 환자가 어떤 병에 걸렸는지, 어떻게 치료해야 하는지 파악한다
- 이미지 분할 (Image Segmentation)
    - 각 픽셀에 해당하는 것이 무엇인지 파악한다
        - 픽셀 => 풀, 하늘, 물, 소, 말, ...

두 문제의 공통점은 무엇일까?

1. 다양한 변수가 연관되어 있다.
2. 아무리 알고리즘을 잘 설계하더라도 상당히 큰 불확실성히 존재한다.

Probabilistic Graphical Models는 위와 같은 문제를 해결하기 위한 프레임워크이다.


## Probabilistic Graphical Models

확률론적 그래픽 모형(Probabilistic Graphical Models)에서 각 단어가 의미하는 바에 대해서 알아보자.


### Models

#### 모형이란 무엇인가?

**모형(model) 이란 세상에 대한 이해를 선언적으로 표현한 것**을 의미한다. **선언적(declarative)** 이라는 것은 표현 자체가 독자적인 의미를 갖는다는 것을 말한다. 우리는 모형 자체를 들여다 볼 수 있으며, 적용하고자 하는 알고리즘과는 별개로 존재한다.

#### 모형은 왜 중요할까?

동일한 모형이라도 다양한 맥락 속에서 존재할 수 있다. 

- 특정한 문제를 해결하기 위한 알고리즘
- 동일한 문제를 더 효율적으로 해결하기
- 정확도와 속도 간의 트레이드 오프

우리는 모형과 적용하려는 알고리즘을 분리시킬 수 있다. 이러한 방식으로 다양한 문제를 더 잘게 쪼개어 생각할 수 있다. 

### Uncertainty (probabilistic)

#### probabilistic의 의미

**확률론적(probabilistic)은 많은 양의 불확실성을 다룰 수 있도록 모형을 구성한다는 것**을 의미한다. 불확실성은 다양한 형태로 존재하고, 다양한 이유로 발생한다

1. 우리는 세상에 대해 제한적인 지식만 가지고 있다
2. 관측한 결과에 노이즈가 섞여 있다
3. 모형이 완전하지 못해서, 모형으로 설명하지 못하는 현상이 있다
4. 세상은 본질적으로 확률에 의해 돌아간다

#### Probability theory

세상에 불확실성이 존재하기 때문에, 확률 이론(Probability theory)을 통해 불확실성을 다루려고 한다. 확률 이론은 다음과 같은 것들을 제공한다.

1. 명확한 문법을 통한 선언적인 표현
2. 강력한 추론 패턴
3. 잘 구성된 학습 방법

### Complex System (graphical)

#### graphical의 의미

여기서 *graphical* 이라는 용어는 컴퓨터 과학의 관점에서 사용된다. Probabilistic graphical models는 통계와 컴퓨터 과학의 개념들을 합쳐서 구성되었다. 복잡한 시스템을 다룬다는 의미로 *graph* 라는 용어를 사용하였다. 많은 요인을 포함하고 있는 공간에 대한 확률 분포를 포착하기 위해, 각 확률 변수에 대한 분포를 알아야 한다. 세상이 X1 부터 Xn 까지의 변수로 표현된다고 생각해보자. 우리는 세상을 나타내는 불확실성을 확률분포의 형태로 찾아낸다. 아주 단순한 바이너리 형태의 변수라고 해도, 세상의 상태를 나타내고 있는 분포의 일종이라 볼 수 있다.

#### Graphical models

Graphical models에는 크게 두 가지 종류가 있다

1. Bayesian Networks
    - 방향성을 가지는 노드로 구성되어 있다
    - 그래프 사이의 노드들이 확률 변수를 의미한다
2. Markov networks
    - 방향성이 없는 그래프를 사용한다

Graphical models 에는 다음과 같은 장점이 있다

- 고차원의 확률분포를 압축적으로 표현하고, 인사이트를 제공한다
- 그래프 구조를 기반으로 범용적인 알고리즘을 구성하고, 효율적인 추론을 제공한다
- 고차원의 변수를 적은 수의 파라미터로 표현할 수 있게 된다 (전문가에 의해 구성되거나 데이터를 통해 학습한다)


# Overview

Probabilistic graphical models과 관련된 세 가지 내용에 대해 학습할 예정이다.

1. Probabilistic graphical models에 대한 표현
    - Directed and undirected
    - Temporal and plate models
2. 추론
    - Exact and approximate
    - 의사 결정
3. 학습
    - 파라미터와 구조
    - 완전한 데이터가 존재하는 경우 / 존재하지 않는 경우

# Distribution

Probabilistic graphical models에 대해 자세히 살펴보기 전에, 확률 분포에 대해 살펴보자.

## Joint Distribution

Intelligence(I), Difficulty(D), Grade(G) 라는 세 가지 변수가 있다고 가정해보자. 이 때, 세 가지 변수로 만들어 낼 수 있는 조합 각각에 대한 확률 분포를 구한 것을 Joint Distribution이라고 한다. I, D, G 변수가 각각 2, 3, 3 가지 조합이 가능하다면 이 분포의 파라미터는 총 12개가 된다 (2x3x3)

## Independent parameters

파라미터 중에서 다른 파라미터 값에 영향받지 않는 것들을 말한다. 위 경우에서 Independent parameter는 11개이다(12 - 1). 다른 11개의 파라미터를 알 고 있을 경우 마지막 파라미터의 값을 알 수 있기 때문이다.

## Conditioning

- Reduction
    - 내가 관찰한 것(목표로 하는 변수)과 관련없는 것들은 제거한다
- Renormalization
    - *unnormalized* 상태라는 것은 합해서 1이 되지 않는다는 것이다
    - unnormalized measure를 확률 분포로 변환시키려면 normalize 해야 한다.
    - 모든 항목의 합을 구하고 해당 값으로 모든 항목을 나눈다
    - P(I, D, G=g1) => P(I, D | g1)

## Marginalization

다양한 변수들에 대한 확률 분포를 알고 있는 상황에서, 더 적은 변수들에 대한 확률 분포를 계산하는 것을 말한다.

ex. P(I, D)를 알고 있을 때 D에 대한 모든 값을 합할 경우 P(I)를 알 수 있다.


# Factor

## Factor는 무엇일까?

Factor는 **함수**이거나 **표**다.

- 여러 개의 argument를 받는다
- 확률 변수가 주어지면 각각에 대한 값을 반환한다
- X1부터 Xk 까지 확률 변수가 있다면, 각 변수로 만들어 낼 수 있는 모든 조합을 받고 각각의 조합에 대해 특정한 값을 반환한다
- 이 때 {X1, ..., Xk} 를 이 factor의 **scope**라고 한다

Factor의 예시는 다음과 같은 것들이 있다.

- Joint Distribution은 factor이다. 
    - P(I, D, G)의 모든 조합에 대해 확률값을 주기 때문이다.
- normalized 되지 않은 P(I, D, g1)도 factor이다.
    - 다만 이 경우에는 **scope가 {I, D}**가 된다. 
- Conditional Probability Distribution (CPD)도 factor에 해당된다
    - P( G | I,D )
    - 모든 I, D의 조합에 대해서, G에 대한 확률분포를 가지고 있다는 것을 의미한다

반환하는 값이 확률이 아닐 수도 있다. 이 경우 **general factor** 라고 한다.


## Factor Operation

- Factor Product
    - 두 개의 factor를 받아서 곱한다
    - ph1(A, B) : scope가 {A, B}인 factor
    - ph2(B, C) : scope가 {B, C}인 factor
    - ph1 * ph2 = scope가 {A, B, C}인 factor가 된다
- Factor Marginalization
    - 확률 분포에서의 Marginalization 과 비슷하다
    - scope {A, B, C}인 factor가 있고 B에 대해서 Marginalization 할 경우 scope {A,C}인 factor가 된다
- Factor Reduction
    - C == c1 인 특정한 경우로만 필터링한다
    - C에 대한 의존이 사라지기 때문에 scope {A, B}인 factor가 된다

## 왜 factor를 사용할까?

- 고차원 공간에서 분포를 구성하는 기본적인 단위로 사용된다
- 다양한 operation을 통해 분포를 조작할 수 있다
