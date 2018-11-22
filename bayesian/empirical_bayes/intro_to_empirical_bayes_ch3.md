# 3. Empirical Bayes estimation

4/10 과 300/1000 중에서 어느 쪽의 확률이 더 높을까? 언뜻 바보같은 질문일 수 있다. 당연히 0.4 > 0.3 이니깐. 하지만 당신이 야구 스카우터라면, 10타석에서 4번 안타를 친 선수와 1000 타석에서 300 안타를 친 선수 중 어떤 선수를 고를것인가?

Ch2에서는 타율에 대한 간단한 가정을 가지고 살펴보았다. 이번에는 실제 데이터를 바탕으로 해답을 찾아보자

```r
library('tidyverse')
library('Lahman')

# 투수의 경우 대체로 타율이 낮기 때문에 계산에서 제외하였다
career = Batting %>% 
  filter(AB > 0) %>% 
  anti_join(Pitching, by = 'playerID') %>% 
  group_by(playerID) %>% 
  summarise(H = sum(H), AB = sum(AB)) %>% 
  mutate(average = H / AB)

# 선수의 실제 이름을 찾아내자
player_names = Master %>% 
  tbl_df %>% 
  select(playerID, nameFirst, nameLast) %>% 
  unite(player_id, nameFirst, nameLast, sep = ' ', starts_with('name'))

# playerID 값을 선수의 실제 이름으로 변경한다
career = career %>% 
  inner_join(player_names, by = 'playerID') %>% 
  select(player_id, H, AB, average)
```

## Step1 - Estimate a prior from all your Data

500타석 이상 들어선 타자들의 통산 타율 분포는 peak가 한 개 존재하는 일반적인 형태의 확률분포 형태를 보인다. 따라서 여기에는 Beta 분포를 사용하면 적합할 것 같다.

```r
career %>% 
  filter(AB > 500) %>% 
  ggplot(aes(x = average)) +
    geom_histogram(bins = 50)
```
따라서 다음과 같은 모형을 세워보자. 

`X ~ Beta(alpha0, beta0)`

Maximum Likelihood 방법을 통해 모형을 fitting 시킬 수 있다

```r
career_filtered = career %>% filter(AB > 500)


ll = function(alpha, beta) {
  x = career_filtered$H
  total = career_filtered$AB
  bb_density = VGAM::dbetabinom.ab(x, total, alpha, beta, log=TRUE)
  return(-sum(bb_density))
}

# MLE
m = stats4::mle(
  ll, 
  start=list(alpha=1, beta=10), 
  method='L-BFGS-B', 
  lower=c(0.0001, 0.1)
)

ab = stats4::coef(m)

# fitting된 결과를 실제 결과물과 비교해보자
career %>% 
  filter(AB > 500) %>% 
  ggplot(aes(x = average, y = ..density..)) +
  geom_histogram(bins = 50) +
  geom_line(data = data_frame(x = seq(0.14, 0.36, by = 0.001),
                              y = dbeta(x, ab[1], ab[2])),
            aes(x = x, y = y), color = 'red')
```

## Step2 - Use that distribution as a prior for each individual estimate

이제 전체 데이터를 바탕으로 만든 prior를 데이터를 통해 update 한다
Ch2에서 살펴봤듯이, 

- `alpha0` -> `alpha0 + # of Hits`
- `alpha0 + beta0` -> `alph0 + beta0 + # of AB`

를 계산해주면 된다

예를 들어, 1000타석 중에 300번 안타를 쳤을 경우 다음과 같이 계산할 수 있다

```
# 0.2889776
(300 + ab[[1]]) / (1000 + ab[[1]] + ab[[2]])
```

10타석 중에 4안타를 치는 경우 타율은 다음과 같다

```
# 0.2641392
(4 + ab[[1]]) / (10 + ab[[1]] + ab[[2]])
```

300/1000 의 결과가 더 높은 타율을 보이는 것을 확인할 수 있다.

```r
# data.frame에 한꺼번에 계산해놓자
career_eb = career %>% 
  mutate(eb_estimate = (H + ab[[1]]) / (AB + ab[[1]] + ab[[2]]))

career_eb %>% 
  arrange(eb_estimate)

career_eb %>% 
  arrange(desc(eb_estimate))
```

empirical Bayes를 통해 계산할 경우, 한두 타석에서 타율 100% 찍는 경우가 두드러지지 않는다. 
오랜 기간에 걸쳐 꾸준히 잘하거나 꾸준히 못하는 경우가 반영된다. 
실제 통산타율과 예측값을 비교하면 타석이 많아질수록 예측값들이 실제 평균값과 비슷해진다는 것을 확인할 수 있다. 
이것을 보통 **shrinkage** 라고 한다

shrinkage를 간단하게 설명한다면 다음과 같이 이해할 수 있다.

> 정말 특이한 결과를 얻으려면 그만큼 특이한 데이터가 필요하다
