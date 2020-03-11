# 5. The Many Variables & The Spurious Waffles

미국 각 주의 1인당 와플집 개수와 이혼률 사이에는 높은 상관관계가 존재한다. 1인당 와플집이 많은 주들은 이혼율이 높고, 적은 주들은 이혼율이 낮다. 
와플이 결혼 생활에 위기를 불러오는 것일까? 그럴리가 없다. 이것은 상관관계를 잘못 해석한 전형적인 사례다. 
와플집은 조지아주에서 1955년에 시작되었고, 시간이 지나면서 남부 지방에 널리 퍼지게 되었다. 
그러니까 와플집이라는 변수는 사실 남부 지방과 관련이 있는 변수인 것이다. 와플집이 많다는 것과 이혼율이 높다는 것이 남부 지방에서 우연히 동시에 일어나고 있었다. 

상관 계수가 높다고 해서 인과 관계가 있다고 볼 수는 없다. 따라서 우리는 상관 관계와 인과 관계를 구분할 수 있는 도구가 필요하다. 
그래서 Multiple Regression 을 다루는데 많은 노력을 기울이고자 한다. 왜냐면 Multiple Regression 이 다음과 같은 내용들을 포함하고 있기 때문이다.

1. 교란변수에 대한 통계적인 통제 (Statistical "control" for confounds)
2. 여러 개의 인과적인 원인 (Multiple causation)
3. 상호작용 (Interaction)

# 5.1 Spurious association

조금 더 쉬운 이해를 위해 이혼율과 결혼율을 비교해보자. 이혼율과 결혼율 사이에는 상관관계가 존재한다. 
그렇다면 결혼이 이혼을 유발하는가? 결혼하지 않으면 이혼할 수 없다는 것은 확실하다. 하지만 높은 결혼율이 높은 이혼율로 이어질 이유는 없다. 
또 한 가지 이혼율과 관련된 변수는 결혼 연령이다. 결혼을 늦게 할수록 이혼율이 낮아지는 추세를 보인다. 데이터를 통해 확인해보자.

```r
library(rethinking)
library(tidyverse)

# rethinking 라이브러리에서 WaffleDivorce 데이터를 불러온다
data('WaffleDivorce', package = 'rethinking')

# 중위결혼연령 변수와 이혼율 변수를 표준화시킨다
waffle_divorce <- WaffleDivorce %>% 
    as_tibble() %>% 
    mutate(s_age = scale(MedianAgeMarriage),
           s_divorce = scale(Divorce))
```

선형 회귀 모형을 만들어보자.

```
D_i    ~ Normal(mu_i, sigma)
mu_i   = alpha + beta_A * A_i
alpha  ~ Normal(0, 0.2)
beta_A ~ Normal(0, 0.5)
sigma  ~ Exponential(1)

* D_i : i 주의 표준화된 이혼율
* A_i : i 주의 중위 결혼연령
```

각 Prior는 무엇을 의미할까? 두 변수를 모두 표준화했기 때문에 alpha는 0에 가까워질 것이다. 
`beta_A = 1` 이라면 결혼연령 값의 변화가 이혼율의 변화를 모두 설명할 수 있다는 이야기가 된다. 이건 엄청나게 강한 관계를 의미한다. 
위 Prior는 `beta_A` 기울기가 1보다 클 확률을 5% 정도로 설정한다. 

이제 Posterior를 근사시켜보자. 추가로 알아야하는 테크닉은 없다.

```r
# 모형을 fitting 한다
model_waffle_divorce <- quap(
    alist(
        s_divorce ~ dnorm(mu, sigma),
        mu <- a + bA * s_age,
        a ~ dnorm(0, 0.2),
        bA ~ dnorm(0, 0.5),
        sigma ~ dexp(1)
    ),
    data = waffle_divorce
)

# Prior를 바탕으로 시뮬레이션 해보자 (샘플링)
set.seed(123)
prior <- extract.prior(model_waffle_divorce)
prior_simulated_mu <- link(
    model_waffle_divorce, 
    post = prior , 
    # s_age = 2 또는 -2 일 때 어떤 s_divorce 값이 나올지 시뮬레이션한다
    data = list(s_age=c(-2, 2))
)

# 현재 Prior를 가정했을 때 나올만한 회귀선을 시뮬레이션하여 그래프로 표현
prior_simulated_mu %>% 
    as_tibble() %>% 
    rename(s_age = V1, s_divorce = V2) %>% 
    mutate(index = row_number()) %>% 
    ggplot() +
        geom_segment(aes(x = -2, xend = 2, y = s_age, yend = s_divorce, group = index), 
                    color = '#1D4E89', alpha = 0.1) +
        labs(x = 'Median Age Marriage (std)', y = 'Divorce Rate (std)',
            title = 'Simulated regression lines from current prior') +
        theme_minimal(base_size = 14)
```

![](fig/ch5_marriage_divorce_prior_simulation_01.png)

이번에는 Posterior 예측 결과를 시뮬레이션 해보자.

이번에는 Posterior 예측 결과를 시뮬레이션 해보자. 아래 그래프를 보면 우측은 좌측 그래프에 비해 약한 상관관계를 보인다는 것을 알 수 있다. 
하지만 이런 방식의 비교로는 어떤 예측 변수가 더 나은지 알 수 없다. 두 변수가 서로 독립적일 수도 있고, 중복되거나 서로 상쇄할 수도 있다. 

```r
# 평균에 대한 Percentile Interval을 계산한다 (Median Age Marriage)
age_seq <- seq(from = -3, to = 3.2, length.out = 30)
post_mu <- link(model_waffle_divorce, data = list(s_age = age_seq))
post_mu_mean <- apply(post_mu, 2, mean)
post_mu_PI <- apply(post_mu, 2, PI)

# 그래프로 그리기 쉽게 데이터 프레임으로 묶는다
post_mu_result <- tibble(
    s_age = age_seq,
    mu_mean = post_mu_mean,
    mu_PI_05 = post_mu_PI[1,],
    mu_PI_94 = post_mu_PI[2,],
)

# 결혼율 변수도 표준화시킨다
waffle_divorce2 <- waffle_divorce %>% 
    mutate(s_marriage = scale(Marriage)[,1])

# 결혼율과 이혼율의 관계를 모형으로 fitting 한다
model_waffle_divorce2 <- quap(
    alist(
    s_divorce ~ dnorm(mu, sigma),
    mu <- a + bM * s_marriage,
    a ~ dnorm(0, 0.2),
    bM ~ dnorm(0, 0.5),
    sigma ~ dexp(1)
    ),
    data = waffle_divorce2
)

# 평균에 대한 Percentile Interval을 계산한다 (Marriage)
m_seq <- seq(from = -2, to = 3, length.out = 30)
post_mu <- link(model_waffle_divorce2, data = list(s_marriage = m_seq))
post_mu_mean <- apply(post_mu, 2, mean)
post_mu_PI <- apply(post_mu, 2, PI)

post_mu_result_marriage <- tibble(
    s_marriage = age_seq,
    mu_mean = post_mu_mean,
    mu_PI_05 = post_mu_PI[1,],
    mu_PI_94 = post_mu_PI[2,],
)

# 그래프로 확인해보자
p1 <- waffle_divorce %>% 
    ggplot(aes(x = s_age)) +
    geom_point(aes(y = s_divorce), color = '#1D4E89', alpha = 0.5) +
    geom_line(data = post_mu_result, aes(y = mu_mean)) +
    geom_ribbon(data = post_mu_result, aes(ymin = mu_PI_05, ymax = mu_PI_94),
                fill = '#1D4E89', alpha = 0.5) +
    labs(x = 'Median Age Marriage (std)', y = 'Divorce Rate (std)') +
    theme_minimal(base_size = 20)

p2 <- waffle_divorce2 %>% 
    ggplot(aes(x = s_marriage)) +
    geom_point(aes(y = s_divorce), color = '#1D4E89', alpha = 0.5) +
    geom_line(data = post_mu_result_marriage, aes(y = mu_mean)) +
    geom_ribbon(data = post_mu_result_marriage, aes(ymin = mu_PI_05, ymax = mu_PI_94),
                fill = '#1D4E89', alpha = 0.5) +
    labs(x = 'Marriage Rate (std)', y = 'Divorce Rate (std)') +
    theme_minimal(base_size = 20)

gridExtra::grid.arrange(p1, p2, ncol = 2)
```

![](fig/ch5_marriage_divorce_posterior_01.png)

이러한 문제를 이해하기 위해서는 인과적으로 생각해야 한다. 

## 5.1.1 Think before you regress

현재 중요한 세 가지 변수가 있다. 

- 이혼율 (D)
- 결혼율 (M)
- 중위 결혼 연령(A)

변수들 사이의 관계를 잘 이해하기 위해서, DAG (Directed Acyclic Graph) 라고 불리는 그래프를 사용하는 것이 도움이 된다. 
현재 DAG를 그려보면 다음과 같다. 이것은 몇 가지 내포하고 있는 내용이 있다. 
`A -> M` 그리고 `M -> D` 로 연결되어 있기 때문에 결혼 연령은 이혼율에 두 가지 방식으로 영향을 준다.

```
A -> M
A -> D
M -> D
```

서로 다른 화살표의 영향을 추론하기 위해서는 하나 이상의 통계 모형이 필요하다. 
`A` 를 통해 `D` 의 효과를 설명하는 회귀 모형을 만들면 모든 경로를 포함하는 전체 효과만을 알 수 있다. 
하지만 지금 문제에서는 간접적인 경로는 거의 효과가 없다. 그걸 어떻게 증명할 수 있을까?
