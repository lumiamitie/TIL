# Prophet - Sunspot 데이터 예측하기

```r
library('tidyverse')
library('prophet')

df_sunspot = broom::tidy(sunspot.year) %>% 
  mutate(year = seq(1700, 1988, 1)) %>% 
  select(year, y = x) %>% 
  tbl_df() %>% 
  mutate(ds = lubridate::ymd(year, truncated = 2))

ggplot(df_sunspot, aes(x = year, y = y)) +
  geom_line()

df_sunspot %>% 
  slice(seq_len(nrow(.) - 30))

# 총 데이터 개수
total_row_length = nrow(df_sunspot)
# 테스트셋 데이터 수
n_ts_dataset = 30
# 훈련셋 인덱스
tr_index = seq_len(total_row_length - n_ts_dataset)
# 테스트셋 인덱스
ts_index = seq(total_row_length - n_ts_dataset + 1, total_row_length)

# 훈련셋 테스트셋 분리
tr_sunspot = df_sunspot %>% select(ds, y) %>% slice(tr_index)
ts_sunspot = df_sunspot %>% select(ds, y) %>% slice(ts_index)

# 훈련셋 데이터 학습
m = prophet(tr_sunspot)

# 학습 + 예측하려는 기간(30년)의 데이터프레임 생성
df_future_range = make_future_dataframe(m, periods = 30, freq = 'year')

# 예측
df_future_predict = predict(m, df_future_range) %>% tbl_df()
df_future_predict %>% 
  select(ds, yhat, yhat_lower, yhat_upper)

plot(m, df_future_predict)


# Box-Cox Transformation
trans_bc = caret::BoxCoxTrans(tr_sunspot$y + 0.0001)

tr_sunspot_boxcox = df_sunspot %>% 
  mutate(y = predict(trans_bc, y)) %>% 
  select(ds, y) %>% 
  slice(tr_index)

ts_sunspot_boxcox = df_sunspot %>% 
  mutate(y = predict(trans_bc, y)) %>% 
  select(ds, y) %>% 
  slice(ts_index)

m_bc = prophet(tr_sunspot_boxcox)
df_future_range_bc = make_future_dataframe(m_bc, periods = 30, freq = 'year')
df_future_predict_bc = predict(m_bc, df_future_range_bc) %>% tbl_df()

plot(m, df_future_predict)
```