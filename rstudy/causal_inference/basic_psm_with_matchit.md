# MatchIt 라이브러리를 사용한 Propensity Score Matching

`MatchIt` 라이브러리에는 Propensity Score Matching 을 위한 다양한 기법들이 구현되어 있다.

```r
# 필요한 라이브러리를 미리 설치한다
# install.packages(c('MatchIt', 'optmatch', 'lmtest', 'sandwich'))
library(MatchIt)
library(tidyverse)

# 타입을 쉽게 확인할 수 있도록 tibble로 변환해둔다
data('lalonde', package = 'MatchIt')
lalonde = tibble(lalonde)
# # A tibble: 614 x 9
#    treat   age  educ race   married nodegree  re74  re75   re78
#    <int> <int> <int> <fct>    <int>    <int> <dbl> <dbl>  <dbl>
#  1     1    37    11 black        1        1     0     0  9930.
#  2     1    22     9 hispan       0        1     0     0  3596.
#  3     1    30    12 black        0        0     0     0 24909.
#  4     1    27    11 black        0        1     0     0  7506.
#  5     1    33     8 black        0        1     0     0   290.
#  6     1    22     9 black        0        1     0     0  4056.
#  7     1    23    12 black        0        0     0     0     0 
#  8     1    32    11 black        0        1     0     0  8472.
#  9     1    22    16 black        0        0     0     0  2164.
# 10     1    33    12 white        1        0     0     0 12418.
# # … with 604 more rows

# Full matching on the propensity score
m_match <- matchit(
  treat ~ age + educ + race + married + nodegree + re74 + re75, 
  data = lalonde, 
  method = 'full',
  estimand = 'ATE'
)
# A matchit object
# - method: Optimal full matching
# - distance: Propensity score
#             - estimated with logistic regression
# - number of obs.: 614 (original), 614 (matched)
# - target estimand: ATE
# - covariates: age, educ, race, married, nodegree, re74, re75
```

Matching 이후 Treatment/Control 그룹간 균형을 확인할 수 있다.

```r
# Checking covariate balance before and after matching:
summary(m_match)
# Call:
#   matchit(formula = treat ~ age + educ + race + married + nodegree + 
#             re74 + re75, data = lalonde, method = "full", estimand = "ATE")
# 
# Summary of Balance for All Data:
#   Means Treated Means Control Std. Mean Diff. Var. Ratio eCDF Mean eCDF Max
# distance          0.5774        0.1822          1.7569     0.9211    0.3774   0.6444
# age              25.8162       28.0303         -0.2419     0.4400    0.0813   0.1577
# educ             10.3459       10.2354          0.0448     0.4959    0.0347   0.1114
# raceblack         0.8432        0.2028          1.6708          .    0.6404   0.6404
# racehispan        0.0595        0.1422         -0.2774          .    0.0827   0.0827
# racewhite         0.0973        0.6550         -1.4080          .    0.5577   0.5577
# married           0.1892        0.5128         -0.7208          .    0.3236   0.3236
# nodegree          0.7081        0.5967          0.2355          .    0.1114   0.1114
# re74           2095.5737     5619.2365         -0.5958     0.5181    0.2248   0.4470
# re75           1532.0553     2466.4844         -0.2870     0.9563    0.1342   0.2876
# 
# 
# Summary of Balance for Matched Data:
#   Means Treated Means Control Std. Mean Diff. Var. Ratio eCDF Mean eCDF Max Std. Pair Dist.
# distance          0.3023        0.3010          0.0061     1.0428    0.0144   0.0939          0.0188
# age              25.3926       27.0514         -0.1812     0.3407    0.1004   0.2386          0.9938
# educ             10.4572       10.2546          0.0820     0.6380    0.0326   0.0830          1.0212
# raceblack         0.3990        0.3932          0.0153          .    0.0058   0.0058          0.0307
# racehispan        0.1124        0.1172         -0.0163          .    0.0049   0.0049          0.4405
# racewhite         0.4886        0.4896         -0.0025          .    0.0010   0.0010          0.3119
# married           0.3959        0.3972         -0.0029          .    0.0013   0.0013          0.4105
# nodegree          0.5573        0.6304         -0.1544          .    0.0730   0.0730          0.8955
# re74           3057.6819     4582.1754         -0.2577     0.6216    0.0907   0.2800          0.7157
# re75           1375.1228     2176.3056         -0.2461     0.8442    0.1003   0.2087          0.7985
# 
# Percent Balance Improvement:
#   Std. Mean Diff. Var. Ratio eCDF Mean eCDF Max
# distance              99.7       49.0      96.2     85.4
# age                   25.1      -31.1     -23.5    -51.3
# educ                 -83.3       35.9       6.0     25.5
# raceblack             99.1          .      99.1     99.1
# racehispan            94.1          .      94.1     94.1
# racewhite             99.8          .      99.8     99.8
# married               99.6          .      99.6     99.6
# nodegree              34.4          .      34.4     34.4
# re74                  56.7       27.7      59.6     37.4
# re75                  14.3     -278.9      25.2     27.4
# 
# Sample Sizes:
#   Control Treated
# All            429.    185.  
# Matched (ESS)  264.62   22.35
# Matched        429.    185.  
# Unmatched        0.      0.  
# Discarded        0.      0.  
```

다음과 같은 형태로 ATE를 추정한다.

```r
# Matched Dataset
lalonde_matched <- match.data(m_match)
# # A tibble: 614 x 12
#    treat   age  educ race   married nodegree  re74  re75   re78 distance weights subclass
#    <int> <int> <int> <fct>    <int>    <int> <dbl> <dbl>  <dbl>    <dbl>   <dbl> <fct>   
#  1     1    37    11 black        1        1     0     0  9930.   0.639    0.603 1       
#  2     1    22     9 hispan       0        1     0     0  3596.   0.225    1.21  103     
#  3     1    30    12 black        0        0     0     0 24909.   0.678    0.603 8       
#  4     1    27    11 black        0        1     0     0  7506.   0.776    0.339 15      
#  5     1    33     8 black        0        1     0     0   290.   0.702    0.362 24      
#  6     1    22     9 black        0        1     0     0  4056.   0.699    0.603 32      
#  7     1    23    12 black        0        0     0     0     0    0.654    0.452 38      
#  8     1    32    11 black        0        1     0     0  8472.   0.790    0.335 46      
#  9     1    22    16 black        0        0     0     0  2164.   0.780    0.339 15      
# 10     1    33    12 white        1        0     0     0 12418.   0.0429   1.21  58      
# # … with 604 more rows

# Fit linear model with matched dataset
fit_matched <- lm(
  re78 ~ treat,
  weights = weights, 
  data = lalonde_matched
)

# ATE를 추정한다
lmtest::coeftest(fit_matched, vcov. = sandwich::vcovCL, cluster = ~subclass)
# t test of coefficients:
#   
#             Estimate Std. Error t value  Pr(>|t|)    
# (Intercept)  6249.45     874.18  7.1489 2.502e-12 ***
# treat        -677.19    1783.19 -0.3798    0.7043    
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

# 참고자료

- <https://kosukeimai.github.io/MatchIt/index.html>
