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
