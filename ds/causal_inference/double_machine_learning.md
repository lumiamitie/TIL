# Double Machine Learning 이란 무엇일까?

[Orthogonal/Double Machine Learning - econml 0.12.0 documentation](https://econml.azurewebsites.net/spec/estimation/dml.html#dmluserguide)

- Double Machine Learning 은 교란변수와 대조군(confounders/controls)이 모두 관측된 상황에서 heterogeneous treatment effects 를 추정하는 방법이다.
    - 기존의 통계적 방법론을 사용하기에는 변수가 너무 많은 상황에서 비모수적인 접근을 하고자 할 때 사용할 수 있다.
- 어떻게 학습할까?
    - (1) 먼저 두 가지 예측 작업을 한다.
        1. Control 을 통해 결과 변수(Outcome)를 예측한다.
        2. Control 을 통해 Treatment 를 예측한다.
        - Doubly Robust Learning 과의 차이점
            
            Doubly Robust Learning 에서는 다음과 같이 예측한다.
            
            1. Treatment와 Control 을 통해 결과 변수(Outcome)를 예측한다.
            2. Control 을 통해 Treatment 를 예측한다.
    - (2) 두 모형을 통합하여 최종적으로 HTE 를 예측한다.
- DML의 장점
    - $\theta(X)$ 에 대해 모수적으로 가정을 하면 추정속도가 매우 빨라지고, 많은 경우에 $\hat\theta$ 를 추정하는 과정에서 점근적인 정규성을 달성할 수 있다.
    - 이러한 특성을 위해서는 nuisance estimates 을 cross-fitting 방식으로 학습해야 한다.
