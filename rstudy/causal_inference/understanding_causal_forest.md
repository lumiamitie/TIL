# Causal Forest 이해하기

다음 포스팅의 내용을 일부 요약한다.

[CausalForest : Explicitly Optimizing on Causal effects via the Causal random forest](https://www.markhw.com/blog/causalforestintro)

특정한 처리(treatment)로 발생한 인과 효과에 최적화된 모형을 학습시키려면 어떻게 해야 할까? 
이러한 작업을 위해서는 lift, 즉 실험군과 대조군 사이에 발생할 결과값의 차이를 추정할 수 있어야 한다. 
결과인 Y변수를 예측하는 데만 집중하고 인과 관계를 무시하는 경향이 있는 대부분의 지도 학습 방법론과는 다른 방식이다. 
하지만 최근들어 머신러닝 쪽에서도 인과 관계, 특히 "heterogeneous treatment effects" 라는 주제에 집중한 논문들이 늘어나고 있다. 
최근 몇 년간 Treatment effects의 추정과 예측에 대한 흥미로운 논문이 많이 출간되었지만, 방법론을 제안하는 사람들과 사용할 사람들 사이의 간극이 존재한다. 
여기서는 모형이 동작하는 방식을 소개하고, 분석을 위한 R 코드를 제시하여 그 간극을 해소하고자 한다.

# Finding Heterogenous Treatment Effects

## 이론적 배경

- 목표는 각 개인별 인과 효과인 Y(Treatment) - Y(Control) 을 구하는 것이다
- 많은 방법론들이 Rubin Causal Model (Potential Outcomes model) 을 기반으로 모형을 정의한다
    - 어떤 사람이 treatment 대상자였다면, control 대상이었다면 어땠을지 예측하여 차이를 구한다
    - 현실에서는 절대로 일어날 수 없는 현상 → "the fundamental problem of causal inference"
- 한 가지 대안은 사람들을 서로 비슷한 두 개의 그룹으로 나누어 treatment / control 여부를 배정하는 것이다
    - 이렇게 하면 그룹 내의 평균적인 처리 효과(ATE, Average Treatment Effect)를 구할 수 있다. 이것은 샘플에 포함된 모든 사람들에 대해 treatment 배정되었을 때 얼마나 향상되는지(lift)를 구한 값이다.
    - 이를 위해서는 두 그룹이 실제로 "비슷한지" 를 확인할 수 있어야 하지만, 여기서는 동일 실험 내의 HTE를 찾는 것을 우선으로 하기 때문에 넘어간다
- HTE 와 관련된 연구는 대부분 다음과 같은 문제를 풀고자 한다
    - **서로 비슷한 프로파일을 가진 사람들이 조건에 따라 어떻게 결과가 달라지는지 비교하고, 이 차이를 바탕으로 Treatment 효과를 추정한다**

## Heterogenous Treatment Effects 구하기: An Overview

- HTE를 구하기 위해서는 Conditional average treatment effect(CATE) 를 구해야 한다
    - 주어진 공변량 조건에 대해서 treatment, control 양쪽 그룹 모두의 값을 예측하고, treatment 그룹의 추정치에서 control 그룹의 추정치를 빼면 해당 조건에 대한 CATE를 구할 수 있다
    - 따라서 고전적인 회귀 모형으로도 HTE를 구할 수 있다
- 그렇다면 왜 더 복잡한 모형이 필요할까?
    - 일반적인 문제에서는 변수를 1개만 다루지 않는다
    - 10개의 변수가 존재한다면 10개의 인터렉션이 존재하는지 확인해야 하는데, 이 경우 검정력이 크게 떨어진다
    - 또한 모든 변수들이 선형 관계를 가진다는 보장이 없다

# The Honest Causal Forests

Honest causal forests는 honest causal tree들로 구성된 랜덤 포레스트 모형을 말한다. 
Honest Causal tree가 기존의 의사결정 트리와 다른 점을 찾기 위해서는 다음 두 가지 질문에 대한 답을 해야 한다. 

1. 어떻게 인과 효과를 추정할 수 있는 것일까?
2. 무엇 때문에 Honest 한 트리가 되는 것일까?

## What Makes it causal?

- MSE를 최소화하는 일반적인 리그레션 트리와 달리, 인과 효과를 추정할 때는 Treatment Effect 에 관심이 있다
- 하지만 모든 데이터는 treatment와 control 그룹 중 하나에만 속할 수 있기 때문에, 우리는 실제 Treatment Effect 를 관측할 수 없다
- 그 대신 트리의 리프 노드에서 treatment 그룹과 control 그룹의 차이를 구하고 이를 treatment effect 라고 정의한다
- Causal tree는 노드를 분할할 때 다음과 같은 두 가지 기준이 균형이 맞는 지점을 찾는다
    - Treatment Effect 의 차이가 가장 커지는 지점을 찾는다
    - Treatment Effect 를 정확하게 추정한다
- 그냥 Y을 예측하고 조건에 따른 차이를 구하는 방법론보다 훨씬 인과관계에 가까운 답을 도출할 수 있다

## What makes it honest?

- 인과관계를 기준으로 트리를 나눌 때 오버피팅이 발생하지 않게 하려면 어떻게 해야 할까?
- 학습 데이터를 두 가지 그룹으로 나눈다 : 쪼개기용 vs 추정용
    - 쪼개기용 샘플에서는 위에서 논의한 분할 기준을 바탕으로 Causal Tree를 구성한다
    - 추정용 샘플에서는 leaf node 마다 treatment와 control 그룹의 평균 차이를 구한다


- Treatment Effect의 추정치는 근사적으로 정규 분포를 따른다
    - 따라서 분산을 통해 신뢰구간을 구할 수 있다
    - 또한 가설 검정을 통해 유의미한 효과가 존재하는 대상만 추출하는 것이 가능하다
