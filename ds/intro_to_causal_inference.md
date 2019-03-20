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


# Introduction to Treatment Effects

## The Average Treatment Effect

Causal effect는 사람마다 다른 정도로 발생할 수 있다.

- 즉, population에서 causal effect의 정도에 대한 분포가 존재한다
- 어떤 사람들에게는 긍정적인 효과가 발생할 수 있고, 누군가에게는 부정적인 효과가 발생할 수 있다

모든 사람들 각각에 대한 효과를 아는 것이 가장 이상적이다

- 이 경우에는 모든 treatmetn 각각에 대해서 가장 이상적인 결정을 내릴 수 있다
- 의사들이 개별 환자들에 대한 효과를 모두 알고 있다면, 가장 적합한 약을 처방할 수 있을 것이다

만약 Causal effect의 분포를 알고 있다면 (모든 사람의 효과를 안다면) 다양한 값을 구할 수 있다. 예를 들면,

- 긍정적인 효과가 발생하는 사람들의 비율
- Medicaid 의 수혜를 받는 사람이 얼마나 되는가
- 특정 약이 효과가 있는 사람이 얼마나 되는가?

문제는 우리가 unit level의 causal effect를 알 수 없다는 것이다.
동일한 사람이 treatment 그룹과 not treatment 그룹에 동시에 속할 수는 없다.

만약 개개인의 효과는 모르더라도 Causal effect의 분포를 알고 있다면 전반적인 수치들은 얻어낼 수 있을 것이다.
이러한 내용들은 종종 필요하지만, 알아내기 어려운 것들이다.
할 수는 있지만 일반적으로 많은 가정들이 필요하고, 어렵다.

이러한 문제들로 인해 흔히 사용하게 되는 방식이 바로 **Average Treatment Effect** 라는 것이다.
모든 사람들에 대한 unit level causal effects를 평균하여 구한다.

Average Treatment Effect는 전반적인 효과를 잘 대표하기도 하지만, 평균만으로는 부족할 때도 있다.
따라서 최대/최소 효과같이 causal effect의 전반적인 분포에 대해서도 확인해야 한다.
하지만 이러한 값들은 평균보다 구하기 어렵다.

**Average Treatment Effect**

- (1) 모든 사람들이 Medicaid의 혜택을 받고 있다고 생각해보자
    - 그리고 사람들의 수치를 관찰한다
    - 이 경우의 사람들의 평균 결과값은 Medicaid 혜택에 대한 평균이라고 볼 수 있다
    - Average Outcome under Policy
- (2) 아무도 Medicaid 혜택을 받지 않을 때 사람들의 결과값을 관찰해보자
    - 이 경우 사람들의 평균 결과값은 Medicaid 혜택이 없을 때의 평균이다
    - Average Outcome without Policy
- Average Treatment Effect는 이 두 가지를 뺀 값이다
    - **ATE = Average Outcome under Policy - Average Outcome without Policy**
- 이 값이 바로 평균적인 unit level causal effect를 나타낸다
- 수치가 클수록 좋은 상황이라고 가정해보자 (GDP 같은 수치)
    - 이 경우 일반적인 해석은 Average Treatment Effect 가 양수일 경우 좋은 정책이라는 것이다
    - 평균적으로 해당 treatment가 GDP의 증가를 일으킨다는 것을 의미한다
    - 음수일 경우은 반대의 효과, 0에 가까울 경우에는 큰 의미 없다고 해석할 수 있다

## The Unit Level Effect

Causal Effect를 정량적으로 측정하기 위해서는 우리가 어떤 것에 대한 평균을 구하고 있는 건지 알아야 한다.
Medicaid 또는 콜레스테롤의 Causal Effect 라는 것은 구체적으로 무엇을 말하는 것일까?

Unit 하나 (여기서는 사람 1명) 에 대해서만 생각해보자.

- Medicaid 여부를 포함하여 콜레스테롤 수치에 영향을 줄 수 있는 요인들은 모두 적어본다
- 특정 unit에 대한 콜레스테롤 수치에 대한 Medicaid의 causal effect는 다음과 같이 정의할 수 있다
    - 다른 조건들이 모두 동일할 때,
    - *해당 unit이 Medicaid에 들었을 때 콜레스테롤 수치 - Medicaid에 안들었을 때 콜레스테롤 수치*

이러한 정의에는 몇 가지 중요한 포인트가 있다.

- (1) 특정 unit에 대한 causal effect 라는 점이다
- (2) causal effect는 다른 변수가 모두 동일할 때의 **차이값(difference between values)** 이다
    - 이 때, 다른 변수의 값을 바꾸고 차이값을 구한다면 다른 causal effect 를 얻게 될 것이다
    - 이것을 **Interaction Effect** 이라고 한다
    - 좋은 식습관을 가지고 있을 때 Medicaid의 causal effect가 0이고 식습관이 나쁠 때는 양의 effect를 가질 수 있다

위 두 가지 경우를 통틀어서 causal effect에 **heterogeneity** (이질성) 가 존재한다고 말한다.

- 서로 다른 두 사람의 causal effect는 다를 수 있다
- 동일한 사람에 대해서도 다른 변수의 개입에 따라 특정 변수의 causal effect가 달라질 수 있다

두 가지 결론을 상상해 볼 수 있다.

- Medicaid를 들었을 때의 결과, 들지 않았을 때의 결과

하지만 현실에서는 두 가지 결과를 동시에 관찰할 수 없다. 이것을 **인과추론의 근본적인 문제**라고 한다.

이러한 문제를 어떻게 해결할 수 있을지 알아보자.

## The Conditional Average Treatment Effect

단일 unit이 아니라 특정한 그룹의 unit 들에 대한 효과를 측정할 수는 없을까?

- **Conditional Average Treatment Effect**
    - 전체 population에서 일부에 대한 ATE를 말한다
    - 예를 들면, 남성/여성에 대한 effect

| Person | Sex  | Outcome(w. Treatment) | Outcome(wo. Treatment) | Unit Causal Effect |
| ------ | ---- | --------------------- | ---------------------- | ------------------ |
| 1      | M    | 40                    | 30                     | 10 (= 40 - 30)     |
| 2      | M    | 20                    | 20                     | 0 (= 20 - 20)      |
| 3      | F    | 10                    | 15                     | -5 (= 10 - 15)     |
| 4      | F    | 30                    | 30                     | 0 (= 30 - 30)      |

위 표에서 각각의 사람들에 대한 causal effect는 아래와 같이 구할 수 있다.

- **causal effect** = outcome with treatment - outcome without treatment
- 하지만 현실 문제에서 실제로는 두 값을 모두 구할 수 없다
- 우리는 모든 사람들에 대해서 두 개의 그룹 중 하나의 값만 알 수 있다

여기서 **ATE**는 다음과 같다.

```
ATE = (10 + 0 + (-5) + 0) / 4 = 5/4
```

**CATE(men)** 을 구해보자. 남성 그룹에 대해서만 Unit Causal Effect의 평균을 계산하면 된다

```
CATE(men) = (10 + 0) / 2 = 5
```

**CATE(females)** 는 다음과 같다.

```
CATE(females) = (-5 + 0) / 2 = -5/2
```

결과를 해석해보자.

- 전체적으로는 5/4 로 positive 효과를 보인다
- 남성에 대해서는 5 : positive 효과이면서 효과가 전체대비 훨씬 크다
- 여성에 대해서는 -2.5 : negative 효과가 발생했다
- 성별에 따라 다른 효과가 발생했다는 것을 확인할 수 있다
