# Part2 : Causal Graphical Models

```
!pip install causalgraphicalmodels
```

다음 [포스팅](http://www.degeneratestate.org/posts/2018/Jul/10/causal-inference-with-python-part-2-causal-graphical-models/) 을 간단히 정리한다.

---

이전 글에서는 Potential Outcomes의 아이디어를 가지고 관측 데이터로부터 인과관계를 추론하는 방법에 대해서 알아보았다. Potential Outcomes 프레임워크에서는 counterfactual 결과를 결측치인 것처럼 다루어서 데이터를 통해 결측치를 추정하는 방식을 사용한다. 이러한 작업을 위해서는 데이터가 생성되는 과정에서 대한 강한 가정이 필요한데, 특히 강한 "Ignorability" 가정이 필요하다.

```
Yi ㅛ X|Z (Z가 주어졌을 때 Yi는 X와 조건부 독립이다)

Yi : 추정하고자 하는 Potential Outcomes
X  : 측정하고 하는 개입 (intervention)
Z  : 추정결과를 수정하기 위해 사용하는 공변량들
```

이런 강한 ignorability가 어디서 성립하는지 확인하기 위해서는 데이터가 생성되는 구조를 가정할 수 있어야 한다. 이러한 구조를 표현하기 위해 **Causal Graphical Models** 를 사용한다. 여기서는 `CausalGraphicalModel` 라이브러리를 사용해서 작업을 수행할 것이다.

이전의 글과 비교하면 인과 관계를 구하기 위한 기법들 보다는 데이터가 생성되는 구조에 대한 직관을 얻는데 집중할 것이다.

## What is Structure?

모델링을 위해 사용할 수 있는 한 가지 방법은 구조적 인과 모형 또는 구조방정식 (Structural Equation Models) 을 사용하는 것이다. 구조방정식을 통해 다양한 변수들의 관계를 함수의 형태로 표현할 수 있다.

예를 들어 x1, x2, x3 세 가지 변수로 구성된 시스템이 다음과 같이 연결되어 있다고 생각해보자.

```
x1 ~ Bernoulli(0.3)
x2 ~ Normal(x1, 0.1)
x3 = x2^2
```

x1과 x2는 확률 변수로부터 샘플링된 값이고,  x3은 x2의 값에 의해서 결정된다. 파이썬 코드로 쉽게 구현해 볼 수 있다.

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

%matplotlib inline
```

```python
def f1():
    return np.random.binomial(n=1, p=0.3)

def f2(x1):
    return np.random.normal(loc=x1, scale=0.1)

def f3(x2):
    return x2 ** 2

x1 = f1()
x2 = f2(x1)
x3 = f3(x2)

print("x1={}, x2={:.2f}, x3={:.2f}".format(x1, x2, x3))
```
