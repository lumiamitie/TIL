# lalonde 데이터로 ATE 구하기

## IPW (using MatchIt)

DoWhy 예제를 보다가 IPW를 적용해서 ATE를 구하는 예시가 있길래, R에서도 시도해보았다.

[DoWhy | lalonde example](https://microsoft.github.io/dowhy/example_notebooks/dowhy_lalonde_example.html)

```r
library(MatchIt)
library(dplyr)
# 참고. matchit 에서 method="full" 을 쓰려면 "optmatch" 라이브러리를 추가로 설치해야 한다

data('lalonde', package = 'MatchIt')
lalonde = tibble(lalonde)

# Matching -> Propensity Score 를 계산한다
# TODO : MatchIt 라이브러리 없이 PS를 따로 계산해보자
m_match <- matchit(
  treat ~ age + educ + race + married + nodegree,
  data = lalonde, 
  method = 'full',
  estimand = 'ATT'
)
lalonde_matched <- match.data(m_match)

# IPW 계산
lalonde_ipw <- lalonde_matched %>% 
  mutate(y1_hat = treat * re78 / distance / sum(treat / distance),
         y0_hat = (1 - treat) * re78 / (1 - distance) / sum((1 - treat) / (1 - distance))) %>% 
  summarise(sum_y1_hat = sum(y1_hat),
            sum_y0_hat = sum(y0_hat)) %>% 
  mutate(ATE = sum_y1_hat - sum_y0_hat)

# Causal Estimate 확인하기
sprintf('Causal Estimate is %.2f', lalonde_ipw$ATE)
# Causal Estimate is 237.88
```

TODO: DoWhy 예시에서는 1600 정도 나오는데 값 차이가 왜이렇게 큰걸까?
