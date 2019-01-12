# Hyperparameter Optimization

## Parameter Tuning with Hyperopt

- [Github : Hyperopt](https://github.com/hyperopt/hyperopt)
- [Parameter Tuning with Hyperopt](https://districtdatalabs.silvrback.com/parameter-tuning-with-hyperopt)

```python
from hyperopt import fmin, tpe, hp, STATUS_OK, Trials
from hyperopt.pyll import stochastic

import numpy as np
import pandas as pd
from plotnine import *

from sklearn import datasets
from sklearn.svm import SVC
from sklearn.model_selection import cross_val_score
```

### Objective Functions

#### A Motivating Example

```python
def fn01(x: float) -> float:
    return x

best = fmin(
    fn=fn01,                     # 1) a function to minimize
    space=hp.uniform('x', 0, 1), # 2) search space
                                 # * hp.uniform(name, lower_bound, upper_bound)
    algo=tpe.suggest,            # 3) a search algorithm
                                 # * tpe : Tree of Parzen estimators
                                 # * hyperopt.random
    max_evals=100                # 4) the maximum number of evaluations
)

print(best)
# {'x': 0.0001894435058028554}

x0 = np.linspace(0, 1)
y0 = [fn01(x) for x in x0]

(pd.DataFrame({'x': x0, 'y': y0})
  .pipe(ggplot, aes(x='x', y='y')) +
  geom_line() +
  geom_point(data=pd.DataFrame({'x': [best['x']], 'y': [best['x']] }),
             color='red', size=4) +
  ggtitle('$y = x$') +
  theme(figure_size=(12,6))
)
```

#### More Complicated Examples

```python
def fn02(x: float) -> float:
    return (x-1)**2

best02 = fmin(
    fn=fn02,
    space=hp.uniform('x', -2, 2),
    algo=tpe.suggest,
    max_evals=100)

print(best02)
# {'x': 1.0044889988796173}

x02 = np.linspace(-1, 3)
y02 = [fn02(x) for x in x02]

(pd.DataFrame({'x': x02, 'y': y02})
  .pipe(ggplot, aes(x='x', y='y')) +
  geom_line() +
  geom_point(data=pd.DataFrame({'x': [best02['x']], 'y': [fn02(best02['x'])] }),
             color='red', size=4) +
  ggtitle('$y = (x-1)^2$') +
  theme(figure_size=(12,6))
)
```

### Search Spaces

- `hp.choice(label, options)` : options should be a python list or tuple.
- `hp.normal(label, mu, sigma)` : mu and sigma are the mean and standard deviation, respectively.
- `hp.uniform(label, low, high)` : low and high are the lower and upper bounds on the range.
- Others are available
    - `hp.lognormal`, `hp.quniform`, ...

```python
space = {
    'x': hp.uniform('x', 0, 1),
    'y': hp.normal('y', 0, 1),
    'name': hp.choice('name', ['alice', 'bob']),
}

stochastic.sample(space)
# {'name': 'bob', 'x': 0.3125330068342136, 'y': -0.9206711439292883}
```

### 적용해보기

Support Vector Machines (SVM) 을 적용해보자

```python
iris = datasets.load_iris()
X = iris.data
y = iris.target

def hyperopt_train_test(params):
    X_ = X[:]

    clf = SVC(**params)
    return cross_val_score(clf, X_, y).mean()

svm_space = {
    'C': hp.uniform('C', 0, 20),
    'kernel': hp.choice('kernel', ['linear', 'sigmoid', 'poly', 'rbf']),
    'gamma': hp.uniform('gamma', 0, 20)
}

def f(params):
    acc = hyperopt_train_test(params)
    return {'loss': -acc, 'status': STATUS_OK}

trials = Trials()
best_svm = fmin(f, svm_space, algo=tpe.suggest, max_evals=100, trials=trials)
```

```python
best_svm
# {'C': 8.120732167473776, 'gamma': 2.402758461691043, 'kernel': 3}

trials.trials
# 각 trial에 대한 정보가 남는다
```

```python
trials_loss = dict()

# 각 iteration별로 사용된 파라미터 정리
for key in best_svm:
    trials_loss[key] = np.array([t['misc']['vals'][key] for t in trials.trials]).ravel()

# 각 iteration별 -Loss값 계산
trials_loss['loss'] = np.array([-t['result']['loss'] for t in trials.trials]).ravel()

df_trials_loss = pd.DataFrame(trials_loss)
```

## Bayes_opt

- <https://github.com/fmfn/BayesianOptimization> 를 이용한 적용
- <http://philipperemy.github.io/visualization/>

```python
from bayes_opt import BayesianOptimization

def train2(c, gamma):
    X_ = X[:]
    clf = SVC(C=c, gamma=gamma, kernel='rbf')
    return cross_val_score(clf, X_, y).mean()

svm_space2 = {
    'c': (0, 20),
    'gamma': (0, 20)
}

bo = BayesianOptimization(train2, svm_space2)
bo.maximize(init_points=2, n_iter=0, acq='ucb', kappa=5)
# |   iter    |  target   |     c     |   gamma   |
# -------------------------------------------------
# |  5        |  0.9734   |  4.188    |  5.821    |
# |  6        |  0.9473   |  2.398    |  12.98    |
# =================================================
```
