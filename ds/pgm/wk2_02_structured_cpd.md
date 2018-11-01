# Sructured CPDs

## Overview

지금까지 우리는 전체적인 분포의 구조에 대해서만 살펴보았다. 
전체 그래프를 factorize 해서 각각의 변수에 대응되는 factor들의 곱으로 표현할 수 있다는 것을 확인했다. 
하지만 그와 다른 유형의 문제들도 존재하며, 실제 문제를 해결하는데 중요하게 사용된다.

### Tabular Representations

* 확률 분포를 테이블의 형태로 표현할 수 있다
* G에 대한 확률분포를 표로 나타내보면 다음과 같다
    * row에는 G의 부모노드들이 가질 수 있는 모든 값의 조합을 나열한다
    * col에는 G가 가질 수 있는 값들을 나열한다
    * 각각의 칸에는 그에 맞는 확률값을 나타낸다
* binary 형태인 부모 변수가 k개 있다면 2^k 개의 행(변수들의 조합)이 필요하다
* 따라서 현실의 많은 문제들은 테이블 형태로 표현하는 것이 적합하지 않다

### General CPD

* 다행스럽게도 베이지안 네트워크에서는 모든 조건들에 대한 표를 작성할 필요가 없다
* 대신에 다음과 같은 확률분포를 정의해야 한다
    * `CPD P(X | y1, ... , yk)`
    * => y1, ... , yk 각각의 조건에 대한 X의 분포를 나타내는 CPD
* Factor를 구성하기 위해 어떤 함수를 사용해도 된다
    * y1, ... , yk 에 대한 모든 값의 합이 1이 되는 함수면 된다

### Many Models

* 다음과 같이 다양한 형태로 CPD를 정의하여 사용한다
    * Deterministic CPDs
    * Tree-structured CPDs
    * Logistic CPDs & Generalizations
    * Noisy OR / AND
    * Linear Gaussians & Generalizations

### Context-Specific Independence

* Context-Specific Independence 는 독립의 한 가지 종류이다
    * `P ㅑ (X ㅗc Y | Z, c)`
        * c는 C 변수에 특정한 값을 지정했다는 것을 의미한다
    * 변수 C를 특정한 값으로 조건을 부여했을 때 독립인 경우
* 다음과 같이 정의할 수 있다
    * `P(X, Y | Z, c) = P(X | Z, c) P(Y | Z, c)`
    * `P(X | Y, Z, c) = P(X | Z, c)`
    * `P(Y | X, Z, c) = P(Y | Z, c)`
* Y -> X 이고 X값은 y1과 y2의 OR 연산을 통해 결정된다고 할 때, context-specific 독립이 성립하는 것은 언제일까??
    * y2 = FALSE 라면 X는 y1과 같다 => 독립이 아니다
    * y2 = TRUE 라면 X는 y1과 상관없이 TRUE => 독립이다
    * X = FALSE 라면 y1, y2 모두 FALSE 여야 한다 => 독립이다
        * 각각의 y값들이 서로의 영향을 받아 결정된 것이 아니기 때문에 독립이라고 볼 수 있다
    * X = TRUE 라면 독립이 아니다
        * y1과 y2 중에 어느 쪽이 TRUE 일지 알 수 없다
