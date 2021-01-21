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
