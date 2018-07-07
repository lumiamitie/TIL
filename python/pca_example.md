
# 주성분분석 (Principal Component Analysis)


```python
from sklearn import datasets
from sklearn.decomposition import PCA
import numpy as np
```


```python
iris = datasets.load_iris()
```

## 주성분


```python
# PCA는 데이터 평균을 0으로 조정하는 과정이 필요하다
x_centered = iris.data - iris.data.mean(axis=0)

# 훈련 세트의 모든 주성분을 구한다
U, S, Vt = np.linalg.svd(x_centered)

# 처음 두 개의 주성분(PC)을 구한다
pc = Vt.T[:, :2]
```

## d차원으로 투영하기

주성분을 추출했으면 처음 d개의 주성분으로 정의한 초평면에 투영해서 데이터를 d차원으로 축소할 수 있다.


```python
x_2d = x_centered.dot(pc)
```

## 사이킷런으로 주성분분석하기


```python
# 사이킷런의 PCA 모델은 자동으로 데이터를 중앙에 맞춰준다
pca_sklearn = PCA(n_components=2)
x_2d_sklearn = pca_sklearn.fit_transform(iris.data)
```

주성분으로 설명할 수 있는 분산의 비율을 확인할 수 있다


```python
# 두 개의 주성분으로 총 분산의 97.7%를 설명할 수 있다
pca_sklearn.explained_variance_ratio_
# array([ 0.92461621,  0.05301557])
```

## 적절한 차원 수 선택하기


```python
# 방법 1 : 유지하려는 주성분 수를 결정
pca_sklearn = PCA()
pca_sklearn.fit(iris.data)

np.cumsum(pca_sklearn.explained_variance_ratio_)
# array([ 0.92461621,  0.97763178,  0.99481691,  1.        ])

d = np.argmax(np.cumsum(pca_sklearn.explained_variance_ratio_) >= 0.95) + 1
# n_components=d 로 설정하고 PCA를 수행하면 된다
pca_sklearn = PCA(n_components=d)
x_2d = pca_sklearn.fit_transform(iris.data)

# 방법 2 : 보존하려는 분산의 비율을 명시
pca_sklearn = PCA(n_components=0.95)
x_2d = pca_sklearn.fit_transform(iris.data)
```
