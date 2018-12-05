# Python Jupyter에서 R 사용하는 팁들 정리

- python 객체 input, output

```
%%R -i corr_mat -o r_fa_weight
# 파이썬에서 corr_mat를 받고, R에서는 r_fa_weight를 내보낸다

library('tidyverse')
library('psych')

model_fa = psych::fa(corr_mat, nfactors = 2, fm = 'minres', rotate = 'varimax')
r_fa_weight = model_fa$weight
```

- R figure 사이즈

* https://stackoverflow.com/q/40745163

```
%%R -w 800 -h 600
```
