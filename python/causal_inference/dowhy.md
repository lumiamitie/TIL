# dowhy

## google colaboratory에 설치하기

colab에서 다음과 같은 스크립트를 통해 라이브러리를 설치한다.

```
!cd /content
!git clone https://github.com/microsoft/dowhy.git
!python /content/dowhy/setup.py install
```

```python
import sys
sys.path.append('/content/dowhy')

import numpy as np
import pandas as pd

import dowhy
from dowhy.do_why import CausalModel
import dowhy.datasets
```

## 기본 튜토리얼 따라하기

TODO
