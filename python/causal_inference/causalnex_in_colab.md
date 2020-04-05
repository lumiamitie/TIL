# 구글 Colab에서 CausalNex 튜토리얼 실행시켜보기

[CausalNex Tutorial (공식문서)](https://causalnex.readthedocs.io/en/latest/03_tutorial/03_tutorial.html)

## 설치 및 데이터 다운로드

- 2020-04-01 기준 causalnex 0.5 버전을 설치하면 강제로 pandas 0.24.0 을 다운로드 한다
- causalnex의 다른 디펜던시 및 google-colab 관련 라이브러리들이 pandas 0.25 이상을 필요로 하기 때문에 pandas를 새로 설치한다

```
!pip install causalnex && pip install 'pandas==1.0.0' --force-reinstall
```

- pygraphviz 를 설치하기 위해 관련된 디펜던시를 설치한다
    - `graphviz-dev` 를 설치하지 않을 경우 pygraphviz 라이브러리 설치가 실패한다
    - 참고. <https://github.com/pygraphviz/pygraphviz/issues/163>

```
!apt-get install -y graphviz-dev && pip install pygraphviz
```

- 예제 데이터를 다운로드 한다
    - <https://archive.ics.uci.edu/ml/datasets/Student+Performance>

```
!wget --no-check-certificate https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip && unzip student.zip
```

# Structure Learning

```python
from causalnex.structure import StructureModel
from causalnex.structure.notears import from_pandas
from causalnex.network import BayesianNetwork
from causalnex.plots import plot_structure, NODE_STYLE, EDGE_STYLE
from IPython.display import Image

from sklearn.preprocessing import LabelEncoder
import pandas as pd
import numpy as np
```

## Structure from Domain Knowledge

feature 사이의 관계를 직접 정의함으로써 structure model 을 직접 생성할 수 있다.

```python
# (1) 비어있는 structure model 을 생성한다
sm = StructureModel()

# (2) feature 간의 관계를 정의한다
# 다음과 같은 인과관계를 알고 있다고 가정해보자
# * health -> absences
# * health -> G1(grade in semester 1)
sm.add_edges_from([
    ('health', 'absences'),
    ('health', 'G1')
])
```

## Visualising the Structure

`sm.edges` 값을 통해 위에서 생성한 StructureModel 을 살펴볼 수 있다.

```python
sm.edges
# OutEdgeView([('health', 'absences'), ('health', 'G1')])
```

이번에는 그래프를 통해 살펴보자.

```python
viz = plot_structure(
    sm,
    graph_attributes={"scale": "0.5"},
    all_node_attributes=NODE_STYLE.WEAK,
    all_edge_attributes=EDGE_STYLE.WEAK
)
filename = "./structure_model.png"
viz.draw(filename)
Image(filename)
```

## Learning the Structure

변수의 개수가 많아지거나, 도메인 지식이 없을 경우에는 구조를 직접 작성하는 것이 어려울 수 있다. 
이럴 경우에는 **데이터를 통해 구조를 학습할 수 있다.** 구조 학습에는 [NOTEARS](https://arxiv.org/abs/1803.01422) 알고리즘을 사용한다.
**구조를 학습할 때는 데이터 전체를 사용한다.** 구조는 머신러닝과 도메인 지식 모두를 통해 학습하기 때문에, 항상 데이터를 학습/평가셋으로 나눌 필요는 없다.
우선 NOTEARS 알고리즘에서 사용할 수 있는 형태로 데이터를 전처리해보자.

## Preparing the Data for Structure Learning

```python
# 데이터를 불러온다
student_data_raw = pd.read_csv('student-por.csv', delimiter=';')

# 모형에 포함하지 않을 변수를 제거한다
student_data = student_data_raw.drop(columns=['school','sex','age','Mjob','Fjob','reason','guardian'])

# NOTEARS 알고리즘이 숫자 변수에만 적용할 수 있기 때문에, 변수를 모두 수치형으로 변환한다
# LabelEncoder 를 통해 수치형 변수가 아닌 변수를 변환한다
non_numeric_columns = list(student_data.select_dtypes(exclude=[np.number]).columns)
le = LabelEncoder()
for col in non_numeric_columns:
    student_data[col] = le.fit_transform(student_data[col])

# NOTEARS 알고리즘을 적용한다
student_model = from_pandas(student_data)
```

그래프를 그려보면 모든 노드들이 서로 연결된 Fully Connected Graph가 등장한다. threshold를 통해 edge 간의 연결이 약한 경우를 연결을 끊어버릴 수 있다.
다음과 같은 두 가지 방식을 통해 threshold 를 결정할 수 있다

- `from_pandas` 함수를 사용할 때 `w_threshold` 파라미터를 설정한다
- `sm.remove_edges_below_threshold()` 메서드를 사용한다

```python
# threshold 보다 작은 edge를 제거한다
student_model.remove_edges_below_threshold(0.8)

# 그래프를 그려서 확인한다
viz = plot_structure(
    student_model,
    graph_attributes={"scale": "0.5"},
    all_node_attributes=NODE_STYLE.WEAK,
    all_edge_attributes=EDGE_STYLE.WEAK)
filename = "./structure_model.png"
viz.draw(filename)
Image(filename)
```

생성된 관계를 살펴보면, 직관적으로 맞지 않는 경우가 있다. 발생해서는 안되는 관계가 있다면, 구조를 학습할 때 제약조건으로 포함시킬 수 있다.

```python
student_model2 = from_pandas(student_data, tabu_edges=[("higher", "Medu")], w_threshold=0.8)
```

## Modifying the Structure

변수 간의 관계가 잘못되었다면, 도메인 지식을 바탕으로 구조 학습 결과를 수정할 수 있다. edge를 더하거나 제거해보자.

```python
student_model2.add_edge("failures", "G1")
student_model2.remove_edge("Pstatus", "G1")
student_model2.remove_edge("address", "G1")
```

학습된 그래프를 보면 `Dalc -> Walc` 로 이어지는 edge가 따로 떨어져 있고, 일부는 큰 subgraph로 묶여있다.
`get_largest_subgraph()` 메서드를 통해 가장 큰 subgraph를 추출할 수 있다.

```python
student_model3 = student_model.get_largest_subgraph()

student_model3.edges
# OutEdgeView([
#     ('address', 'absences'), 
#     ('address', 'G1'), 
#     ('Pstatus', 'famrel'), 
#     ('Pstatus', 'absences'), 
#     ('Pstatus', 'G1'), 
#     ('studytime', 'G1'), 
#     ('failures', 'absences'), 
#     ('paid', 'absences'), 
#     ('higher', 'Medu'), 
#     ('higher', 'G1'), 
#     ('internet', 'absences'), 
#     ('G1', 'G2'), 
#     ('G2', 'G3')
# ])
```

이제 모형의 구조를 결정했다면, `BayesianNetwork` 를 시작할 수 있다. 각각의 feature에 대한 조건부 확률 분포를 학습해보자.

```python
bn_student = BayesianNetwork(student_model3)
```
