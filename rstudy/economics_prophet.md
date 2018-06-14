# Prophet을 사용하여 economics 데이터의 실업률 예측하기

```r
library('tidyverse')
library('prophet')
```

R에 내장된 economics 데이터를 바탕으로 실업률 추이를 그린다

```r
economics %>% 
  mutate(unemploy_ratio = unemploy / pop) %>% 
  ggplot(aes(x = date, y = unemploy_ratio)) +
  geom_line() +
  scale_y_continuous(labels = scales::percent)
```

일부 구간을 슬라이스하여 모델을 학습시킨다 (60개월)

```r
model_sample_unemp = economics %>% 
  mutate(unemploy_ratio = unemploy / pop) %>% 
  select(ds = date, y = unemploy_ratio) %>% 
  slice(1:60) %>% 
  prophet()
```

학습된 구간 이후 30개월에 대해 예측한다

```r
pred_sample_unemp = model_sample_unemp %>% 
  predict(., make_future_dataframe(., 30, freq = 'm')) %>% 
  tbl_df()
```

실제값과 예측값을 비교한다

```r
economics %>% 
  mutate(unemploy_ratio = unemploy / pop) %>% 
  slice(1:90) %>% 
  mutate(type = c(rep('real_tr', 60), rep('real_ts', 30))) %>% 
  select(ds = date, type, unemploy_ratio) %>% 
  bind_rows(
    pred_sample_unemp %>% 
      tail(30) %>% 
      mutate(type = 'pred', ds = as.Date(ds)) %>% 
      select(ds, type, unemploy_ratio = yhat)
  ) %>% 
  ggplot(aes(x = ds, y = unemploy_ratio, color = type)) +
    geom_line(size = 0.8) +
    scale_color_manual(values = c('orange', 'black', '#aaaaaa'), guide = 'none') +
    scale_y_continuous(labels = scales::percent)
```
