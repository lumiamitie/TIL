# Examining covariate balance in the matched sample

Matching 결과로 생성된 데이터셋의 변수별 balance를 확인하려면 어떻게 해야 할까?

## 데이터 준비

```r
library(MatchIt)
library(tidyverse)

data('lalonde', package = 'MatchIt')
lalonde = tibble(lalonde)

# Propensity Score Matching
m_nearest_match <- matchit(
  treat ~ age + educ + race + married + nodegree + re74 + re75, 
  data = lalonde, 
  method = 'nearest'
)
lalonde_nearest_matched <- match.data(m_nearest_match)
```

## 변수별 직접 비교

- numeric 변수는 `t.test` 를 통해 직접 비교한다
- factor 변수는 그냥 변수별 비율을 계산하도록 했다
    - `Matchit` 에서는 factor 변수를 one-hot encoding 처리한 뒤, 각 항목별 Binary 정보를 가지고 비율을 계산해준다

```r
# Examining covariate balance in the matched sample
lapply(
  c('age', 'educ', 'race', 'married', 'nodegree', 're74', 're75'),
  function(v) { 
    target_col <- lalonde_nearest_matched[[v]]
    if ('factor' %in% class(target_col)) {
      # factor 변수는 항목별 비중을 계산
      table(lalonde_nearest_matched[[v]], lalonde_nearest_matched$treat) %>% 
        as.data.frame() %>% 
        tidyr::pivot_wider(names_from = 'Var2', values_from = 'Freq', names_prefix = 'is_treated_') %>% 
        rename(category = Var1) %>% 
        mutate(treated_ratio = is_treated_1 / (is_treated_0 + is_treated_1))
    } else {
      # numeric 변수는 t.test로 비교
      t.test(lalonde_nearest_matched[[v]] ~ lalonde_nearest_matched$treat)  
    }
  }
)
# [[1]]
# 
# 	Welch Two Sample t-test
# 
# data:  lalonde_nearest_matched[[v]] by lalonde_nearest_matched$treat
# t = -0.54663, df = 323.08, p-value = 0.585
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -2.361671  1.334644
# sample estimates:
# mean in group 0 mean in group 1 
#        25.30270        25.81622 
# 
# 
# [[2]]
# 
# 	Welch Two Sample t-test
# 
# data:  lalonde_nearest_matched[[v]] by lalonde_nearest_matched$treat
# t = 1.0588, df = 342.62, p-value = 0.2904
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -0.2225287  0.7414476
# sample estimates:
# mean in group 0 mean in group 1 
#        10.60541        10.34595 
# 
# 
# [[3]]
# # A tibble: 3 x 4
#   category is_treated_0 is_treated_1 treated_ratio
#   <fct>           <int>        <int>         <dbl>
# 1 black              87          156         0.642
# 2 hispan             40           11         0.216
# 3 white              58           18         0.237
# 
# [[4]]
# 
# 	Welch Two Sample t-test
# 
# data:  lalonde_nearest_matched[[v]] by lalonde_nearest_matched$treat
# t = 0.51866, df = 367.4, p-value = 0.6043
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -0.06035472  0.10359796
# sample estimates:
# mean in group 0 mean in group 1 
#       0.2108108       0.1891892 
# 
# 
# [[5]]
# 
# 	Welch Two Sample t-test
# 
# data:  lalonde_nearest_matched[[v]] by lalonde_nearest_matched$treat
# t = -1.4408, df = 366.87, p-value = 0.1505
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -0.16617907  0.02563853
# sample estimates:
# mean in group 0 mean in group 1 
#       0.6378378       0.7081081 
# 
# 
# [[6]]
# 
# 	Welch Two Sample t-test
# 
# data:  lalonde_nearest_matched[[v]] by lalonde_nearest_matched$treat
# t = 0.51835, df = 360.8, p-value = 0.6045
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -688.7829 1181.8506
# sample estimates:
# mean in group 0 mean in group 1 
#        2342.108        2095.574 
# 
# 
# [[7]]
# 
# 	Welch Two Sample t-test
# 
# data:  lalonde_nearest_matched[[v]] by lalonde_nearest_matched$treat
# t = 0.27046, df = 354.04, p-value = 0.787
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -518.5986  683.9782
# sample estimates:
# mean in group 0 mean in group 1 
#        1614.745        1532.055 
```

mathchit 객체에 `summary` 함수를 사용하면 전체 변수에 대한 Balance 정보를 확인할 수 있다.

```r
summary(m_nearest_match)
# Call:
#   matchit(formula = treat ~ age + educ + race + married + nodegree + 
#             re74 + re75, data = lalonde, method = "nearest")
# 
# Summary of Balance for All Data:
#            Means Treated Means Control Std. Mean Diff. Var. Ratio eCDF Mean eCDF Max
# distance          0.5774        0.1822          1.7941     0.9211    0.3774   0.6444
# age              25.8162       28.0303         -0.3094     0.4400    0.0813   0.1577
# educ             10.3459       10.2354          0.0550     0.4959    0.0347   0.1114
# raceblack         0.8432        0.2028          1.7615          .    0.6404   0.6404
# racehispan        0.0595        0.1422         -0.3498          .    0.0827   0.0827
# racewhite         0.0973        0.6550         -1.8819          .    0.5577   0.5577
# married           0.1892        0.5128         -0.8263          .    0.3236   0.3236
# nodegree          0.7081        0.5967          0.2450          .    0.1114   0.1114
# re74           2095.5737     5619.2365         -0.7211     0.5181    0.2248   0.4470
# re75           1532.0553     2466.4844         -0.2903     0.9563    0.1342   0.2876
# 
# 
# Summary of Balance for Matched Data:
#            Means Treated Means Control Std. Mean Diff. Var. Ratio eCDF Mean eCDF Max Std. Pair Dist.
# distance          0.5774        0.3629          0.9739     0.7566    0.1321   0.4216          0.9740
# age              25.8162       25.3027          0.0718     0.4568    0.0847   0.2541          1.3938
# educ             10.3459       10.6054         -0.1290     0.5721    0.0239   0.0757          1.2474
# raceblack         0.8432        0.4703          1.0259          .    0.3730   0.3730          1.0259
# racehispan        0.0595        0.2162         -0.6629          .    0.1568   0.1568          1.0743
# racewhite         0.0973        0.3135         -0.7296          .    0.2162   0.2162          0.8390
# married           0.1892        0.2108         -0.0552          .    0.0216   0.0216          0.8281
# nodegree          0.7081        0.6378          0.1546          .    0.0703   0.0703          1.0106
# re74           2095.5737     2342.1076         -0.0505     1.3289    0.0469   0.2757          0.7965
# re75           1532.0553     1614.7451         -0.0257     1.4956    0.0452   0.2054          0.7381
# 
# Percent Balance Improvement:
#            Std. Mean Diff. Var. Ratio eCDF Mean eCDF Max
# distance              45.7     -239.6      65.0     34.6
# age                   76.8        4.6      -4.2    -61.1
# educ                -134.8       20.4      31.2     32.1
# raceblack             41.8          .      41.8     41.8
# racehispan           -89.5          .     -89.5    -89.5
# racewhite             61.2          .      61.2     61.2
# married               93.3          .      93.3     93.3
# nodegree              36.9          .      36.9     36.9
# re74                  93.0       56.8      79.1     38.3
# re75                  91.2     -800.7      66.3     28.6
# 
# Sample Sizes:
#           Control Treated
# All           429     185
# Matched       185     185
# Unmatched     244       0
# Discarded       0       0
```
