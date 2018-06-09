
# 베이지안 방법을 통한 기계학습

빈도주의 방법이 가능한 모든 파라미터 중에서 가장 정확한 것을 얻으려고 한다면, 머신러닝은 가능한 모든 파라미터 중에서 가장 예측력이 좋은 결과를 얻으려고 한다. 때로는 우리가 예측해야 하는 것과 빈도주의 방법이 최적화하는 것이 서로 다를 수 있다.

예를 들면, 최소제곱 선형회귀 (least-square linear regression) 에서 회귀계수를 결정하는 손실함수는 제곱오차손실 (squared-error loss) 이다. 반면에 우리가 예측하려는 손실함수는 오차제곱이 아닐 경우, 최적의 예측 결과를 얻을 수 없게 된다.

베이즈 추정치를 찾는 것은 모수의 정확도를 높이는 파라미터를 찾는 것이 아니다. 성과를 측정하기 위한 임의의 지표가 있을 때, 이 지표를 최적화하고자 한다.

## 예제1: 금융예측

주식 가격의 미래수익률이 매우 작아서, 0.01 (1%) 정도라고 가정해보자. 제곱오차손실을 활용해 예측할 경우 부호를 무시하기 때문에, -0.01로 예측하는 것과 0.03으로 예측하는 것이 동일하게 나쁜 것으로 계산된다. 예측한 값과 실제 값의 부호를 고려한 손실함수를 구성할 수 없을까??


```python
from plotnine import *
import numpy as np
import pandas as pd

import matplotlib
# 음수(-) 표기시 폰트가 깨지는 문제 해결
matplotlib.rcParams['axes.unicode_minus'] = False
```


```python
def stock_loss(true_return, yhat, alpha=100):
    if true_return * yhat < 0:
        # true_return이 좋지 않으면 부호를 바꾼다
        return alpha*yhat**2 - np.sign(true_return)*yhat + abs(true_return)
    else:
        return abs(true_return - yhat)
```


```python
true_value = 0.05
pred = np.linspace(-0.04, 0.12, 75)

df_pred = pd.concat(
    [pd.DataFrame({'true_value': str(d), 
                   'pred': pred,
                   'loss': [stock_loss(d, _p) for _p in pred]}) 
     for d in [0.05, -0.02]])
```


```python
(ggplot(df_pred, aes(x='pred', y='loss', color='true_value')) +
 geom_line() +
 geom_vline(xintercept=0, linetype='--') +
 xlab('예측') + ylab('손실') +
 ylim(0, 0.25) +
 ggtitle('참값이 0.05 / -0.02 일 때 수익률 손실') +
 scale_x_continuous(breaks=[(x-2)/50 for x in range(0, 9)]) +
 theme_gray(base_family='Kakao') +
 theme(figure_size=(12,6))
)
```


![png](fig_ch5_3/output_8_0.png)


예측곡선이 0인 지점을 통과할 때 손실곡선이 어떻게 지나는지 살펴보면, 잘못된 부호를 추측하거나 큰 폭으로 틀리는 것을 피하려 한다는 것을 알 수 있다. 금융기관은 하방위험과 상방위험을 비슷하게 다룬다. 따라서 참값에서 멀어질수록 큰 손실을 입게 된다.
