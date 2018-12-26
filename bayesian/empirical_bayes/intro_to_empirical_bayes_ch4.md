# 4. Credible Intervals

데이터를 분석하다보면 우리가 추정한 값의 불확실성에 대해서 알고싶어질 때가 있다.
그런데 전통적인 통계적 기법보다 우리가 알고 있는 사전 지식이 더 구체적인 구간으로 나타나는 경우가 있다.
예를 들면, 타율의 분포는 대체로 0.2~0.3 사이이지만
`binom.test` 함수를 이용해 3타석 중에서 1번 안타를 쳤을 경우 타율의 신뢰구간은
`(0.008, 0.906)` 정도가 된다고 한다

```r
binom.test(1, 3)
```

Empirical Bayes를 바탕으로 Credible Interval을 구해보자

```r
# 데이터 준비
library('tidyverse')
library('Lahman')

career = Batting %>%
  filter(AB > 0) %>%
  anti_join(Pitching, by = 'playerID') %>%
  group_by(playerID) %>%
  summarise(H = sum(H),
            AB = sum(AB)) %>%
  mutate(average = H / AB)

player_names = Master %>%
  tbl_df() %>%
  select(playerID, nameFirst, nameLast) %>%
  unite(player_name, nameFirst, nameLast, sep = " ")

career = career %>%
  left_join(player_names, by = 'playerID') %>%
  select(playerID, player_name, H, AB, average)

alpha0 = 101.4
beta0 = 287.3

career_eb = career %>%
  mutate(eb_estimate = (H + alpha0) / (AB + alpha0 + beta0),
         alpha1 = alpha0 + H,
         beta1 = beta0 + AB - H)
```

career_eb 의 결과는 새롭게 예측한 타율. 특히 point estimate 값이다.

```r
target_player = c('willibe02', 'knoblch01', 'strawda01', 'jeterde01', 'posadjo01',
                  'brosisc01', 'martiti02')

career_eb %>%
  filter(playerID %in% target_player) %>%
  rowwise() %>%
  do(data_frame(playerId = .$playerID,
                x = 15:40/100,
                density = dbeta(x, .$alpha1, .$beta1))) %>%
  ungroup %>%
  ggplot(aes(x = x, color = playerId, y = density)) +
    geom_line() +
    scale_color_brewer(palette = 'Paired')


career_eb %>%
  filter(playerID %in% target_player) %>%
  mutate(low = qbeta(0.025, alpha1, beta1),
         high = qbeta(0.975, alpha1, beta1),
         name = reorder(player_name, eb_estimate)) %>%
  ggplot(aes(x = eb_estimate, y = name)) +
    geom_point() +
    geom_errorbarh(aes(xmin = low, xmax = high)) +
    geom_vline(xintercept = alpha0 / (alpha0 + beta0), color = 'red', lty = 2) +
    xlab('Estimated Batting Average (w/ 95% interval)') +
    ylab('Player')
```
