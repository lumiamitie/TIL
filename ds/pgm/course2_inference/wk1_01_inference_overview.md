# Week1 : Inference Overview

## 1.1 Overview: Conditional Probability Queries

이전까지는 다양한 확률적 그래피컬 모형을 표현하는 방법에 대해서 알아보았다.
이제는 모형을 통해 실제 결과를 얻어내는 방법에 대해서 알아볼 것이다.
PGM 을 통해 결과값을 도출하는 방법 중에서 다장 널리 사용되는 것 중 하나는 바로 Conditional Probability Query 라는 것이다.
먼저 Conditional Probability Query 를 정의해보자.


### Conditional Probability Queries

* **Evidence** : `E = e`
    * 관찰값들의 집합
* **Query** : a subset of variables Y
    * 우리가 알고자 하는 값
* **Task** : compute `P( Y | E=e )`
    * 우리의 목표는 관찰값 e가 주어졌을 때, Y의 조건부 확률 분포를 구하는 것이다

### NP-Hardness

* 안타깝게도 PGM을 통한 **Inference 문제는 NP-Hard** 문제이다
    * NP-Hard : 효율적인 해결방법을 찾는 것이 거의 불가능한 상황을 말한다
* 구체적으로 어떤 부분이 NP-Hard한 것일까? 다음 문제들은 모두 NP-hard 문제이다
    * PGM P, 변수 X, X의 값 x가 주어졌을 때, P(X=x) 을 계산하는 것
    * P(X=x) > 0 인지 여부를 판단하는 문제도 마찬가지다
* 특정한 상황에서는 정확도를 일부 포기하고 근사적인 해답을 얻을 수 있다
* 하지만 다행인 것은, 위와 같은 상황이 Worst Case에 대한 설명이라는 것이다
    * 많은 경우 다항시간 내에 해결할 수 있지만, 모든 경우에 적용하지는 못한다는 것을 의미한다

### Sum-Product

* Inference 문제를 한 번 살펴보자
* 우리의 목표는 주어진 그래피컬 모형에서 P(J) 를 계산하는 것이다
    * Joint Distribution에서 P(J)를 구하기 위해서는 J 변수를 제외한 나머지 변수는 모두 제거하거나 marginalzie 해야 한다
    * 다시 말하자면, J를 제외한 나머지 모든 변수에 대해 더해야한다
    * 이와 같은 이유로 Conditional Probability Inference 를 종종 Sum-Product 라고 한다
        * factor들의 product를 합하기 때문이다
* 합하기만 하면 아직 normalize 되어있지 않은 상태기 때문에 실제로는 p tilda 값이 계산된다
    * Partition Function으로 나누어주어야 한다
    * `P(D) = 1/Z * P_tilda(D)`

### Evidence : Reduced Factors

* Evidence는 factor Reduction이라는 전처리 과정을 통해 구할 수 있다
* `P( Y | E=e ) = P(Y, E=e) / P(E=e)`
    * `W = {X1, ... , Xn} - Y - E` 라고 정의해보자 (query도 evidence도 아닌 모든 변수의 집합)
    * 분자 부분은 다음과 같이 정리할 수 있다 : `P(Y, E=e) = Sum_w( P(Y, W, E=e) )`
    * 다시 정리하면 Factor Product 형태가 되는데, 이 과정에서 Evidence와 연관된 Factor만 남게된다
    * 이것을 Y (query) 에 대해서 marginalize 하면 분모에 해당하는 값이 된다

### Algorithms : Conditional Probability

Conditional Probability Query를 구하기 위한 여러 가지 알고리즘이 존재한다.

1. **Push Summations into factor product**
    * Variable elimination (Dynamic Programming의 일종)
2. **Message Passing over a graph**
    * Belief Propagation
    * Variational approximations
3. **Random sampling instantiations**
    * Markov Chain Monte Carlo (MCMC)
    * Importance Sampling
