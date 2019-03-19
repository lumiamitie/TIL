# Introduction to the Causal Inference

## Introduction

이번 module에서는 다음과 같은 질문들에 대해서 살펴볼 것이다.

- *재산권이 경제 발전에 중요한가?*
- *생명 보험에 드는 것이 건강을 유지하는데 도움을 주는가?*
- *인류가 지구 온난화를 일으키고 있는가?*

이러한 문제에 답하기 위해서는 질문 자체를 명확하게 이해해야 한다

- 연구자들은 어떻게 특정한 문제의 원인(cause)을 찾아낼 수 있을까?
- **인과성(causality)이란 정확히 무엇을 말하는 걸까?**

이해를 돕기 위해 간단한 예제를 통해 살펴보자

- (1)
    - 아침이 되어 알람이 울렸다. 스누즈 버튼을 눌렀더니 알람이 멈췄다.
    - 스누즈 버튼을 누르지 않았다면 알람은 계속 울릴 것이다
    - 따라서 스누즈 버튼을 누름으로써 알람을 멈추게 만들었다 (*cause the alarm to stop*)
- (2)
    - 부엌으로 가서 아침을 먹자
    - 그릇에 시리얼과 우유를 부어서 먹기로 한다
    - 우유를 그릇에 부으면, 우유가 병으로부터 나온다 (*cause the milk to come out*)
- **Simple cause and effect:**
    - **One action directly causes one immediate result**
- (3)
    - 아침으로 무슨 메뉴를 먹을지 고민이다
    - 시럽이 듬뿍 담긴 팬케익 대신에 무설탕 시리얼과 무지방 우유를 먹기로 한다
    - 이러한 선택이 먼 미래에 건강하게 사는데 영향을 줄 수는 있지만, 너무 먼 시점의 일일 것이다
    - 진짜 건강해지고 있는 건지 빠르게 확인할 수도 없는데, 선택은 매일 아침 해야한다. 어떻게 결정해야 할까?
    - 심지어 아침 식사 말고도 수많은 결정들이 건강에 영향을 미친다 (운동 등등)
    - 시리얼만 먹으면서 매일 운동을 한다면 60년 뒤의 건강은 어떻게될까?
- **More complex causality:**
    - **Multiple causes over time with delayed and unclear effects**
- (4)
    - 미식축구 경기가 거의 끝나간다. 팀은 7점차로 뒤져있는데 우리 팀이 공격할 차례가 되었다.
    - 이 때 어떤 선택을 해야할까? 공격을 해야할까? 공격한다면 뛰어야 할까 패스해야 할까?
    - 터치다운에 성공해서 동점이 되었다. 이것은 어떤 선택의 영향을 받은 것일까?

비즈니스, 교육, 정부 등도 비슷한 문제를 겪는다.

- *상품의 가격을 올리면 어떻게 될까?*
- *의회가 새로운 법안을 통과시키면 어떤 일이 벌어질까?*
- 이러한 것들 모두 **인과성 (causality)** 과 관련된 문제들이다

기본적으로 인과성이라는 것은 **내가 무엇인가 행동했을 때 특정한 결과가 나오는 것**을 말한다.
**인과 추론 (Causal Inference)** 을 통해 정책의 변화가 현실 세계에 어떻게 변화를 만들어 내는지 찾아낼 수 있다.


## Measurement

인과성을 정량적으로 측정하기 위한 방법에 대해서 알아보자.

우선 우리가 이해하고자 하는 **변수**들을 측정할 수 있어야 한다.

- 인과 추론에서 변수(variable) 란 분석 단위의 특징을 말한다
- A "**variable**" in causal inference: **A characteristic of the "unit of analysis"** in the dataset
    - **Unit of analysis**
        - 국가, 도시, 기업, 사람 등 데이터 안에서 분석하고자 하는 단위를 말한다
        - Unit of Analysis 들의 집합을 **Population** 이라고 한다
    - **Variables**
        - 두 가지 주요 변수가 있다
        - (1) Outcome Variable
            - 영향을 미치고자 하는 특성을 말한다
            - 예를 들면, 건강
        - (2) Policy Variable (Treatment Variable)
            - Outcome Variable을 변화시키기 위해 사용할 수 있는 Unit of Analysis의 특성을 말한다
            - 예를 들면, 건강보험 가입 여부

분석을 위해서는 **변수들을 어떻게 측정할지 명확하게 정해야 한다**.

- "범죄발생수" 라고만 생각하면 너무 추상적이다
- "특정 블럭 안에서 발생한 차량 절도 사건" 정도 되어야 구체적으로 측정할 수 있다
- Treatment 로는 블럭 내의 경찰서 수를 세어볼 수 있다
- 항상 원하는 것을 측정할 수는 없다. 연구의 상당 부분은 다양한 변수를 어떻게 측정할지 고민하는데 소요된다.


## Description

이제 데이터 분석의 첫 번째 단계로 진입해보자 :

- **데이터를 설명해보자** (Describing)
- 각 변수별로 평균은 얼마일까? 가장 큰 값과 작은 값은 무엇일까?

인과성을 찾기 위해서는 policy variable에 따라 값이 다양하게 분포해야 한다.

- 예를 들면 모든 국가의 GDP가 동일하다면 경제 발전에 영향을 주는 요인을 찾기가 어렵다 (zero variation)
- 이러한 변동성은 분산이나 표준편차를 통해 측정할 수 있다

왜 변동성을 구체적으로 알아야 할까?

- 인과성을 측정하기 위해 다양한 policy variable을 기준으로 unit들을 비교해야 한다
- **policy variable에 따른 차이가 없다면 비교가 불가능**하다


## Correlation vs Causation

위에서는 특정 1개 변수에 대해서 설명하는 방법에 대해서 알아보았다.
이번에는 여러 변수를 설명하는 방법에 대해서 알아보자. (**Multivariate Descriptions**)

- GDP가 높은 나라들의 경우에는 강한 재산권이 있다면, 두 변수 사이에는 **양의 상관관계**가 존재한다고 볼 수 있다
- GDP가 높은 나라들의 경우에는 약한 재산권이 있다면, 두 변수 사이에는 **음의 상관관계**가 존재한다고 볼 수 있다

이제 이와 관련한 유명한 문구에 대해 살펴보자 : **상관관계가 인과관계를 의미하지는 않는다**

- 나무가 많아지면 도시가 안전해진다???

> If the outcome variable and the policy variable are correlated in the data, then that does not necessarily imply that the policy variable has a causal effect on outcomes.

**Selection Problem**

> when units select their own value of the policy variable, any correlations with outcomes are unlikely to be causal

- 사람들은 나무가 많은 곳에 살지 말지 결정할 수 있다
- 이 경우 outcome / policy variable은 인과관계라고 보기 어렵다
- 예를 들면,
    - 고소득자들은 범죄를 저지를 가능성이 낮다고 가정해보자
    - 그리고 고소득자들이 나무가 많은 곳에 살고 싶어한다고 가정해보자
    - 이렇게 되면 범죄수와 나무 사이에 음의 상관관계가 생길 수 있다
    - 하지만 두 변수 사이에는 아무런 인과관계가 없다
- 정확하게는 인과관계가 없다기 보다는, **인과관계라고 판단하기엔 데이터가 부족하다**고 보는 것이 명확하다

조금 덜 유명한 문구도 있다 :

- **적절한 인과관계 추론 기법을 적용하고도 아무런 상관관계를 찾을 수 없다면 outcome / policy variable 사이에는 인과 관계가 없다고 볼 수 있다**

> If there isn't any correlation anywhere in the data after applying an appropriate causal inference technique, then there indeed is no causal effect of the policy variable on the outcome.

정리해보면, 상관관계는 인과관계를 의미할 수도 있다. 다만 몇 가지 테크닉을 적용한 이후에 판단해야 한다.
