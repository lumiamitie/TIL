다음 포스팅의 내용을 간단히 정리할 예정

[Stopping stepwise: Why stepwise selection is bad and what you should use instead](https://towardsdatascience.com/stopping-stepwise-why-stepwise-selection-is-bad-and-what-you-should-use-instead-90818b3f52df)

# Why Stepwise Selection Bad?

Frank Harrell은 Stepwise 방법의 문제점을 다음과 같이 정리했다.

1. R^2 값이 실제보다 크게 편향되어 추정된다
2. F 통계치의 실제 분포가 가정과 다르다
3. 파라미터 추정량의 표준 오차가 실제보다 작게 추정된다
4. 따라서 파라미터 추정량의 신뢰구간이 실제보다 좁게 계산된다
5. 다중 비교로 인해 p-value가 너무 낮게 나오고, 교정하기 어렵다
6. 파라미터 추정량이 0이 아닌 결과가 나오도록 편향되기 쉽다
7. 공선성 문제가 심각해진다

파라미터가 0이 아닌 방향으로 편향되기 쉽고, 따라서 가설검정 결과와 신뢰구간이 잘못되었을 가능성이 높다.
또한 이러한 문제를 교정하기 위한 방법이 없다.

# Terminology

변수 선택 방법은 회귀 모형에서 특정한 독립 변수를 선택하기 위한 방법론이다.
최적의 모형을 찾기위해 사용하는 경우도 있고, 변수가 너무 많을 때 적당히 줄이기 위해 사용하기도 한다.
Stepwise 방법론 중에서 종종 사용되는 것은 다음과 같다.

- **Forward selection**
    - 아무런 변수도 선택하지 않은 Null Model로부터 시작한다
    - 각 단계별로 가장 유의한 변수를 하나씩 추가한다
    - 기준에 맞는 변수가 없을 때까지 반복한다
- **Backward selection**
    - 모든 변수가 선택된 상태에서 시작한다
    - 가장 덜 유의한 변수를 하나씩 제거한다
    - 기준에 맞는 변수가 없을 때까지 반복한다
- **Stepwise selection**
    - forward, backward 방법론 섞어서 사용한다
    - 안정된 변수를 얻을 때까지 변수를 추가하고 제거하는 것을 반복한다
- **Bivariate screening**
    - 각 변수별로 종속변수와 비교하여 유의미한 관계를 가지는지 확인한다
    - 종속변수와의 관계가 유의미한 모든 변수를 선택한다

# Why These Methods Don't Work?

가장 큰 문제는 **한 번의 테스트를 위해 만들어진 방법을 여러 번에 걸쳐서 사용하고 있다는 점이다.**

동전을 열 번 던져서 열 번 모두 앞면이 나왔다면, 무엇인가 수상하다는 생각이 들 것이다.
동전의 앞면이 나올 확률이 0.5라고 할 때, 이러한 상황이 등장할 확률이 매우 낮다는 것을 계산할 수 있다.
10명의 사람들에게 동전을 각각 열 번씩 던지라고 해보면 그 가능성을 대강 구할 수 있다.

**만약 몇 명인지도 모르는 친구들에게 몇 번 던져야한다고 말하지도 않았는데 동전을 마구 던진 결과
앞면이 10번 나왔다면, 이게 얼마나 나옴직한 상황인지 계산할 수 없다. 이것이 바로 stepwise 방법론이다.**

# Alternatives to Stepwise Methods

- **A Full(er) Model**
- **Expert Knowledge**
- **Model Averaging**
- **Partial Least Squares**
- **Lasso**
- **LAR (Least Angle Regression)**
- **Cross Validation**
