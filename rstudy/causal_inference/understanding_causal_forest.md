# Causal Forest 이해하기

다음 포스팅의 내용을 일부 요약한다.

[CausalForest : Explicitly Optimizing on Causal effects via the Causal random forest](https://www.markhw.com/blog/causalforestintro)

특정한 처리(treatment)로 발생한 인과 효과에 최적화된 모형을 학습시키려면 어떻게 해야 할까? 
이러한 작업을 위해서는 lift, 즉 실험군과 대조군 사이에 발생할 결과값의 차이를 추정할 수 있어야 한다. 
결과인 Y변수를 예측하는 데만 집중하고 인과 관계를 무시하는 경향이 있는 대부분의 지도 학습 방법론과는 다른 방식이다. 
하지만 최근들어 머신러닝 쪽에서도 인과 관계, 특히 "heterogeneous treatment effects" 라는 주제에 집중한 논문들이 늘어나고 있다. 
최근 몇 년간 Treatment effects의 추정과 예측에 대한 흥미로운 논문이 많이 출간되었지만, 방법론을 제안하는 사람들과 사용할 사람들 사이의 간극이 존재한다. 
여기서는 모형이 동작하는 방식을 소개하고, 분석을 위한 R 코드를 제시하여 그 간극을 해소하고자 한다.

# Finding Heterogenous Treatment Effects

## 이론적 배경

- 목표는 각 개인별 인과 효과인 Y(Treatment) - Y(Control) 을 구하는 것이다
- 많은 방법론들이 Rubin Causal Model (Potential Outcomes model) 을 기반으로 모형을 정의한다
    - 어떤 사람이 treatment 대상자였다면, control 대상이었다면 어땠을지 예측하여 차이를 구한다
    - 현실에서는 절대로 일어날 수 없는 현상 → "the fundamental problem of causal inference"
- 한 가지 대안은 사람들을 서로 비슷한 두 개의 그룹으로 나누어 treatment / control 여부를 배정하는 것이다
    - 이렇게 하면 그룹 내의 평균적인 처리 효과(ATE, Average Treatment Effect)를 구할 수 있다. 이것은 샘플에 포함된 모든 사람들에 대해 treatment 배정되었을 때 얼마나 향상되는지(lift)를 구한 값이다.
    - 이를 위해서는 두 그룹이 실제로 "비슷한지" 를 확인할 수 있어야 하지만, 여기서는 동일 실험 내의 HTE를 찾는 것을 우선으로 하기 때문에 넘어간다
- HTE 와 관련된 연구는 대부분 다음과 같은 문제를 풀고자 한다
    - **서로 비슷한 프로파일을 가진 사람들이 조건에 따라 어떻게 결과가 달라지는지 비교하고, 이 차이를 바탕으로 Treatment 효과를 추정한다**

## Heterogenous Treatment Effects 구하기: An Overview

- HTE를 구하기 위해서는 Conditional average treatment effect(CATE) 를 구해야 한다
    - 주어진 공변량 조건에 대해서 treatment, control 양쪽 그룹 모두의 값을 예측하고, treatment 그룹의 추정치에서 control 그룹의 추정치를 빼면 해당 조건에 대한 CATE를 구할 수 있다
    - 따라서 고전적인 회귀 모형으로도 HTE를 구할 수 있다
- 그렇다면 왜 더 복잡한 모형이 필요할까?
    - 일반적인 문제에서는 변수를 1개만 다루지 않는다
    - 10개의 변수가 존재한다면 10개의 인터렉션이 존재하는지 확인해야 하는데, 이 경우 검정력이 크게 떨어진다
    - 또한 모든 변수들이 선형 관계를 가진다는 보장이 없다

# The Honest Causal Forests

Honest causal forests는 honest causal tree들로 구성된 랜덤 포레스트 모형을 말한다. 
Honest Causal tree가 기존의 의사결정 트리와 다른 점을 찾기 위해서는 다음 두 가지 질문에 대한 답을 해야 한다. 

1. 어떻게 인과 효과를 추정할 수 있는 것일까?
2. 무엇 때문에 Honest 한 트리가 되는 것일까?

## What Makes it causal?

- MSE를 최소화하는 일반적인 리그레션 트리와 달리, 인과 효과를 추정할 때는 Treatment Effect 에 관심이 있다
- 하지만 모든 데이터는 treatment와 control 그룹 중 하나에만 속할 수 있기 때문에, 우리는 실제 Treatment Effect 를 관측할 수 없다
- 그 대신 트리의 리프 노드에서 treatment 그룹과 control 그룹의 차이를 구하고 이를 treatment effect 라고 정의한다
- Causal tree는 노드를 분할할 때 다음과 같은 두 가지 기준이 균형이 맞는 지점을 찾는다
    - Treatment Effect 의 차이가 가장 커지는 지점을 찾는다
    - Treatment Effect 를 정확하게 추정한다
- 그냥 Y을 예측하고 조건에 따른 차이를 구하는 방법론보다 훨씬 인과관계에 가까운 답을 도출할 수 있다

## What makes it honest?

- 인과관계를 기준으로 트리를 나눌 때 오버피팅이 발생하지 않게 하려면 어떻게 해야 할까?
- 학습 데이터를 두 가지 그룹으로 나눈다 : 쪼개기용 vs 추정용
    - 쪼개기용 샘플에서는 위에서 논의한 분할 기준을 바탕으로 Causal Tree를 구성한다
    - 추정용 샘플에서는 leaf node 마다 treatment와 control 그룹의 평균 차이를 구한다


- Treatment Effect의 추정치는 근사적으로 정규 분포를 따른다
    - 따라서 분산을 통해 신뢰구간을 구할 수 있다
    - 또한 가설 검정을 통해 유의미한 효과가 존재하는 대상만 추출하는 것이 가능하다

# 예시

```r
library(tidyverse)

#### 데이터 불러오기 ####
canvass_data_url <- 'https://raw.githubusercontent.com/markhwhiteii/blog/master/hte_intro/broockman_kalla_replication_data.tab'
canvass_raw <- read_tsv(canvass_data_url, col_types = cols(.default = "c")) # 모든 컬럼을 문자열 타입으로 파싱하도록 설정

#### 기본적인 전처리 ####
canvass <- canvass_raw %>% 
  filter(respondent_t1 == "1.0" & contacted == "1.0") %>% 
  transmute(
    treatment = factor(ifelse(treat_ind == "1.0", "Treatment", "Control"), levels = c('Control', 'Treatment')),
    trans_therm_post = as.numeric(therm_trans_t1),
    trans_therm_pre = as.numeric(therm_trans_t0),
    age = as.numeric(vf_age),
    party = factor(vf_party),
    race = factor(vf_racename),
    voted14 = as.integer(vf_vg_14),
    voted12 = as.integer(vf_vg_12),
    voted10 = as.integer(vf_vg_10),
    sdo = as.numeric(sdo_scale), # Social dominance orientation
    canvass_minutes = as.numeric(canvass_minutes)
  ) %>% 
  filter(complete.cases(.))
# # A tibble: 419 x 11
#    treatment trans_therm_post trans_therm_pre   age party race    voted14 voted12 voted10       sdo canvass_minutes
#    <fct>                <dbl>           <dbl> <dbl> <fct> <fct>     <int>   <int>   <int>     <dbl>           <dbl>
#  1 Control                  3               0    29 D     Africa…       0       1       0 -6.63e-10               3
#  2 Treatment              100              50    35 D     Africa…       1       1       0  7.11e- 2              13
#  3 Treatment               50              50    63 D     Africa…       1       1       1 -5.50e- 1              12
#  4 Control                 30              47    51 N     Caucas…       1       1       0 -1.01e- 1               0
#  5 Control                 50              74    26 D     Africa…       1       1       0 -6.63e-10               1
#  6 Treatment               84              76    62 D     Africa…       1       1       1 -9.01e- 1              20
#  7 Treatment               50              50    20 D     Africa…       1       0       0 -7.60e- 1              20
#  8 Control                 50              50    51 R     Caucas…       1       1       1  4.19e- 1               1
#  9 Treatment               50             100    53 R     Caucas…       0       1       1 -6.74e- 1               5
# 10 Treatment               89              64    66 D     Hispan…       1       1       1  1.14e- 1               2
# # … with 409 more rows

# trans_therm_pre 변수 기준으로 백분위 25%~75% 사이에 존재하는지 여부를 확인하여 middle 변수에 기록한다
# - neutral, uncertrain 타겟팅 전략의 효과와 비교하기 위한 변수이다
canvass_full <- canvass %>% 
  mutate(middle = between(trans_therm_pre, quantile(trans_therm_pre, 0.25), quantile(trans_therm_pre, 0.75)),
         middle = as.integer(middle))

#### Train/Test Set 분리 ####
set.seed(1839)
sample_idx <- sample(seq_len(nrow(canvass_full)), round(nrow(canvass_full) * 0.6))
tr_canvass <- canvass_full %>% slice(sample_idx)
ts_canvass <- canvass_full %>% slice(-sample_idx)

#### Causal forest 학습 ####
# X : a matrix of the covariates
# Y : a vector of the outcome of interest
# W : a vector ot the treatment assignment
model_cf <- grf::causal_forest(
  X = model.matrix(~ ., data = tr_canvass %>% select(-c(1:2))),
  Y = tr_canvass$trans_therm_post,
  W = as.numeric(tr_canvass$treatment) - 1,
  num.trees = 5000,
  seed = 1839
)

#### Test data 예측 ####
preds_cf <- predict(
  object = model_cf, 
  newdata = model.matrix(~ ., data = ts_canvass %>% select(-c(1:2))),
  estimate.variance = TRUE
)

# Test data에 예측 결과 추가
ts_canvass_preds <- ts_canvass %>% 
  mutate(preds = preds_cf$predictions)

#### 변수별 중요도 추출하기 ####
model_cf %>% 
  grf::variable_importance() %>% {
    tibble(
      variable = colnames(model_cf$X.orig),
      importance = .[,1]
  )} %>% 
  arrange(-importance)
# # A tibble: 15 x 2
#    variable         importance
#    <chr>                 <dbl>
#  1 age                  0.292 
#  2 trans_therm_pre      0.140 
#  3 canvass_minutes      0.138 
#  4 sdo                  0.102 
#  5 raceCaucasian        0.0515
#  6 voted14              0.0501
#  7 middle               0.0476
#  8 raceHispanic         0.0447
#  9 voted10              0.0425
# 10 partyN               0.0370
# 11 partyR               0.0336
# 12 voted12              0.0205
# 13 (Intercept)          0     
# 14 partyOther Party     0     
# 15 raceAsian            0   
```
