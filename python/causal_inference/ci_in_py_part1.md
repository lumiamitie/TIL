# Part 1. Potential Outcomes

다음 [포스팅](http://www.degeneratestate.org/posts/2018/Mar/24/causal-inference-with-python-part-1-potential-outcomes/) 의 내용을 간단히 정리하고자 한다.

---

이 글에서는 파이썬의 `CausalInference` 패키지를 사용하여 Potential Outcomes 방법론을 통해 관찰한 데이터로부터 인과적 추론을 이끌어내는 방법에 대해 알아볼 것이다.

여기서는 고정된 데이터를 사용하는 대신 직접 작성해둔 함수를 통해 데이터를 생성할 것이다.
이렇게 하면 데이터가 생성되는 과정에 직접 개입할 수 있기 때문에, 우리의 추론이 정확한지 확인할 수 있게 된다는 장점이 있다.
다음 [레포지토리](https://github.com/ijmbarr/notes-on-causal-inference) 에 있는 `datagenerators.py` 파일에서 해당 함수를 찾을 수 있다.

## Environment Setting

```python
# 데이터 생성을 위한 파이썬 코드 다운로드
!git clone https://github.com/ijmbarr/notes-on-causal-inference.git
```

```python
# causalinference 라이브러리 설치
!pip install causalinference
```

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
%matplotlib inline

import sys
sys.path.append('/content/notes-on-causal-inference')
import datagenerators as dg
```

## Introduction

어느날 팀장은 몇몇 팀원들이 멋진 모자를 쓰고 나온 다음부터 생산성이 떨어지는 경향이 있다는 것을 알게 되었다. 팀장은 어떤 멤버가 모자를 썼고, 어떤 멤버가 생산성이 떨어졌는지 기록하기 시작했다. 일주일간 관찰한 결과 다음과 같은 데이터를 얻게 되었다.

```python
observed_data_0 = dg.generate_dataset_0()
observed_data_0.head()
```

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>x</th>
      <th>y</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>

모자를 쓰는 사람들이 그렇지 않은 사람들보다 생산성이 떨어진다고 말할 수 있을까? 다시 말하면 다음 값을 계산할 수 있을까? : `P(Y=1 | X=1) - P(Y=1 | X=0)`

데이터를 통해 계산해보자.

```python
def estimate_uplift(ds):
    base = ds[lambda d: d.x == 0]
    variant = ds[lambda d: d.x == 1]

    delta = variant['y'].mean() - base['y'].mean()
    delta_error = 1.96 * np.sqrt(variant['y'].var() / variant.shape[0] +
                                base['y'].var() / base.shape[0])
    return {'delta': delta, 'delta_error': delta_error}

effect_0 = estimate_uplift(observed_data_0)

print('''
Estimated Effect: {0}
Standard Error: {1}
'''.format(effect_0['delta'], effect_0['delta_error']))

# Estimated Effect: -0.15588488600724743
# Standard Error: 0.08733774503991501
```

통계적 검정을 통해 확인해보면 p-value 값도 매우 작게 나오는 것을 볼 수 있다.

```python
from scipy.stats import chi2_contingency

contingency_table = (observed_data_0
    .assign(placeholder=1)
    .pivot_table(index='x', columns='y', values='placeholder', aggfunc='sum')
    .values
)

_, p_value, _, _ = chi2_contingency(contingency_table, lambda_='log-likelihood')

print(p_value)
# 0.0007348032687889459
```

이러한 정보를 바탕으로, 사람들이 모자를 썼을 때 생산성이 변할 확률을 예상해 볼 수 있다.
관측했던 확률 분포와 동일한 분포일 것이라고 가정하면 이후에도 같은 상관 관계가 있을 것이라고 기대할 수 있다.

그런데 이 결과를 가지고 다른 사람들에게 모자를 쓰거나 쓰지 말 것을 강제해야 할 때에는 문제가 될 수 있다.
우리가 샘플링하는 대상의 환경 자체를 바꾸는 것이기 때문에, 이전에 관측했던 것과는 다른 상관관계를 보일 수 있다.

시스템 상의 변화로 인한 효과를 측정하기 위해 가장 깔끔한 방법은 바로 **Randomized Control Test** 를 수행하는 것이다.
누가 모자를 받을지는 랜덤하게 결정한다면 교란 변수 (Confounding Variables) 의 효과를 제외한 실제 영향을 파악할 수 있다.

```python
# 데이터 생성 과정을 직접 조작하여 A/B 테스트의 결과를 측정해보자
def run_ab_test(datagenerator, n_samples=1000, filter_=None):
    n_samples_a = int(n_samples / 2)
    n_samples_b = n_samples - n_samples_a
    set_x = np.concatenate([np.ones(n_samples_a), np.zeros(n_samples_b)]).astype(np.int64)
    ds = datagenerator(n_samples, set_x)
    if filter_ != None:
        ds = ds[filter_(ds)].copy()
    return estimate_uplift(ds)

run_ab_test(dg.generate_dataset_0)
# {'delta': 0.20799999999999996, 'delta_error': 0.060644652292707504}
```

모자를 썼을 때의 효과가 아까와는 반대의 방향이 되었다. 무슨 일이 일어난 걸까??

**참고.**

위 예제에서 샘플은 iid를 따르고, SUTVA (Stable Unit Treatment Value Assumption) 조건을 따른다는 가정을 하고 있다.
즉, 어떤 사람이 모자를 쓰도록 선택하거나 강제되는 것이 다른 사람의 선택에 영향을 미치지 않는다.


## Definitions of Causality

앞선 사례는 통계학에서 흔히 말하는 **"상관관계는 인과관계를 의미하지 않는다"** 라는 말이 의미하는 것을 잘 보여준다.
그런데 여기서 인과 관계라는 것은 너무 모호한 용어다. 따라서 다음과 같이 정의해보자.

> X와 Y는 확률변수이고, 우리가 측정하고 하는 효과(effect)는 X가 특정한 값을 가지도록 강제했을 때 Y의 분포가 얼마나 변하는지를 말한다.

이렇게 변수가 특정한 값을 가지도록 강제하는 것을 **Intervention** 이라고 한다.

- 모자 예시에서 모자를 썼는지 여부를 관찰했을 때, 생산성의 분포 : `P(Y | X)`
- 일부 사람들에게 모자를 쓰게 했을 때 생산성의 분포 : `P(Y | do(X))`

**위 두 가지는 일반적으로 같지 않다.**

여기서는 관측 결과만 볼 수 있을 때, 개입에 의한 분포 변화를 어떻게 추측할 수 있을지에 대한 답을 찾고자 한다.
이러한 문제는 A/B를 수행하기 어려운 상황에 도움이 된다.
테스트를 하기 어려운 환경에서도 우리는 개입에 의한 효과를 측정하길 원한다.
이를 위해서는 데이터 생성 과정에 대해 몇 가지 가정을 추가해야 한다.


## Potential Outcomes

이 문제에 접근하기 위한 한 가지 방법은 새로운 변수 두 개를 추가하는 것이다.
Y0와 Y1 이라는 변수를 추가하고  이것을 **Potential Outcomes** 라고 한다.
이 변수들은 절대로 직접 관측할 수 없다는 것을 제외하면 다른 확률 변수들과 동일하다.
Y는 다음과 같이 정의할 수 있다.

```
Y = Y1 when X = 1
Y = Y0 when X = 0
```

이렇게 하면 "개입에 의한 분포 변화" 를 추정하는 문제에서 "특정한 분포에서 결측치를 포함하여 샘플링"하는 문제로 바꿀 수 있다.
값이 왜 비어있는지에 대한 몇 가지 가정이 있다면 결측치를 예측하기 위한 방법론들이 존재한다.

## Goals

개입으로 변화하는 분포를 고려하지 않는다면, 두 그룹의 평균 차이를 구하는 것으로도 충분할 수 있다.
이것은 **Average Treatment Effect** 라는 값으로 알려져 있다.
A/B 테스트를 수행하고 각 그룹의 평균을 비교한다면 ATE를 측정하는 것이라고 볼 수 있다.

```
ATE = E(Y1 - Y0)
```

만약 관측한 분포로부터 추정한다면 다음과 같은 값을 얻게 된다.

```
E[Y|X=1] - E[Y|X=0]
  = E[Y1|X=1] - E[Y0|X=0]
  != ATE
```

이 값은 실제 ATE와는 다르다. `E[Yi|X=i] != E[Yi]` 이기 때문이다.

비슷한 값으로는 다음과 같은 것들이 있다.

- **ATT**
    - Average Treatment effect of the Treated
    - `E[Y1 - Y0 | X=1]`
- **ATC**
    - Average Treatment effect of the Control
    - `E[Y1 - Y0 | X=0]`

## Making Assumptions

A/B 테스트를 하면, X의 값을 랜덤하게 배정한다.
따라서 Y1과 Y0 중에 우리가 어떤 값을 보게 될지가 랜덤하게 결정된다. 즉,

```
Y1, Y0 ㅛ X
=> P(X, Y0, Y1) = P(X) * P(Y0, Y1)
=> E[Y1 | X=1] = E[Y1]
```

만약 관측 자료로부터 ATE를 구하고자 한다면, 샘플 데이터에 대한 추가적인 정보가 필요하다.
특히 어떤 treatment를 선택하는지에 대한 정보가 필요하다.
이러한 추가 정보를 확률 변수 Z라고 해보자. 그러면,

```
Y1, Y0 ㅛ X|Z
=> P(X, Y0, Y1 | Z) = p(X | Z) * P(Y0, Y1 | Z)
```

이것은 X가 Z에 의해 완벽하게 설명될 수 있다는 것을 의미한다.
이것을 **Ignorability Assumption** 이라고 한다.

모자 예제에서 "숙련도" 라는 추가 요인이 있다고 가정해보자.
숙련도는 생산성과 모자를 쓸지 말지 여부에 모두 영향을 미치는 변수다.
숙련된 사람들은 대체로 생산성이 더 높고, 모자를 안쓰는 경우가 더 많다.
이러한 사실은 A/B 테스트를 수행했을 때 왜 결과가 반대로 나왔는지 설명할 수 있다.

만약 데이터에서 특정한 사람의 숙련도 여부를 나눌 수 있다면, 각각의 서브 그룹에서는 모자를 쓰면 생산성이 올라간다는 것을 확인할 수 있을 것이다.


```python
obs_0_with_confounders = dg.generate_dataset_0(show_z=True)

print(estimate_uplift(obs_0_with_confounders.loc[lambda df: df['z']==0]))
print(estimate_uplift(obs_0_with_confounders.loc[lambda df: df['z']==1]))

# {'delta': 0.25, 'delta_error': 0.14935204824401044}
# {'delta': 0.19956140350877194, 'delta_error': 0.1778622363930788}
```

하지만 우리는 Y0과  Y1을 동시에 관찰할 수 없기 때문에 `Y1, Y0 ㅛ X|Z` 라는 가정을 확인할 수 없다.
따라서 이 부분은 도메인 지식을 활용해야 한다.

예측의 퀄리티는 이러한 가정을 얼마나 잘 했는지에 따라 결정된다.
Simpson's Paradox는 Z가 모든 교란변수를 포함하지 못할 경우, 우리가 잘못된 추론을 할 수 있다는 것을 극단적으로 보여주는 예시다.
페이스북은 A/B 테스트와 다양한 Causal Inference 결과를 비교하여 가정이 틀렸을 경우 effect가 과도하게 예측될 수 있다는 것을 보여주는 [논문](https://www.kellogg.northwestern.edu/faculty/gordon_b/files/kellogg_fb_whitepaper.pdf)을 발표했다.


## Modeling the Counterfactual

Y0와 Y1을 알고 있다면 ATE를 계산할 수 있다. 그렇다면 Y0과 Y1을 예측해서 직접 계산해보면 어떨까?

- `Yhat0(Z) = E[Y | Z, X=0]`
- `Yhat1(Z) = E[Y | Z, X=1]`

위 두 개의 값을 구하면 ATE를 다음과 같이 추정할 수 있다.

```
mean(Yhat1(Z) - Yhat0(Z))
```

이러한 방식이 잘 동작하기 위해서는 Potential Outcome에 대한 모델링이 잘 이루어져야 한다. 다음 데이터 생성 과정을 살펴보자.

```python
obs_1 = dg.generate_dataset_1()
obs_1.plot.scatter(x='z', y='y', c='x', cmap='rainbow', colorbar=False)
```

![png](fig/ci_in_py_part1/output_30_1.png)
