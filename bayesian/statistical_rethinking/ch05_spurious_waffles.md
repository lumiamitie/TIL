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

## 5.1.2 Testable implications

데이터를 통해 가능한 여러 인과 모형을 비교하려면 어떻게 해야 할까? 
먼저 해야 할 일은 모형이 **내포하고 있는 것 중에서 테스트 가능한 내용(Testable implication)** 을 찾는 것이다. 
DAG 중에서 어떤 경우에는 특정한 조건 하에서 변수들이 독립이 되는 경우가 있다. 
이것을 **조건부 독립(Conditional Independence)** 이라고 하는데, 이것도 테스트 해볼만 한 항목이다.

조건부 독립은 두 가지 형태로 구성되어 있다. 

1. 어떤 변수들이 서로 연관되어 있고, 어떤 변수들이 연관되어 있지 않은지 나타낸다
2. 일부 변수들이 특정한 조건을 만족할 때 변수 간의 연관성이 사라지는지 여부를 나타낸다

수식으로는 다음과 같이 나타낸다.

```
Y ㅛ X|Z
: 변수 Z의 값이 주어진다면 Y와 X 변수는 서로 연관이 없다 (독립이다)
```

조건부 독립 관계를 찾는 것은 어렵지는 않다. 잘 보이지는 않지만, 조금 연습하면 금방 찾을 수 있게 된다. 
하지만 찾는 것이 어렵다면, `dagitty` 라이브러리를 사용해보자.

```r
library(dagitty)

# 조건부 독립 관계가 없는 경우
DMA_dag1 <- dagitty('dag{ D <- A -> M -> D }')
impliedConditionalIndependencies(DMA_dag1)
# 
# -> 어디에 조건을 걸든지 모든 변수가 서로 관련이 있다

# 조건부 독립 관계가 있는 경우
DMA_dag2 <- dagitty('dag{ D <- A -> M }')
impliedConditionalIndependencies(DMA_dag2)
# D _||_ M | A
# -> A값에 조건을 부여하면 (A값을 결정하면) D와 M은 서로 독립적이다
```

이러한 내용을 테스트 해보려면, A에 대해 조건부로 D와 M이 독립인지 확인해보면 된다. 
그리고 여기서 다중 회귀 분석이 도움이 된다. 다음과 같은 질문을 다룰 수 있게 된다.

> 다른 모든 예측 변수를 알고 있다면, 이 변수에 대해 더 알게 되었을 때 추가적인 가치가 있을까?

## 5.1.3 Multiple regression notation

결혼율과 결혼연령 변수를 모두 사용해서 이혼율을 예측하는 모형을 세워보면 다음과 같다.

```
D_i    ~ Normal(mu_i, sigma)                   -> Probability of data
mu_i   = alpha + beta_M * M_i + beta_A * A_i   -> Linear model
alpha  ~ Normal(0, 0.2)                        -> Prior for alpha
beta_M ~ Normal(0, 0.5)                        -> Prior for beta_M
beta_A ~ Normal(0, 0.5)                        -> Prior for beta_A
sigma  ~ Exponential(1)                        -> Prior for sigma
```

## 5.1.4 Approximating the posterior

이제 모형에 데이터를 넣고 학습시켜보자.

```
D_i    ~ Normal(mu_i, sigma)                   -> D ~ dnorm(mu, sigma)
mu_i   = alpha + beta_M * M_i + beta_A * A_i   -> mu <- a + bM*M + bA*A
alpha  ~ Normal(0, 0.2)                        -> a ~ dnorm(0, 0.2)
beta_M ~ Normal(0, 0.5)                        -> bM ~ dnorm(0, 0.5)
beta_A ~ Normal(0, 0.5)                        -> bA ~ dnorm(0, 0.5)
sigma  ~ Exponential(1)                        -> sigma ~ dexp(1)
```

```r
model_divorce_multiple <- quap(
    alist(
        s_divorce ~ dnorm(mu, sigma),
        mu <- a + bM*s_marriage + bA*s_age,
        a ~ dnorm(0, 0.2),
        bM ~ dnorm(0, 0.5),
        bA ~ dnorm(0, 0.5),
        sigma ~ dexp(1)
    ),
    data = waffle_divorce2
)

precis(model_divorce_multiple)
#        mean   sd  5.5% 94.5%
# a      0.00 0.10 -0.16  0.16
# bM    -0.07 0.15 -0.31  0.18
# bA    -0.61 0.15 -0.85 -0.37
# sigma  0.79 0.08  0.66  0.91
```

결혼율 파라미터의 posterior mean인 `bM` 이 0에 가까운 것을 볼 수 있다. 기울기 파라미터인 `bA` 와 `bM` 을 중심으로 세 모형을 비교해보자.

- `bA` 의 경우 불확실성은 조금 달라졌지만 평균이 크게 변하지는 않았다
- `bM` 의 경우 결혼 연령 변수가 모형에 없을 때만 이혼율과 관련이 있다
- **특정 주의 중위 결혼연령을 알고 있다면, 해당 주의 결혼율 정보를 아는 것은 예측력에 큰 도움이 되지 않는다는** 것을 의미한다

```r
# 빠른 이해를 위해 모형 이름을 변경한다
model_age = model_waffle_divorce
model_marriage_rate = model_waffle_divorce2
model_multiple = model_divorce_multiple

coeftab(model_age, model_marriage_rate, model_multiple)
#       model_age model_marriage_rate model_multiple
# a           0         0                   0       
# bA      -0.57        NA               -0.61       
# sigma    0.79      0.91                0.79       
# bM         NA      0.35               -0.07       
# nobs       50        50                  50
```

이것은 결혼율 정보를 알아봤자 도움이 안된다는 이야기가 아니다. 
이것은 **"결혼율"에서 "이혼율" 변수로 이어지는 직접적인 인과 관계가 없거나 거의 없다는 것을** 의미한다!

## 5.1.5 Plotting multivariate posteriors

예측 변수가 한 개일 때는 그래프로 간단히 그릴 수 있었지만, 두 개 이상의 예측 변수를 사용하게 되면 그래프를 더 많이 그려야 한다. 
해석을 도와주는 세 가지 그래프를 살펴보자.

1. Predictor residual plots
    - 결과 변수와 잔차를 비교한다
    - 통계 모형을 이해하는 데는 도움이 되지만, 다른 역할은 크게 없다
2. Posterior prediction plots
    - 원본 데이터와 모형을 통한 예측 결과를 비교한다
    - 학습 및 예측 결과를 확인하기 위해 사용한다
3. Counterfactual plots
    - 가상의 실험에 대한 예측 결과를 보여준다
    - 1개 이상의 변수에 대한 인과적인 영향을 확인하기 위해 사용한다

### 5.1.5.1 Predictor residual plots

예측 변수 잔차는 다른 모든 예측 변수로 특정 예측 변수를 설명하는 모형을 만들었을 때의 평균 오차를 의미한다. 
이것을 계산하면 다른 모든 예측 변수들에 대해 통제(controlled)된 회귀 모형을 구할 수 있다는 장점이 있다. 
이혼율 모형에서 우리는 2개의 예측 변수를 가지고 있다. 그 중 결혼율에 대해서 살펴본 다면, 다음과 같이 모형을 설정할 수 있다.

```r
model_M_from_A <- quap(
    alist(
        s_marriage ~ dnorm(mu, sigma),
        mu <- a + bAM * s_age,
        a ~ dnorm(0, 0.2),
        bAM ~ dnorm(0, 0.5),
        sigma ~ dexp(1)
    ), 
    data = waffle_divorce2
)
```

이제 잔차(residuals)를 계산하기 위해서는 실제 결혼율에서 예측한 결혼율 값을 뺀다.

```r
mu_M_resid <- model_M_from_A %>% 
    link() %>% 
    apply(2, mean) %>% 
    { waffle_divorce2$s_marriage - . }
```

이제 이 값을 이혼율 변수와 비교해보자. x축에 잔차, y축에 이혼율 변수로 그래프를 그린다. 
이 그래프(좌측 그래프)는 결혼 연령 변수를 통제(controlled)했을 때, 이혼율과 결혼율 변수의 선형 관계를 보여준다. 

```r
# 아래에서 왼쪽 그래프를 그리기 위한 코드
waffle_divorce2 %>% 
    mutate(mu_M_resid = mu_M_resid) %>% 
    ggplot(aes(x = mu_M_resid, y = s_divorce)) +
    geom_point(size = 4, color = '#1D4E89', alpha = 0.5) +
    geom_smooth(method = 'lm', color = '#1D4E89') +
    labs(x = 'Marriage rate residuals', y = 'Divorce rate (std)') +
    theme_minimal(base_size = 20)
```

![](fig/ch5_predictor_residual_plot_01.png)

선형 회귀 모형은 변수들이 서로 연관되어 있는 것을 각 변수를 서로 더하는 형태로 표현한다. 
하지만 예측 변수들은 더하기가 아닌 형태로 영향을 미치기도 한다. 이 경우에는 큰 틀에서는 동일하지만 세부적인 내용은 조금 달라질 수 있다. 
이런 경우에는 모형을 파악하기 위해 다른 방법을 사용할 수 있다. 바로 다음에 나오는 내용을 사용한다.
