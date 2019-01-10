# promotionImpack 라이브러리 로직 이해하기

<https://github.com/ncsoft/promotionImpact> 의 내부 구조를 이해해보자!

```r
library('tidyverse')
library('prophet')
library('lubridate')

#### 0. promotionImpack 의 내장 데이터들 불러오기 ####
# <https://github.com/ncsoft/promotionImpact/tree/master/data>
load(file = 'adventure/promotion_impact_data/sim.data.rda')
load(file = 'adventure/promotion_impact_data/sim.promotion.rda')

#### 1. var.type 'smooth' or 'dummy' ####

tbl_df(sim.data)
tbl_df(sim.promotion)

#### _ 1.1 var.type 'smooth' ####

#### __ 1.1.1 Preprocessing ####

# MIN_DATE = min(sim.promotion$start_dt)
# MAX_DATE = max(sim.promotion$end_dt)
# TOTAL_DAYS = as.numeric(MAX_DATE - MIN_DATE) + 1
# FULL_DATE_VECTOR = MIN_DATE + (seq_len(TOTAL_DAYS) - 1)

# 데이터에 JOIN 하기 위한 프로모션 정보
tbl_promotion = sim.promotion %>%
  tbl_df() %>%
  mutate(duration = as.integer(end_dt - start_dt) + 1,
         dt = map2(start_dt, duration, ~ .x + (seq(.y) - 1) )) %>%
  unnest(dt) %>%
  mutate(days_passed = as.integer(dt - start_dt) + 1L) %>%
  select(dt, pro_id, tag_info, start_dt, end_dt)


#### __ 1.1.2 Modeling ####

tbl_data = sim.data %>%
  tbl_df() %>%
  # left_join(tbl_promotion, by = 'dt') %>%
  select(ds = dt, y = simulated_sales, pro_id, tag_info)

prophet_model = prophet(tbl_data, changepoint.prior.scale = 0.5)
prophet_fitted = predict(prophet_model, tbl_data)

# period_cnt = length(prophet_model$seasonalities)
trend_component = prophet_fitted$trend
period_component = prophet_fitted$additive_terms

tbl_data_for_lm = tbl_data %>%
  mutate(trend_period = trend_component + period_component)

tbl_data_for_lm %>%
  gather(key = 'cate', value = 'value', y:trend_period) %>%
  ggplot(aes(x = ds, y = value, color = cate, alpha = cate)) +
    geom_line() +
    scale_color_manual(values = c('steelblue','#999999')) +
    scale_alpha_manual(values = c(1, 0.5))

lm_model = lm(y ~ trend_period, data = tbl_data_for_lm)
lm_model$residuals # 일별 잔차를 프로모션의 일별 효과로 간주한다

#### _ 1.2 var.type 'dummy' preprocessing ####
```
