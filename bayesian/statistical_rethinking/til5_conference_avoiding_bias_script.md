# 시즌5 지식공유회 데이터 생성 및 그래프 스크립트

## Multicollinearity Example

```r
# library(rethinking)
library(tidyverse)

simulate_height <- function(N, seed = 123) {
  # N : 시뮬레이션 하려는 인원수
  set.seed(seed)                 # Random Seed 설정
  leg_prop <- runif(N, 0.4, 0.5) # 키 대비 다리의 비율
  
  # 키, 왼다리, 오른다리 길이를 시뮬레이션한다
  tibble(
    height = rnorm(N, 10, 2),
    leg_left = leg_prop*height + rnorm(N, 0, 0.02), 
    leg_right = leg_prop*height + rnorm(N, 0, 0.02)
  )
}

# 100명의 키를 시뮬레이션으로 생성한다
height_data <- simulate_height(100)
```


```r
lm(height ~ leg_left, data = height_data)
# left : 2.014 (통계적으로 유의미함)
# (키가 왼쪽 다리 길이의 2.014배 정도)

lm(height ~ leg_right, data = height_data)
# right : 2.0113 (통계적으로 유의미함)
# (키가 오른쪽 다리 길이의 2.011배 정도)

lm(height ~ leg_left + leg_right, data = height_data)
# left  : 0.92    (통계적으로 유의미하지 않음)
# right : 1.0931  (통계적으로 유의미하지 않음)
```

## Post-Treatment Example

```r
simulate_plants <- function(N, seed = 123) {
  # N   : 식물의 개수
  # seed: random seed
  
  # 시뮬레이션을 통해 기본 높이값을 생성한다
  set.seed(seed)
  h0 <- rnorm(N, 10, 2)
  
  # treatment 여부를 할당한다
  treatment <- rep(0:1, each = N/2)
  # 곰팡이 발생 여부를 시뮬레이션한다
  fungus <- rbinom(N, size = 1, prob = 0.5 - treatment*0.4)
  # 곰팡이 발생에 따른 성장을 반영한다
  h1 <- h0 + rnorm(N, 5 - 3*fungus)
  
  tibble(
    h0 = h0, 
    h1 = h1,
    treatment = treatment, 
    fungus = fungus
  )
}

plant_data <- simulate_plants(100)
```

```r
lm(h_diff ~ treatment, data = plant_data %>% mutate(h_diff = h1 - h0))
# treatment 효과 : 1.213 
# 통계적으로 유의미함

lm(h_diff ~ treatment + fungus, data = plant_data %>% mutate(h_diff = h1 - h0))
# treatment 효과 : -0.0301
# 통계적으로 유의미하지 않음
```

## Collider Example

```r
simulate_paper <- function(N, top_quantile = 0.1, seed = 123) {
  # N : 생성할 데이터 개수
  # p : Select 기준이 되는 quantile
  
  # Random Seed
  set.seed(seed)
  
  # uncorrelated newsworthiness and trustworthiness
  newsworthy <- rnorm(N)
  trustworthy <- rnorm(N)
  total_score <- newsworthy + trustworthy
  
  tibble(
    newsworthy = newsworthy,
    trustworthy = trustworthy,
    total_score = total_score,
    is_selected = if_else(total_score >= quantile(total_score, 1 - top_quantile), TRUE, FALSE)
  )
}

paper_data <- simulate_paper(200)
```

```r
# 두 변수의 관계를 그래프를 통해 표현해보자
ggplot(paper_data, aes(x = newsworthy, y = trustworthy, alpha = is_selected)) +
  geom_point(size = 5) +
  scale_alpha_manual(values = c(0.3, 1)) +
  labs(alpha = 'Selected',
       x = 'Newsworthy', 
       y = 'Trustworthy') +
  theme_minimal(base_size = 24)
```
