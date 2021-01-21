# The four steps of causal inference

다음 문서의 일부 내용을 요약하여 정리한다.

![microsoft/dowhy : Tutorial on Causal Inference and its Connections to Machine Learning](https://microsoft.github.io/dowhy/example_notebooks/tutorial-causalinference-machinelearning-using-dowhy-econml.html)

```python
!pip install dowhy econml

import dowhy
from dowhy import CausalModel
import dowhy.datasets

# 샘플 데이터
data = dowhy.datasets.linear_dataset(
    beta=10,
    num_common_causes=5,
    num_instruments=2,
    num_samples=10000,
    treatment_is_binary=True
)
```

## 1. Modeling

- 첫 번째 단계는 도메인 지식을 바탕으로 인과 모형을 만드는 것이다. 그래프를 통해 표현하는 경우가 많다.
- 인과 추론의 결과가 초기 가정의 영향을 많이 받기 때문에 중요한 단계다
- 인과 효과를 예측할 때, 특정한 변수들을 찾아내야 하는 경우가 있다
    - **Confounders**
        - 액션과 결과 모두에 영향을 주는 변수
        - 이 변수로 인해 데이터를 통해 확인한 상관 관계가 실제 인과 관계와 다른 경우가 발생한다
    - **Instrumental Variables**
        - 액션에는 영향을 주지만 결과에 직접 영향을 미치지는 않는 변수
        - 또한 결과에 영향을 미치는 다른 변수들로부터 영향받지 않아야 한다
        - 잘 사용하면 bias를 줄이는 효과를 얻을 수 있다

```python
# 1단계 : 데이터와 도메인 지식을 바탕으로 Causal Model을 구성한다
model = CausalModel(
    data=data["df"],
    treatment=data["treatment_name"],
    outcome=data["outcome_name"],
    common_causes=data["common_causes_names"],
    intrumental_variables=data["instrument_names"]
)
# WARNING:dowhy.causal_model:Causal Graph not provided. DoWhy will construct a graph based on data inputs.
```

일반적으로는 해당 데이터셋의 데이터 생성 프로세스를 설명할 수 있는 인과 그래프를 직접 입력한다.

```python
model = CausalModel(
    data=data["df"],
    treatment=data["treatment_name"][0],
    outcome=data["outcome_name"][0],
    graph=data["gml_graph"] # Specify a causal graph
)
# INFO:dowhy.causal_model:Model to find the causal effect of treatment ['v0'] on outcome ['y']
```

## 2. Identification

- Causal Graph와 목표로 하는 수치(예를 들면 A의 B에 대한 효과)가 주어져 있다면, 관측한 데이터를 바탕으로 목표 수치를 추정할 수 있는지 확인해야 한다.
- 이러한 프로세스를 **Identification** 이라고 한다.
- identification은 데이터로 확인할 수 있는 변수만 고려한다.
- 주로 2가지 방법을 사용한다.
    - **Backdoor criterion** (더 일반적인 표현으로는 adjustment sets)
        - 모든 공통 원인들에 대해 조건을 부여하면 인과 효과를 Identification 할 수 있다
    - **Instrumental variable (IV) identification**
        - instrumental variable을 사용할 수 있다면, 공통 원인 변수가 관측되지 않았더라도 효과를 추정할 수 있다
        - instrument 변수가 결과 변수에 미치는 영향은 2개의 부분으로 나눌 수 있다
        - instrument -> Action 의 효과와 Action -> Outcome 의 효과

```python
# 2단계 : 인과 효과를 idenfity하고 목표 estimands를 반환한다
identified_estimand = model.identify_effect()
print(identified_estimand)
# WARN: Do you want to continue by ignoring any unobserved confounders?
# (use proceed_when_unidentifiable=True to disable this prompt) [y/n] y
# INFO:dowhy.causal_identifier:Instrumental variables for treatment and outcome:['Z0', 'Z1']
# INFO:dowhy.causal_identifier:Frontdoor variables for treatment and outcome:[]
# Estimand type: nonparametric-ate

# ### Estimand : 1
# Estimand name: backdoor1 (Default)
# Estimand expression:
#   d                                 
# ─────(Expectation(y|W2,W0,W3,W1,W4))
# d[v₀]                               
# Estimand assumption 1, Unconfoundedness: If U→{v0} and U→y then P(y|v0,W2,W0,W3,W1,W4,U) = P(y|v0,W2,W0,W3,W1,W4)

# ### Estimand : 2
# Estimand name: iv
# Estimand expression:
# Expectation(Derivative(y, [Z0, Z1])*Derivative([v0], [Z0, Z1])**(-1))
# Estimand assumption 1, As-if-random: If U→→y then ¬(U →→{Z0,Z1})
# Estimand assumption 2, Exclusion: If we remove {Z0,Z1}→{v0}, then ¬({Z0,Z1}→y)

# ### Estimand : 3
# Estimand name: frontdoor
# No such variable found!
```
