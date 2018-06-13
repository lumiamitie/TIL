# T-SNE

아래 포스팅의 내용을 간단히 정리하였다.

<https://ratsgo.github.io/machine%20learning/2017/04/28/tSNE/>

## SNE (Stochastic Neighbor Embedding)

- 고차원의 원공간에 존재하는 데이터 x의 이웃간의 거리를 최대한 보존하는 저차원의 y를 학습하는 방법론이다
- 거리 정보를 확률적으로 표현하기 때문에 stochastic이라는 이름이 붙어있다
- 기본적인 컨셉
    - (1) 고차원 원공간에 존재하는 개체 x가 주어졌을 때 이웃 y가 선택될 확률 분포를 구한다 ~ p
    - (2) 저차원에 임베딩된 개체 x가 주어졌을 때 이웃 y가 선택될 확률 분포를 구한다 ~ q
    - (3) p와 q의 분포가 최대한 적은 차이가 나도록 학습한다 (KL divergence를 최소화 시킨다) -> Gradient Descent 사용
- 몇 가지 계산상의 트릭을 도입하여 학습속도를 향상시켰다

## Crowding Problem

- SNE는 가우시안 분포를 전제로 한다
- 가우시안 분포는 꼬리가 두텁지 않기 때문에, 조금 떨어져있는 두 개체와 멀리 떨어져 있는 개체들의 확률 차이가 크지 않다

## t-SNE
- SNE의 Crowding Problem을 해결하기 위해 q에 대해서는 꼬리가 더 두터운 t 분포를 사용한다 (자유도 1인 t분포)
- 따라서 군집 관계를 더 잘 표현할 수 있도록 한다


# T-SNE in practice

## R

`tsne` 라이브러리의 `tsne` 함수를 사용한다

```r
# 결과물을 재현하기 위해 난수 seed를 설정
set.seed(1)
# data.frame을 matrix로 변환 후 t-sne 적용
iris_tsne = tsne::tsne(as.matrix(iris[1:4]))
```

## Python

`scikit-learn` 라이브러리를 사용한다

```python
import pandas as pd
import numpy as np

iris = pd.read_csv('https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv')

# 결과물을 재현하기 위해 난수 seed를 설정
np.random.seed(1)

# matrix 형태로 변환 후 t-sne 적용
iris_matrix = iris.iloc[:, 0:4].values
iris_tsne_result = TSNE(learning_rate=300, init='pca').fit_transform(iris_matrix)
```
