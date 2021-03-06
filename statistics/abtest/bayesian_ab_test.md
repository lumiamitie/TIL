# Bayesian A/B Testing

다음 아티클을 읽고 간단히 정리해보자.

[Chris Stucchio | Bayesian A/B Testing at VWO](https://cdn2.hubspot.net/hubfs/310840/VWO_SmartStats_technical_whitepaper.pdf)

# Problem

A/B 테스트를 할 때마다 사람들이 가장 궁금해하는 것 중에 하나는 B안이 A안보다 좋을 확률이 얼마나 되냐는 것이다. 일반적으로 사용하는 frequentist 방법론으로는 이러한 질문에 대한 답을 할 수 없다. frequentist 방법론들은 보통 이런 방법을 따른다.

1. 귀무가설(Null Hypothesis)을 선택한다. 보통 A, B안 사이에 차이가 없을 것이라고 가정하게 된다.
2. 이제 실험을 수행하고, 통계량을 구한다.
3. p-value를 계산한다. p-value는 귀무가설이 맞다고 가정했을 때, 현재보다 더 극단적인 케이스의 통계량 수치가 나올 확률을 의미한다.
    - p-value가 의미하는 것은 다음과 같다.
    - "동일한 샘플 크기로 A/A 테스트를 수행할 경우, 방금 본 결과와 같거나 더 극단적인 결과가 나올 확률이 p값보다 작다."

p-value 는 B안이 A안보다 좋을 확률을 의미하는 것이 아니지만, 그렇게 사용되는 경우가 종종 있다.

흔히 사용하는 A/B 테스트 방식은 false positive 를 발생시키기 쉽다. 예를 들어, 여러 가지 목표를 만들어 두고 테스트가 끝날 때 특정 목표를 선택해버릴 수도 있다. 

# The Joint Posterior for 2 variants

A안과 B안이라는 2개의 선택지가 있다고 해보자. 이 때, joint posterior는 다음과 같다.

```
P(lambda_A, lambda_B) = P_A(lambda_A) * P_B(lambda_B)

lambda_A : A안의 true conversion rate
lambda_B : B안의 true conversion rate
P_A(lambda_A) : A안에 대한 Posterior distribution
P_B(lambda_B) : B안에 대한 Posterior distribution
```

Joint posterior 를 알고있으면 다양한 값을 구할 수 있다. 그 중에서 가장 중요한 것은 loss function 이다.
이 함수를 바탕으로 어떤 안을 선택할지, 언제 테스트를 멈출지 결정할 것이다.

## Chance to beat control

데이터를 통해 증거를 모으고 그 결과 A안을 선택했다고 해보자. 우리가 실수했을 가능성은 얼마나 될까? 
Error Probability는 다음과 같이 정의할 수 있다.

```
E[I](A) = \int_{0}^{1} \int_{0}^{\lambda_A} P(\lambda_A, \lambda_B) d\lambda_B \lambda_A
```

이 정의는 테스트를 지속해야 하는지를 결정할 수 있는 꽤 직관적인 선택으로 보인다. 하지만 이 지표는 결정을 내리는데 있어 중요한 결함이 있다. 
바로 **모든 에러를 동일하게 취급한다는** 점이다.

## The Loss Function

Loss Function 은 중요한 부분에서 발생한 에러일수록 더 큰 영향을 미치도록 에러 함수를 수정한다. 
여기서는 Loss Function 을 `lambda_A` , `lambda_B` 값이 주어졌을 때 A 또는 B안을 선택하여 발생할 것으로 예상되는 손실의 양을 나타나는 함수로 정의한다.

```
L(lambda_A, lambda_B, A) = max(lambda_B - lambda_A, 0)
L(lambda_A, lambda_B, B) = max(lambda_A - lambda_B, 0)
```

- Example : 다음과 같은 상황을 가정해보자.
    - A안의 전환율은 `lambda_A = 0.1` , B안의 전환율은 `lambda_B = 0.15` 로 알려져있다.
    - A안을 선택할 경우 loss는 `max(0.15 - 0.1, 0) = 0.05` 이고,
    - B안을 선택할 경우 loss는 `max(0.1 - 0.15, 0) = 0.0` 이다.

이제 **joint posterior 가 주어졌을 때의 기대 손실은 loss function의 기대값이다.**

```
E[L](?) = \int_{0}^{1} \int_{0}^{\lambda_A} L(\lambda_A, \lambda_B, ?) P(\lambda_A, \lambda_B) d\lambda_B \lambda_A
```

## Computing the loss and error functions

error, loss function을 수치적으로 구하는 방법은 직관적이다. 

```python
# (1) Computing the joint posterior
# 다음과 같이 2개의 posterior를 가지고 있다고 생각해보자
posterior_A = []
posterior_B = []

# joint posteior는 2d array로 나타낸다
joint_posterior = zeros(shape=(100,100))

for i in range(100):
    for j in range(100):
        joint_posterior[i, j] = posterior_A[i] * posterior_B[j]

# (2) Computing the error function
error_function_A = 0
for i in range(100):
    for j in range(i, 100):
        error_function_A += joint_posterior[i, j]

error_function_B = 0
for i in range(100):
    for j in range(0, i):
        error_function_B += joint_posterior[i, j]

# (3) Computing the loss function
def loss(i, j, var):
    if var == 'A':
        return max(j*0.01 - i*0.01, 0)
    if var == 'B':
        return max(i*0.01 - j*0.01, 0)

loss_function = 0
for i in range(100):
    for j in range(100):
        loss_function += joint_posterior[i, j] * loss(i, j, 'A')
```

# Running a Bayesian A/B test

3개 이상의 케이스를 다루기 전에, A/B 테스트가 어떻게 동작할지 살펴보자. 기본적인 아이디어는 다음과 같다.

1. 실험에서 목표로 하는 에러 허용치 `e` 를 정한다. 
2. 기대 loss 값이 사전에 설정해둔 에러 허용치보다 낮아질 때까지 실험을 계속한다.

`e` 는 보통 백분율 형태로 해석한다. 우리가 잘못된 선택을 했을 때, 해당 선택을 함으로써 발생하는 손실을 나타낸다. 따라서 발생하더라도 크게 신경쓰이지 않을 정도로 낮은 숫자를 설정해야 한다.

- Example : 두 개의 버튼에 다른 색상을 적용하는 테스트를 가정해보자.
    - 10% 정도 상승할 수 있을 것이라고 기대하고 있다.
    - 반대로 지표가 나빠진다면 0.2% 이내로 하락할 수 있다. 이 정도 하락하는 것은 크게 문제가 되지 않는다.
    - 따라서 이 경우에는 `e = 0.002` 로 설정할 수 있다.

**베이지안 A/B 테스트의 구체적인 프로세스는 다음과 같다.**

1. A안과 B안 중 하나를 랜덤하게 유저에게 보여주는 실험을 시행한다.
2. 주기적으로 통계 지표 `n_A` , `c_A` , `n_B` , `c_B` 를 수집한다.
    - `n_A` : A안이 노출된 횟수
    - `n_B` : B안이 노출된 횟수
    - `c_A` : A안이 전환된 횟수
    - `c_B` : B안이 전환된 횟수
3. `E[L](A)` 와 `E[L](B)` (A, B안의 기대 손실)을 계산한다.
4. A안과 B안의 기대 손실 중 에러 허용치 `e` 보다 작은 값이 있는지 확인한다.
    - 없는 경우 → 1번으로 돌아간다.
    - 있는 경우 → **실험을 멈추고 기대 손실이 `e` 보다 작은 안을 선택한다.**

# Running a test with more than two variants

위 코드 예시에서는 `range(100)` 을 사용했기 때문에, 2개의 안을 비교할 때 `100^2 = 10000` 번의 계산을 수행했다. 
비교할 안이 3개가 된다면 `100^3`, 4개 안을 비교한다면 `100^4` 로 계산량이 기하급수적으로 늘어나게 된다. 
이제는 Monte Carlo 방법을 사용해서 샘플링을 통해 적분 결과를 확률적으로 구해야 한다.

# Modeling revenue

수익을 모델링하기 위해 다음과 같은 생성 모형을 구성해보자. 특정한 유저 `i` 에 대한 수익은 다음과 같은 모형을 통해 생성할 수 있다.

```
a_i ~ Bernoulli(lambda)
r_i ~ Expon(theta)
v_i = a_i * r_i

a_i : 유저가 구매할지 여부 (0, 1)
r_i : 구매했을 경우 구매한 금액
v_i : 방문한 유저의 실제 구매 금액

판매건수당 평균 수익은 theta^(-1), 방문자수당 평균 수익은 lambda * theta^(-1) 로 구할 수 있다.
```

## Notation

```
S_A = \frac{1}{C_A}\sum_{k=1}^{C_A}S^k_A

n_A   : A안의 방문 고객 수
C_A   : A안의 판매량
S_A   : A안의 경험적인(empirical) 판매당 수익
S^k_A : A안에서 k번째 고객의 구매금액
```

# Posterior distribution for revenue/sale

## Computing a posterior on sale size

변수 `s` 가 `decay rate=theta` 인 지수분포를 따르고 theta의 Prior가 `Gamma(k, Theta)` 일 때, Posterior는 다음과 같다.

```
P(theta | s) ~ Gamma(k+c , Theta / (1 + Theta_cs))

- 변수들의 집합 s^i 는 Exp(theta)를 따른다
- i = 1,...,c
```

## The total Posterior

위 항목을 정의했다면 이제 `(lambda, theta)` 에 대한 Joint Posterior를 계산할 수 있다. 

```
다음과 같은 Prior를 가정한다.
lambda ~ f(lambda; a, b)
theta  ~ gamma(k, Theta, theta)

Posterior는 다음과 같다.
P(lambda, theta | n, c, s) 
= f(lambda; a+c, b+n-c) * gamma(k+c, Theta / (1 + Theta_cs), theta)
```

# Chance to beat all for Revenue

각 안의 총 수입은 `lambda * theta` 로 구할 수 있다. 구매 확률에 평균 판매가격을 곱한 값을 의미한다. A안과 B안 각각에 대한 lambda, theta 값의 posterior를 구했다고 가정하면 다음과 같이 계산할 수 있다.

```
P(lambda_B / theta_B > lambda_A / theta_A)
= (수식이 너무 길어서 여기서는 생략..)
```

수식의 적분 부분은 Monte Carlo Sampling을 통해 계산할 수 있다.

1. `lambda_A` , `theta_A` , `lambda_B` , `theta_B` 가 따르는 분포로부터 각각 M개의 샘플을 추출한다.
    - `i = 1, ... , M`
2. 각 인덱스별로 `lambda_B / theta_B > lambda_A / theta_A` 인 개수를 구하고 M으로 나눈다.

# Making decisions based on Revenue

이제 Loss Function 을 정의해보자. 
여기서는 잘못된 선택을 했을 때 우리가 선택한 안과 나머지 안 중에서 가장 효과가 좋았던 안의 기대수익 차이를 Loss Function 으로 정의한다.

```
다음과 같이 정의한다.
L(lambda_A, lambda_B, theta_A, theta_B, A) = max(lambda_B / theta_B - lambda_A / theta_A, 0)
L(lambda_A, lambda_B, theta_A, theta_B, B) = max(lambda_A / theta_A - lambda_B / theta_B, 0)

이제 Expected Loss를 정의할 수 있다.
E[L](A) = E[ L(lambda_A, lambda_B, theta_A, theta_B, A) ]
E[L](B) = E[ L(lambda_A, lambda_B, theta_A, theta_B, B) ]
```

Bernoulli 분포를 사용하는 케이스에서는 Expected Loss 가 에러 허용치 `e` 이하로 떨어지는 지점에서 의사결정을 내린다. 
특히 특정한 안의 Expected Loss 가 `e` 이하로 떨어지면 해당 안을 선택하게 된다.

# 추가 참고자료

[Convoy Tech Blog | The Power of Bayesian A/B Testing](https://medium.com/convoy-tech/the-power-of-bayesian-a-b-testing-f859d2219d5)

# 코드로 구현해보자

- 다음 레포지토리를 참고하여 A/B 테스트 효과 추정 과정을 코드로 구현해보자.
- <https://github.com/cbellei/abyes>

## 클릭률만 사용

### 코드

```python
import numpy as np
import pymc3 as pm

data = [np.random.binomial(1, 0.4, size=10000), np.random.binomial(1, 0.5, size=10000)]

ALPHA_PRIOR = 1
BETA_PRIOR = 1
ITERATIONS = 500

with pm.Model() as ab_model:
    # Priors
    mua = pm.distributions.continuous.Beta('muA', alpha=ALPHA_PRIOR, beta=BETA_PRIOR)
    mub = pm.distributions.continuous.Beta('muB', alpha=ALPHA_PRIOR, beta=BETA_PRIOR)
    
    # Likelihoods
    pm.Bernoulli('likelihoodA', mua, observed=data[0])
    pm.Bernoulli('likelihoodB', mub, observed=data[1])

    # Find distribution of lif (difference)
    pm.Deterministic('lift', mub - mua)
    
    # Find distribution of effect size
    sigma_a = pm.Deterministic('sigmaA', np.sqrt(mua * (1 - mua)))
    sigma_b = pm.Deterministic('sigmaB', np.sqrt(mub * (1 - mub)))
    pm.Deterministic('effect_size', (mub - mua) / (np.sqrt(0.5 * (sigma_a ** 2 + sigma_b ** 2))))

    start = pm.find_MAP()
    step = pm.Slice()
    trace = pm.sample(ITERATIONS, step=step, start=start)

# (1) np.histogram + np.trapz 를 이용해 Loss Function 계산하기
# RESOLUTION = 500
# lift_bins = np.linspace(
#     np.min(lift_trace) - 0.2 * abs(np.min(lift_trace)), 
#     np.max(lift_trace) + 0.2 * abs(np.max(lift_trace)), 
#     RESOLUTION
# )
# lift_binned = np.histogram(lift_trace, bins=lift_bins, density=True)
#
# # Calculate Expected Loss
# dl = 0.5 * (lift_binned[1][0:-1] + lift_binned[1][1:])
# fdl = lift_binned[0]
#
# inta = np.maximum(dl, 0) * fdl
# intb = np.maximum(-dl, 0) * fdl
#
# ela = np.trapz(inta, dl) # 0.10359266799323139
# elb = np.trapz(intb, dl) # 0.0

# (2) Loss Function의 수식을 정리해보면 다음과 같이 간단하게 정리할 수 있다.
# lift = lambda_B - lambda_A 라고 정의했을 때,
# E(L_A) = Max(lift, 0) , E(L_B) = Max(-lift, 0)
ela = np.mean(np.maximum(lift_trace, 0))  # 0.10359266799323139
elb = np.mean(np.maximum(-lift_trace, 0)) # 0.0

# Make decision
TOC = 0.01
if ela <= TOC and elb <= TOC:
    print('A안과 B안의 효과는 동등한 것으로 보인다.')
elif elb < TOC:
    print('B안이 승리!')
elif ela < TOC:
    print('A안이 승리!')
# B안이 승리!
```

기대값을 구할 때 적분 대신 그냥 산술평균을 써도 동일한 값이 나오는 이유?!

- 위 코드에서 보면 MCMC로 샘플링한 결과에 대해 기대값을 구하려고 한다.
- 해당 값은 특정한 확률 분포를 기준으로 샘플링된 값이다. 따라서 동일한 값이 여러 개 생성될 경우 해당 값이 여러번 중복되면서 확률분포로 인한 가중치 역할을 대신하게 된다.
- 따라서 샘플링 결과에 산술 평균을 적용한 결과는 확률 분포를 바탕으로 구한 기대값과 결과적으로는 동일한 형태가 된다. (엄밀하게 말하면 contiuous 케이스에서는 적용되지 않지만, 개수 정해놓고 샘플링한 결과기 때문에 discrete 한 경우로 가정해도 될 것 같다.)

> Similarly, the expected value can be thought of as the arithmetic mean of a set of numbers generated in exact proportion to their probability of occurring (in the case of a continuous random variable this isn't exactly true since specific values have probability 0)

[Cross Validated | Why is expectation the same as the arithmetic mean?](https://stats.stackexchange.com/a/30367)

### 코드 구현시 참고자료

- https://github.com/cbellei/abyes/blob/master/abyes/ab_exp.py
- http://www.claudiobellei.com/2017/11/02/bayesian-AB-testing/

## 클릭률 + 매출/수익 반영

TODO


---

# 왜 기존 Frequentist 방법 대신 Bayesian 방법론을 사용했을까?

[The Power of Bayesian A/B Testing](https://medium.com/convoy-tech/the-power-of-bayesian-a-b-testing-f859d2219d5)

Frequentist의 실험 방식은 귀무가설에 더 우호적이다. 이런 접근 방식은 새로운 안으로 변경하는데 비용이 많이 들거나 UX를 혼란스럽게 만들 수 있는 경우라면 타당할 수도 있다. 
하지만 그렇지 않은 경우에는 조금이라도 더 나은 성과를 보이는 안을 빠르게 선택하는 것이 더 좋지 않을까? 
Expected Loss를 사용하는 Bayesian 방법론은 작은 개선에도 열려있다. 최근의 비즈니스 환경에서는 중요한 지표를 개선하기 위해 다양한 실험을 반복하는 경우가 많다. 
작은 수치라도 개선되는 방안을 빠르게 선택할 수 있다면, 결과적으로 더 많은 실험을 빠르게 수행함으로써 목표로 하는 지표를 최대한 개선할 수 있게 된다.

Bayesian A/B 테스트는 False Positive Rate (실제로는 성과가 낮은 안을 선택해버리는 비율) 이 중요하지 않다고 본다. 
10% vs 10.1% 일 때 10%인 안을 선택하는 것과 10% vs 15% 일 때 10%를 선택하는 것은 큰 차이가 있다. 
하지만 Frequentist 방법론은 이 두 가지를 동일한 False Positive로 간주한다.

Bayesian A/B 테스트에서는 잘못된 선택을 했을 때 평균적으로 미치게 되는 영향에 집중한다. 
잘못된 선택을 했을 때 부정적인 영향의 정도를 제한하기 때문에, 장기적으로 보면 높은 확률로 지표를 개선할 수 있다.
