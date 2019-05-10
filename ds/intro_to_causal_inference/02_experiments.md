# Introduction

## Introduction to Experiments

상관관계가 있는 두 변수가 인과관계가 있는지 여부를 어떻게 알 수 있을까?

- 이베이 총판매량과 Sonoma County의 강수량은 높은 상관관계 (0.999) 를 보인다
- 이베이 총판매량과 애플 아이폰 판매량 사이에도 높은 상관관계 (0.994) 가 있다
- 두 경우 모두 높은 상관관계가 있지만 인과관계가 존재하는지는 알 수 없다

인과관계를 파악하는 것은 어렵다.

- 데이터를 많이 가지고 있지 않기 때문에, 그저 우연히 발생한 사건일 수도 있다
- 정확한 판단을 위해 실험을 하고싶어도, 비가 내릴지 말지를 우리가 결정할 수는 없다

## Controlled Experiments

이번에는 인과 관계를 학습하기 위한 다른 방법에 대해서 알아보자.
가장 오래되었으면서도 확실한 방법은 실험(**Experiments**)을 하는 것이다.

Unit Level Causal Effect에 대해서 생각해보자.

- 다른 모든 변수들이 고정되어 있을 때 Treatment 그룹과 Control 그룹의 결과값 차이를 말한다
- Unit Level Causal Effect 를 찾는 가장 쉬운 방법은 **treat 여부만 다르고 나머지는 모두 동일한 2개의 unit을 찾아서 비교**하는 것이다
- 이게 바로 **Controlled Experiments** 의 컨셉이다
- 광고에서 종종 나오는, 자사 제품과 타사 제품을 직접 비교하는 것이 controlled experiment의 일종이다

만약 모든 변수를 완벽하게 통제할 수 있다면 단 2개의 관측값만 가지고도 causal effect를 구할 수 있다.
실제 문제에서는 더 많은 정보들을 수집하겠지만, 인과관계를 확인하는 측면에서 중요한 것은 한 unit은 treat되고 다른 한 unit은 treat 되지 않아야 한다는 점이다

하지만 사회과학의 문제들에는 Controlled Experiments 를 적용할 수 없다.

1. 변수를 측정하는 것이 너무 어렵다
    - 우선, 목표로 하는 변수를 측정하는 것이 어렵다
    - 그리고 다른 변수들을 모두 동일하게 유지해야 하는데, 동일한지 아닌지 정확하게 판단하기 어렵다
2. 고려해야 할 변수들이 너무 많다
    - 각각의 변수들을 모두 측정한다고 하더라도 동일한 조건으로 맞추기가 어렵다

위와 같은 문제점들로 인해 Controlled Experiments 를 사용할 수 없다. 그러면 어떻게 해야 할까?

이런 상황에서는 **Randomized Experiments** 를 사용해야 한다.


# Randomized Experiments & Statistical Inference

## Randomized Experiments

**Randomized Experiments** 는 많은 수의 unit이 있을 때 treatment 또는 control 그룹으로 랜덤하게 나누는 방식의 실험을 말한다.
treatment 그룹에는 treat 된 unit들만, control 그룹에는 treat 되지 않은 unit 들만 존재한다.

이런 방식의 실험이 인과관계를 밝히는데 어떻게 도움이 될까?

- **Controlled Experiments** 에서는 두 unit이 treat 여부를 제외한 모든 부분에서 동일해야 한다
- **Randomized Experiments** 에서는 treat 여부를 결정하기 이전에 **모든 unit을 랜덤하게 배치** 한다
    - 두 그룹에 unit을 랜덤하게 배치하고 그룹의 규모가 크다면, 두 그룹은 서로 비슷해진다
    - 이렇게 하면 두 그룹의 특성이 정확하게 동일하다고 볼 수는 없지만, 각 그룹의 평균은 같아질 것이다
- 정말 랜덤하게 잘 배치되었다면, 두 그룹의 밸런스가 유지된다
    - 예를 들면, 특정 그룹에는 여성이 더 많이 속해있다거나 하는 일이 발생하지 않게 된다

우리가 다룰 변수들은 세 가지 종류가 있다

- **Outcome** Variables
- **Treatment (Policy)** Variables
- **Pretreatment** Variables : treatment 반영하기 이전에 존재했던 변수들

Randomization은 pretreatment variable 들이 균형잡히게 나누어지도록 배치한다.
treatment variable에는 적용되지 않는다. treatment variable 들은 treat 여부에 따라 그룹이 달라진다.

따라서 **Randomized Experiments 는 다음과 같은 효과** 를 갖는다.

- Randomization 을 통해 분리된 두 그룹은 모든 pretreatment variable이 평균적으로 동일하다
- 두 그룹은 treatment 여부만 다르다
- 이러한 상황에서는 **어떤 평균적인 차이가 발생할 경우, treatment 여부에 따른 결과** 라고 볼 수 있다
- *"The treatment has a causal effect on outcomes."*

Randomized experiments 를 가지고 인과 관계가 있다고 말하기 위해서는 각 그룹에 많은 unit이 있어야 한다.

- Controlled experiments 에서는 2개의 unit만 있으면 된다
- 하지만 Randomized experiments 의 경우 unit의 수가 적으면 극단적인 값이 있을 때 평균에 큰 영향을 미칠 수 있다
- 따라서 두 그룹이 평균적으로 비슷해지기 위해서는 각 그룹의 크기가 충분히 커져야 한다

실제로 활용하기 위해서는 각 그룹의 크기가 어느 정도 되어야 하는지 궁금할 것이다.

- 잘 알려진 통계적 기법들을 활용해 정확한 수치를 구할 수 있다
- 여기서 직접 해당 기법들을 다루지는 않겠지만, 인과관계를 밝히기 위해서는 많은 데이터가 필요하다는 것을 명심하자

Randomization 기법을 사용할 경우 이후의 분석 작업이 굉장히 간단해진다는 장점이 있다.

- treatment 그룹과 control 그룹 간의 평균의 차이를 계산하면 바로 ATE를 구할 수 있다
- ATE = Average Value of Treatment Outcome - Average Value of Control Outcome

## p Values, Confidence Intervals, and Hypothesis Tests

신뢰구간은 P-value, 가설 검정과 어떻게 연관되어 있을까? 다트 게임을 통해 알아보자.

- Control Group 은 일반 다트를 사용한다
- Treatment Group은 레이저 조준경을 사용한다
- 일단 두 그룹의 평균만 놓고 보면 Treatment Group의 평균이 중앙과 더 가까운 것을 확인했다
- 그렇다면 레이저 조준경을 사용하는 것이 높은 득점을 올리는데 도움이 되었을까?

다트를 반복해서 던지다 보면 **다트가 중앙에서 얼마나 떨어져있는지에 대한 분포** 를 구할 수 있다.
CLT (중심극한정리) 에 의해 해당 분포가 정규분포의 형태를 따른다는 것을 알 수 있다.

- **전통적인 가설 검정(Hypothesis Test)** 에서는 다음과 같은 형태로 효과를 확인한다
    - Treatment로 인해 발생한 실제 효과가 없다고 (0이라고) 가정한다
    - 실험을 여러번 반복할 경우 두 그룹간 평균의 차이는 어떤 형태의 분포를 따르게 될까?
    - CLT에 의해 정규분포를 따를 것이므로 95%의 확률로 0 부근에 존재할 것이다
    - 정확히는 [-1.96, 1.96] 구간 안에 95% 확률로 존재한다
    - 만약 해당 구간을 넘어간다면, 평균의 차이가 0이라는 기존의 가설을 기각할 수 있을 것이다
- 이제 이 과정을 **P-value** 를 이용해 진행해보자
    - 평균의 차이가 0일 때, 데이터를 통해 계산한 ATE 값이 나올 수 있는 확률을 계산한다
    - 이것을 P-value 라고 한다
    - 따라서 P-value가 0.05 보다 작을 경우 효과가 없다는 귀무가설을 기각한다
- **신뢰구간(Confidence intervals)** 을 통해서도 비슷한 테스트를 할 수 있다
    - treatment에 따른 차이가 없을 때를 가정한 분포가 존재한다
    - 실험을 여러 번 반복하다 보면 ATE를 중심으로 하는 분포로 이동한다
    - 이동한 분포를 기준으로 95% 신뢰구간을 구한다 : `[ATE - 1.96*SE, ATE + 1.96*SE]`
    - 신뢰구간이 0을 포함하지 않을 경우, 귀무가설을 기각할 수 있다

세 가지 방식 모두 기본적인 컨셉은 비슷하다.

# Practice with Published Experiments - The Oregon Health Insurance Experiment

## The Design of the Oregon Health Experiment

2008년에 오레곤주는 Medicaid 대상자를 저소득층 성인들까지 확대하기로 하였다.
따라서 9만명 가량의 사람들이 Medicaid에 추가로 참여하게 되었다.
하지만 주정부는 신청자 전원을 처리할 수 있을 정도의 예산을 보유하고 있지 않았다.
결국 주에서는 추첨을 통해 Medicaid 참가 여부를 결정하게 되었다.

- 실험 설계를 간단히 살펴보면 다음과 같다
    - Submitted name for lottery (n=89824) : Medicaid 전체 신청자
    - Excluded (n=14902) : 전체 신청자 중에서 제외되어야 하는 사람들
        - Gave address outisde of Oregon (n=36)
        - Not age 19-62 on Jan 1, 2008 (n=3258)
        - Gave group or institutional address (n=5161)
        - Signed up by unrelated third party (n=5708)
        - Died prior to the notification date 9 (n=134)
        - Multiple active observations (n=605)
    - Included in Oregon Health Insurance Experiment (n=74922) : 추첨 대상자들
    - Treatment (n=29834)
        - In-Person Survey Sample (n=10405) : 1년 뒤에 질문지 발송
        - Survey Responders (n=6387) : 응답한 사람들 (응답률은 73.4%)
            - Enrolled in OHP (Oregon Health Program) (n=1903)
            - Not enrolled in OHP (n=4484) : 이 사람들은 실제로는 treatment 대상자가 아니다
    - Controls (n=45088)
        - In-Person Survey Sample (n=10340)

위 실험에서는 발생한 문제점이 발생했다.

- 추첨을 통해 랜덤하게 그룹을 나누었지만, 설문에 대한 응답을 받는 과정에서 상당량의 정보가 누락되었다
- 응답한 대상자 중에서 Oregon Health Program에 가입된 대상자의 비율이 너무 낮다 (약 30%)
    - treatment 그룹에 속해있지만 실제로 treat 되지 않은 대상자가 너무 많다
    - 이러한 unit을 Noncompliers 라고 한다
- treatment 그룹에 속해있는데 treat 되지 않거나, control 그룹에 속해있는데 실제로는 treat 처리된 unit들을 **Noncompliers** 라고 한다

## Depression in the Oregon Health Experiment

- 실험 설계가 다 되었다면, Medicaid가 실제로 효과가 있었는지 항목별로 비교해보자
- 결과 표를 가지고 해석해보자
    - Mean Value in Control Group : Control Group의 평균값
    - Effect of Lottery Selection : ATE값을 나타낸다 (Treatment 그룹 평균 - Control 그룹 평균)
        - 전체 모수의 모든 값을 관찰한 것이 아니기 때문에, 통계적 추론을 통해 95% 신뢰구간을 계산한다
        - 신뢰구간이 0을 포함하지 않을 경우에는 통계적으로 유의한 차이가 있다고 말한다

## A Note on Heteroskedasticity

두 집단의 평균을 비교하기 위해서는 t-test를 주로 사용한다.
하지만 데이터의 특성에 따라서 t-test를 그냥 적용하는 것이 어려운 경우가 존재한다.

- 만약 두 그룹의 분산이 비슷하다면 신뢰구간의 범위도 비슷할 것이다
    - 따라서 이 경우에는 최종적으로 두 분포의 분산을 합쳐서 (pooling) 유의미한 차이가 존재하는지 확인한다
- 두 그룹의 분산이 크게 다를 수도 있다
    - 이러한 특성을 **Heteroskedasticity** (이분산성) 라고 한다
    - 이러한 경우에는 두 분포의 분산이 다르다는 것을 반영해야 한다

R에서는 그냥 옵션을 조절하는 방식으로 비슷하게 처리할 수 있다.
하지만 동작하는 원리가 달라지기 때문에 이러한 점을 이해하고 넘어가자.


## Reading Average Treatment Effect & Confidence Intervals in a Table: Cholesterol in the Oregon Health Experiment

Total cholesterol 부분을 살펴보자

- Control 그룹의 평균값은 204.1
- Treatment Effect는 0.53 으로, 두 그룹 사이에 큰 차이가 없는 것으로 보인다
- 신뢰구간을 보니 (-0.83, 1.89) 로 되어있다. 신뢰구간이 0을 포함하고 있다

그렇다면 다음과 같은 질문을 해야 한다 : 해당 변수의 신뢰구간이 넓은걸까 좁은걸까?

- 신뢰구간이 넓은지 좁은지 여부를 판단하기 위한 기준은 상당히 주관적이고, 변수에 따라 다르다
- 만약 데이터에 대해서 잘 모른다고 한다면 어떻게 해야 할까?

이 경우에는 추정치의 **standard error** 를 살펴본다.

- 러프하게는 평균 +/- standard error 구간 사이에 70% 가까운 값들이 있다고 판단한다
- [204 - 34, 204 + 34] 구간 안에 70% 가량의 관측치가 존재하고, 구간의 길이는 68 units 이다
- 반면에 신뢰구간은 [-0.83, 1.89] 로 3 units 정도 된다
- 이것은 standard error의 구간에 비해 훨씬 좁은 구간이다
- 따라서 **신뢰구간은 데이터의 전반적인 범위에 비해서 상당히 작은 구간이라고 볼 수 있다**

결국 신뢰구간이 0을 포함하고 신뢰구간이 상당히 좁기 때문에 Treatment Effect가 없다고 판단할 수 있다.

만약 신뢰구간이 0을 포함하는데 구간이 넓은 경우에는 어떻게 될까?
이러한 경우 **데이터가 부족하기 때문에 판단할 수 없다** 고 본다.

그런데 현재 우리의 데이터에는 Noncompliers 들이 섞여있다.

- Treatment 그룹에 treat 되지 않은 대상자들 (Medicaid 받지 않은 사람들) 이 존재한다
- 이러한 이유로 Medicaid의 효과가 아니라 **Effect of Lottery Selection** 이라고 표현했다

# Common Issues in Experiments

## Important Issues in Experiment Design These Modules Ignore

지금까지는 Randomized Experiment 를 통해 수집한 데이터를 어떻게 해석할지에 대해서 살펴보았다.
그런데 데이터를 어떻게 수집해야할까? 실험을 설계하고, 실험을 진행해서 데이터를 모아야 한다.
이 과정에서 다양한 문제들이 발생한다.

- 실험에는 몇 명의 참가자들이 필요할까?
- 설문은 어떻게 작성하고 참가자는 어떻게 모아야 할까?
- 데이터는 언제, 얼마나 자주 수집해야 할까?
- 데이터 수집까지 얼마나 기다려야 할까?

이와 같은 다양한 이슈들을 해결해야 비로소 분석할 수 있는 데이터를 얻게 된다.

실험을 잘 설계하는 것은 매우 중요하지만 여기서는 그에 대해서는 다루지 않는다.
잘 설계된 실험을 통해 데이터가 수집되었다고 가정하고, 어떻게 해석해야 하는지를 중심으로 살펴본다.

## Other Issues in Experiments (Including Money & Ethics)

Randomized Experiments 는 리서치 과정에서 표준처럼 사용된다.
하지만 실제로 사용하고자 할 경우에는 많은 문제들이 발생할 수 있다.

사회 과학 연구에서 주로 발생하는 문제는 다음과 같은 것들이 있다.

- Nonresponse (미응답자)
- Noncompliance (Treatment 그룹인데 Treat를 수행하지 않는 경우)

다른 문제도 발생할 수 있다.

- 우리가 실험을 통해 알게되는 것은 Medicaid의 전반적인 효과이다
- 하지만 Medicaid에 다양한 프로그램들이 종합되어있다
- Medicaid 를 통해 우울증이 완화되는 효과를 얻었다면, 어떤 요인으로 인해 완화되었던 것일까?
- 실험의 결과만으로는 이러한 내용들을 알기가 어렵다
- 실험 결과를 데이터에 없는 내용으로 확대해서 해석하는 것은 쉽지 않은 문제다

그렇다면 어떻게 해야 할까?

한 가지 방법은, 복잡한 Medicaid 프로그램을 **다양한 실험들의 시퀀스로 풀어보는 것이다.**
각각의 실험에서 개별 컴포넌트를 바꿔가면서 실험하면 컴포넌트 단위의 효과에 대해서도 파악할 수 있다.
하지만 Medicaid 처럼 너무 복잡한 프로그램인 경우에는 이러한 방식을 적용하기 어려울 수 있다.
위와 같은 방식을 적용하기 어려운 경우에는, 관찰한 데이터로 실험 결과를 보충하기도 한다.
관찰한 결과를 통해 개별 컴포넌트의 효과를 추정한다.
아니면 정성적인 자료를 활용하여 결과를 해석하기도 한다.

Randomized Experiments 의 또다른 문제는, 현실에서 구현하기 어렵거나 불가능할 수 있다는 점이다.

- 비용이 문제가 되거나
- 처리 (treatmet) 가 어렵거나
- 랜덤하게 treat 여부를 결정하는 것이 비윤리적일 수 있다

이러한 경우에도 관찰한 데이터를 바탕으로 분석을 진행해야 한다.


# Dealing with Noncompliance in Experiments

## Noncompliance in Experiments

임상실험에서 treat 대상자가 주어진 약을 복용하지 않을 수도 있다.
이러한 경우를 **Noncompliance** 라고 한다.

- treatment 그룹에 속했는데 실제로는 treat 을 행하지 않은경우
- 또는 control 그룹에 속했는데 treat 된 경우

**Noncompliance** 에 대처하는 방법은 크게 4가지가 있다.

1. **Intention-to-treat Analysis**
    - 실제로 treat 받은 대상자들로 Treatment 그룹을 다시 정의한다
    - 이런식으로 다시 정의하면 Noncompliance라는 것이 존재할 수 없게된다
2. **Instrumental Variables Analysis**
    - treatment의 실제 효과를 알 수 있게 해주는 장점이 있다
    - 하지만 Average Treatment Effect를 구할 수 없다
    - 전체 집단으로부터 값을 구하지 않고, 모집단의 일부로부터 treatment effect를 계산한다
3. **Assume Random Compliance**
    - 대상자들이 약을 복용할지 말지 (treat 받을지 말지) 랜덤하게 선택했다고 가정한다
    - 이렇게 가정할 경우 Noncompliance를 분석 대상에서 제외해버릴 수 있다
    - Medicaid 대상자의 효과가 아니라, 대상자 중 Medicaid를 받은 사람의 효과로 해석하게 된다
    - 전체 모집단에 대한 ATE를 구할 수 있다는 장점이 있다
    - 단점은 Random Compliance라는 불확실한 가정에 너무 의존한다는 것이다
4. **Bounds Analysis**
    - 약한 가정을 바탕으로 한다는 장점이 있다
    - 1~3번 방법들의 단점을 피해갈 수 있다
    - 정확한 ATE 값이 아니라 그 구간(어떤 값보다 크다 등등) 만을 얻을 수 있다
    - 따라서 만약 구간이 0을 포함한다면, 결론을 내릴 수 없는 상태가 된다

## Survey Noncompliance

실험 과정에서 발생하는 또다른 문제 중 하나는 바로 **Survey Noncompliance** 다.
랜덤하게 사람을 뽑아서 설문을 요청해도 응답하지 않는 경우가 많다.

- Oregon Health Experiment Data
    - Treatments (n=29834)
    - In-Person Survey Sample (n=10405)
    - Survey Responders (n=6387) : 60% 정도의 사람만 설문에 응답했다
- 사람들이 설문에 응답하지 않는 것이 왜 문제일까?
    - **Selection Problem** 때문이다
    - 어떠한 변수를 사람들이 선택할 수 있게 되면 선택으로 인한 편향이 생길 수 있다
    - Medicaid가 마음에 드는 사람들은 굳이 응답을 하지 않은 반면, 불만족스러운 사람들은 설문에 적극적으로 응답하는 경우가 발생할 수 있다

# Long-term Average Treatment Effects

## Introducing Perry Preschool

초기의 가장 유명했던 사회과학 실험인 Perry Preschool 프로젝트에 대해 알아보자.

- 1962 ~ 1967년 동안 어린이들을 5개 코호트로 나누었다
    - 모든 어린이들은 같은 도시에 살았다
    - 소득수준이 낮은 흑인 아이들을 대상으로 한다
- 총 123명을 대상으로 한다
    - 이중에서 65명은 Control Group, 68명은 Treatment Group으로 구성되었다
    - Treatment 대상자는 주 5일 pre-school을 나가고, 매주 사회복지사(Social Worker)가 90분씩 가정 방문을 하게 되었다
    - Control Group에는 아무런 조치를 하지 않는다
- 오래 전에 이루어진 실험이 왜 중요할까?
    - 오랜 기간에 걸쳐 대상자들의 학업 성취도, 대학 진학 여부, 임금 수준, 범죄 등 다양한 정보들을 수집할 수 있었다
    - 따라서 이 실험을 바탕으로 많은 연구들이 진행될 수 있었다
- 이 중에서 한 가지 논문을 살펴보려고 한다
    - C. Belfield, M. Nores, S. Barnett, L.schweinhart, "The High/Scope Perry Preschool Program: Cost-Benefit Analysis from the Age-40 Followup"
    - 다양한 raw data를 제공하고, treatment의 효과를 측정하고자 한다

## Comparing Educational Attainment Data

Preschool에 가는 것이 범죄 여부에 얼마나 영향을 미치는지 알아보자.

- 남성과 여성간에 차이가 있는지 확인하기 위해 두 그룹을 따로 비교한다
- 각종 범죄를 저지른 비율과 집행유예/징역 선고받은 기간이 정리되어 있다

간단하게 성별로 징역 기간을 정리해보면 다음과 같다.

- 남성의 경우 Preschool은 나온 경우 `53->32` 로 줄어든 것을 볼 수 있다
- 반면 여성은 `4->9` 로 오히려 증가했다
- 이것은 샘플 수가 작아서 발생한 노이즈일까? 아니면 실제로 의미있는 효과일까?

​| (Period)     | Males     | Females  |
| ------------ | --------- | -------- |
| Preschool    | 32 months | 9 months |
| No Preschool | 53 months | 4 months |

## Calculating the Lifetime Cost of Crime

- 이전에는 preschool에 가는지 여부를 각종 범죄를 저지른 비율과 집행유예/징역 선고 기간과 비교했다
- 이번에는 모든 수치를 **범죄로 인한 비용 (Total Costs of Crime)** 이라는 하나의 지표로 환산하여 비교한다

| (Lifetime) | Preschool  | No Preschool |
| ---------- | ---------- | ------------ |
| Males      | $1,075,359 | $1,808,253   |
| Females    | $291,020   | $315,005     |

- 남성의 경우 Preschool에 들어가면 비용이 $732,894 감소하는 효과를 거두었다
- 여성의 경우 Preschool에 들어가면 비용이 $23,985 감소하는 효과를 거두었다
- 전체적으로는 Preschool에 들어가면 비용이 $378,440 감소하는 효과를 거두었다
- => Preschool에 가면 전반적인 범죄로 인한 비용을 낮추는 효과를 거둘 수 있다
