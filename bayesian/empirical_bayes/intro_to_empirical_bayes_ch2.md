# 2. 베타분포

## 2.3 Conjugate Prior

```r
library('tidyverse')
library('Lahman')

num_trials = 10e6
```

우리가 생각했던 Prior 대로 `Beta(81, 219)` 의 확률을 계산한다. 그리고 300번의 타석을 시뮬레이션 해보자

```r
simulations = data_frame(
  true_average = rbeta(num_trials, 81, 219),
  hits = rbinom(num_trials, 300, true_average)
)
```

300타석 중에서 정확히 100 안타를 친 타자들을 찾아보자

```r
hit_100 = simulations %>% 
  filter(hits == 100)
```

300타석 중에서 100안타를 친 타자들의 타율은 어떤 분포로 나타날까? 타율이 0.2인 타자들도 있겠지만, 해당 타자들은 100안타를 거의 치지 못했다. 타율이 0.33인 타자들의 경우, 그보다는 더 쉽겠지만 그런 타자가 많지는 않다. 분포의 median 부근을 보면 실제 타율이 0.3 가까운 타자들이 제일 많다. 이것이 바로 **posterior estimate**이다.

```r
hit_100 %>% 
  ggplot(aes(x = true_average, y = ..density..)) +
    geom_histogram(bins = 50) +
    geom_line(data = data_frame(x = seq(0.2, 0.4, by = 0.001),
                                y = dbeta(x, 81 + 100, 219 + 200)),
              aes(x=x, y=y), colour = 'red')
```

안타의 수가 각각 60, 80 개인 타자들의 분포는 어떨까? 확인해보면 모양은 비슷하다. (Beta 분포를 따르니까) 하지만 데이터에 맞게 조금씩 분포가 이동되어 있다.

```r
simulations %>% 
  filter(hits %in% c(60, 80, 100)) %>% 
  ggplot(aes(x = true_average, color = factor(hits))) +
    geom_density() +
    scale_color_brewer(palette = 'Paired') +
    labs(color = 'H', x = '안타 개수별 실제 타율 분포') +
    theme_bw(base_family = 'Apple SD Gothic Neo')
```
