# Rolling distinct count 구하기

[2021년 11월 24일 R weekly Quiz](https://github.com/R-Korea/weekly_R_quiz/blob/master/202111/1.cumulative_distinct_count/cumulative_distinct_count_quiz.md) 풀어보기.

**Q. 주어진 데이터셋을 이용해 주석 처리된 결과처럼 그룹별 누적매출 및 누적고객수를 구해주세요!**

```r
library(dplyr)
library(tidyr)

# 데이터
data = tribble(
  ~user, ~time, ~group, ~revenue,
  'A', 1, 'a', 100,
  'A', 4, 'a', 200,
  'A', 3, 'b', 700,
  'A', 2, 'b', 500,
  'B', 1, 'a', 1000,
  'B', 4, 'b', 300,
  'B', 2, 'a', 600,
  'C', 1, 'a', 400,
  'C', 3, 'a', 100,
  'C', 2, 'b', 200,
  'C', 1, 'b', 1200
)

#### 목표 결과 ####
# A tibble: 8 x 4
#   group  time c_revenue c_user_count
#   <chr> <dbl>     <dbl>        <int>
# 1 a         1      1500            3
# 2 a         2      2100            3
# 3 a         3      2200            3
# 4 a         4      2400            3
# 5 b         1      1200            1
# 6 b         2      1900            2
# 7 b         3      2600            2
# 8 b         4      2900            3
```

## 해결방법 (by 민호)

```r
library(tidyverse)
data %>% 
  group_by(group, time) %>% 
  summarise_at(vars(user, revenue), ~ list(.x)) %>% 
  group_by(group) %>% 
  mutate_at(vars(user, revenue), ~ purrr::accumulate(.x, ~ c(.x, .y))) %>% 
  mutate(user = purrr::map_int(user, ~ length(unique(.x))),
         revenue = purrr::map_dbl(revenue, ~ sum(.x))) %>% 
  ungroup() %>% 
  select(group, time, c_revenue = revenue, c_user_count = user)
# # A tibble: 8 x 4
#   group  time c_revenue c_user_count
#   <chr> <dbl>     <dbl>        <int>
# 1 a         1      1500            3
# 2 a         2      2100            3
# 3 a         3      2200            3
# 4 a         4      2400            3
# 5 b         1      1200            1
# 6 b         2      1900            2
# 7 b         3      2600            2
# 8 b         4      2900            3
```
