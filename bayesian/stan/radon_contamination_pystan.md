# PyStan을 이용한 베이지안 다층모형

다음 문서를 정리한다. <http://mc-stan.org/users/documentation/case-studies/radon.html>

위계모형, 다층모형 등은 회귀모형을 일반화시킨 결과물이다. 

**다층모형 (Multilevel Model)** 은 모형의 파라미터에 확률 모형이 반영된 회귀모형을 말한다. 이것은 파라미터가 그룹별로 달라진다는 것을 의미한다. 관측한 데이터들은 자연스럽게 클러스터를 이루는 경우가 있다. 이러한 클러스터로 인해 아무리 샘플링을 잘 했다고 하더라도 데이터 사이에 의존성이 생기게 된다.

**위계모형 (Hierarchical Model)** 은 특정 파라미터 안에 다른 파라미터가 중첩되어 있는 다층모형의 특수한 경우를 말한다.

# Radon Contamination 예제

라돈 수치는 가구마다 다르다. 80,000 가구의 라돈 수치를 조사했다. 중요한 두 가지 변수는 다음과 같다.

- 지하실 / 1층의 수치 (보통 지하실의 라돈 수치가 높다)
- 카운티의 우라늄 수치 (라돈 수치와 상관관계가 있다)

미네소타 주의 라돈 수치를 중심으로 살펴보자. 이 예제에서 hierarchy는 카운티 내의 가구들이다


```python
import pystan
import pandas as pd
import numpy as np
from plotnine import *

%matplotlib inline
```


```python
url_srrs = 'https://raw.githubusercontent.com/pymc-devs/pymc3/master/pymc3/examples/data/srrs2.dat'
url_cty = 'https://github.com/pymc-devs/pymc3/raw/master/pymc3/examples/data/cty.dat'
```


```python
srrs = pd.read_csv(url_srrs)
cty = pd.read_csv(url_cty)
```


```python
srrs_mn = (srrs
    .loc[lambda d: d.state=='MN']
    .rename(columns={'activity': 'radon'})
    .assign(fips = lambda d: d.stfips*1000 + d.cntyfips,
            log_radon = lambda d: np.log(d.radon + 0.1))
)
```


```python
cty_mn = (cty
    .loc[lambda d: d.st == 'MN']
    .assign(fips = lambda d: d.stfips*1000 + d.ctfips)
    .loc[:, ['fips', 'Uppm']]
)
```


```python
radon_mn = srrs_mn.merge(cty_mn, on='fips')
```


```python
radon_mn.loc[:,'log_radon'].hist(bins=25)
```

![png](fig/radon_contamination_pystan/output_12_1.png)


# 전통적인 접근방법

라돈 노출을 모델링하는 전통적인 두 가지 접근방법은 bias-variance trade-off에서 말하는 양 극단을 표현한다.

**Complete Pooling :**
- 모든 카운티의 라돈 수준이 동일할 것이라고 가정한다
- `y_i = alpha + beta * x_i + e_i`

**No Pooling :**
- 모든 카운티가 라돈 수준이 다를 (독립적일) 것이라고 가정한다
- `y_i = alpha_ij + beta * x_i + e_i (j = 1, ..., 85)`

## Complete Pooling

모형을 stan으로 표현하기 위해서 `data` 블록을 작성하는 것부터 시작해보자. `data` 블록에는 다음과 같은 항목이 필요하다

- **y** : log radon 수치로 구성된 벡터
- **x** : 층
- **N** : 샘플 수


```python
pooled_data = """
data {
  int<lower=0> N;
  vector[N] x;
  vector[N] y;
}
"""
```

이제 파라미터를 초기화해보자. 여기서는 선형 모형의 계수들과 정규분포의 scale parameter가 필요하다. scale parameter는 양수 범위로 제한한다는 점을 주의하자.


```python
pooled_parameters = """
parameters {
  vector[2] beta;
  real<lower=0> sigma;
}
"""
```

마지막으로, log-radon 수치를 정규분포로부터 샘플링하도록 모형을 작성한다. 정규분포의 평균은 해당 가구의 층에 대한 함수로 작성한다


```python
pooled_model = """
model {
  y ~ normal(beta[1] + beta[2] * x, sigma);
}
"""
```

이제 `stan` 함수에 data, parameter, model을 넘긴다. 이 과정에서 추가로 제공해야 하는 정보들이 있는데, iteration을 몇 번 반복할 것인지, 몇 개의 병렬 체인을 사용할 것인지 등을 결정해야 한다. 여기서는 2체인으로 1000번 추출한다.


```python
log_radon = radon_mn['log_radon'].values
floor_measure = radon_mn['floor'].values
```


```python
pooled_data_dict = {
    'N': len(log_radon),
    'x': floor_measure,
    'y': log_radon
}

pooled_fit = pystan.stan(
    model_code=pooled_data + pooled_parameters + pooled_model,
    data=pooled_data_dict,
    iter=1000,
    chains=2
)
```


그래프를 그리거나 지표를 요약하기 위해 샘플을 추출할 수 있다


```python
pooled_sample = pooled_fit.extract(permuted=True)
```


```python
b0, m0 = pooled_sample['beta'].T.mean(axis=1)

(ggplot(radon_mn, aes(x='floor', y='log_radon')) +
 geom_point() +
 geom_abline(slope=m0, intercept=b0, color='orange', linetype='--', size=1.5) +
 ylab('log_radon = log(radon + 0.1)') +
 theme(figure_size=(10,6))
)
```


![png](fig/radon_contamination_pystan/output_26_1.png)
