# 6. The Haunted DAG & The Causal Terror

가장 뉴스거리가 되는 과학 연구들은 가장 믿을 것이 못되는 것처럼 보인다. 나에게 가장 해가 되는 것처럼 보일수록, 사실은 그렇지 않은 경우가 있다. 
지루한 주제일수록 결과는 더 가치있다. 이런 음의 상관관계가 어떻게 존재할 수 있는 것일까? 
실제로 이런 음의 상관관계가 발생하기 위해서는 논문을 리뷰하는 사람이 뉴스로서의 가치와 신뢰성에 관심을 가지기만 하면 된다. 
그렇게 되면 선택하는 행위 그 자체만으로도 뉴스로서 가치가 높을수록 신뢰성이 낮아 보이게 만들 수 있다.

이런 현상을 **Berkson's Paradox** 라고 한다. 하지만 쉽게 이해하려면 **선택 편향** 효과라고 생각하면 된다. 
이게 다중 회귀 모형과 어떤 관계가 있을까? 안타깝게도, 모든 것이 연관되어 있다. 
이전 장의 내용만 놓고 보면 잘 모르겠을 때는 모든 변수를 모형에 넣으면 알아서 잘 처리해 줄 것처럼 보인다. 하지만 그렇지 못하는 경우도 있다. 
회귀 모형은 예언자처럼 수수께기 같은 이야기를 하고, 우리가 잘못된 질문을 던지면 그 대가를 치루게 한다. 선택 편향 문제는 다중 회귀 모형 안에서도 일어날 수 있다. 
예측 변수를 추가하는 행동으로 인해 통계적인 선택이 이루어지고, 그 결과 이름만으로는 무슨 의미인지 알기 어려운 **충돌 편향(Collider Bias)** 이 발생한다. 
이것이 특정한 변수에 조건을 부여했을 때, 뉴스로서의 가치와 신뢰성 사이의 음의 상관관계가 있는 것처럼 느껴지게 하는 잘못된 해석을 하게 만든다.

이번 장에서는 세 가지 큰 위험에 대해 다룬다. 

- Multicollinearity
- Post-treatment bias
- Collider bias

그리고 유효한 통계적 추론을 위해 어떤 변수를 넣거나 빼야하는지 알아보는 방법에 대해서 다룬다.

# 6.1 Multicollinearity

다중 공선성(Multicollinearity) 은 두 개 이상의 예측 변수가 서로 강한 상관관계를 가지는 경우를 말한다. 
그 결과 모든 변수가 결과 변수와 연관있더라도 어떤 변수도 결과 변수와 연관이 없다는 결론을 내리게 된다. 
이런 현상은 다중 회귀모형이 동작하는 방식 때문에 발생한다. 간단한 시뮬레이션을 통해 살펴보자.

## 6.1.1 Multicollinear legs

사람의 다리 길이를 통해 키를 예측하는 시뮬레이션을 해보자. 키는 다리 길이와 관련이 있다. 
그렇지 않더라도 적어도 이번 시뮬레이션에서는 그렇게 가정하고 있다. 하지만 두 다리 길이를 모두 모형에 넣으면, 무엇인가 이상한 일이 일어난다. 

100명의 데이터를 시뮬레이션으로 생성해보자. 평균적으로 다리 길이는 키의 45% 정도가 되도록 설정해두었기 때문에, beta 계수는 2.2 정도가 될 것이라고 예상해 볼 수 있다. 
(평균 키 / 평균 다리 길이 = 10 / 4.5 = 2.2)

```r
library(rethinking)
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

이런 데이터에 매우 모호하고 잘못된 prior를 적용할 경우 어떻게 되는지 살펴보자. 그래프를 그려보면 posterior 평균과 표준 편차가 정말 이상하는 것을 볼 수 있다. 

```r
m_leg_01 <- quap(
    alist(
        height ~ dnorm(mu, sigma),
        mu <- a + bl*leg_left + br*leg_right,
        a ~ dnorm(10, 100),
        bl ~ dnorm(2, 10),
        br ~ dnorm(2, 10),
        sigma ~ dexp(1)
    ),
    data = height_data
)

precis(m_leg_01)
#       mean   sd  5.5% 94.5%
# a     0.96 0.31  0.47  1.45
# bl    0.95 2.21 -2.58  4.47
# br    1.06 2.20 -2.46  4.58
# sigma 0.61 0.04  0.54  0.68

plot(precis(m_leg_01))
```

![](fig/ch6_multicolinearity_precis_01.png)

Posteior 학습은 잘 되었다. 그리고 posterior 분포는 우리의 질문에 적합한 대답을 해주었다. 문제는 바로 그 질문이다. 질문은 다음과 같다.

> 다른 쪽 다리의 길이를 이미 알고 있을 때, 한 쪽 다리 길이를 추가로 알게되는 것은 얼마나 가치있을까?

이 이상한 질문에 대한 답변은 여전히 이상하지만, 매우 논리적이다. 우선 bl 과 br 의 Posterior 분포를 그래프로 그려서 살펴보자.

```r
# Posterior 분포로부터 샘플링한다
m_leg_01_posterior <- m_leg_01 %>% 
    extract.samples() %>% 
    as_tibble()

p1 <- m_leg_01_posterior %>% 
    ggplot(aes(x = br, y = bl)) +
    geom_point(size = 3, color = '#1D4E89', shape = 21, alpha = 0.1) +
    labs(title = 'Posterior Distribution of the association of each leg with height') +
    theme_minimal(base_size = 10)

p2 <- m_leg_01_posterior %>% 
    mutate(sum_bl_br = bl + br) %>% 
    ggplot(aes(x = sum_bl_br)) +
    geom_density(color = '#1D4E89') +
    labs(x = 'sum of bl and br',
        title = 'Posterior Distribution of "bl + br"') +
    theme_minimal(base_size = 10)

gridExtra::grid.arrange(p1, p2, ncol = 2)
```

![](fig/ch6_legs_posterior_01.png)

두 파라미터의 posterior 분포는 매우 상관관계가 크다. bl 이 커지면 br 이 작아진다. 
두 변수가 거의 같은 값을 가지기 때문에, 동일한 예측을 하는 bl, br 조합을 거의 무한하게 생성해 낼 수 있다.

이 현상을 설명하기 위해 모형을 다음과 같이 근사시켰다고 생각해보자. 동일한 `x_i` 값이 두 번 사용되었기 때문에 현재 우리가 처한 상황과 매우 유사하다.

```
y_i ~ Normal(mu_i, sigma)
mu_i <- alpha + beta1*x_i + beta2*x_i
     <- alpha + (beta1 + beta2)*x_i
```

위 수식에서 beta1, beta2 파라미터는 분리될 수 없다. 둘 다 독립적으로 `mu` 에 영향을 주는 것이 아니기 때문이다. 
beta1과 beta2의 합이 mu 에 영향을 줄 뿐이다. 
따라서 posterior 분포는 beta1과 beta2의 합이 실제 x, y의 연관성과 비슷해질 때 가능한 모든 beta1, beta2의 조합을 보여준다.

만약 변수를 하나만 사용한다면 실제와 거의 동일한 posterior mean을 구하게 된다.

```r
m_leg_02 <- quap(
    alist(
        height ~ dnorm(mu, sigma),
        mu <- a + bl*leg_left,
        a ~ dnorm(10, 100),
        bl ~ dnorm(2, 10),
        sigma ~ dexp(1)
    ),
    data = height_data
)

# bl 파라미터의 mean은 2.01로 mean(bl)+mean(br) 값과 거의 동일하다
precis(m_leg_02)
#       mean   sd 5.5% 94.5%
# a     0.93 0.31 0.44  1.42
# bl    2.01 0.07 1.91  2.12
# sigma 0.61 0.04 0.54  0.68
```

이번 예제는 상당히 명확하지만 심각한 인과적인 문제를 다루고 있지는 않다. 다음은 더 흥미로운 예제를 살펴보자.

## 6.1.2 Multicollinear milk

다리 길이 문제에서는 두 변수를 동시에 사용하는 것이 이상하다는 것을 쉽게 알 수 있었다. 
하지만 실제 데이터에서는 상관관계가 높은 두 변수가 충돌할 것이라 예상하지 못한다는 것이 문제다. 
결국 우리는 posterior 분포를 잘못 해석하게 되어 두 변수가 모두 중요하지 않다는 결론을 내리게 될 것이다.

다시 이전 장의 `milk` 데이터로 돌아가보자.

```r
data('milk', package = 'rethinking')
# kcal.per.g   : total energy content
# perc.fat     : percent fat
# perc.lactose : percent lactose
# * perc.fat 과 perc.lactose 두 변수는 높은 음의 상관관계를 보인다

milk_data <- milk %>% 
    as_tibble() %>% 
    mutate(K = scale(kcal.per.g)[,1],
           F = scale(perc.fat)[,1],
           L = scale(perc.lactose)[,1])
```

`kcal.per.g` 변수가 `perc.fat` 과 `perc.lactose` 에 대한 함수인 것처럼 모형을 구성해보자. 우선은 각각의 단일 회귀모형을 구한다.

```r
# kcal.per.g ~ perc.fat
m_milk_kf <- quap(
    alist(
        K ~ dnorm(mu, sigma),
        mu <- a + bF*F,
        a ~ dnorm(0, 0.2),
        bF ~ dnorm(0, 0.5),
        sigma ~ dexp(1)
    ),
    data = milk_data
)

# kcal.per.g ~ perc.lactose
m_milk_kl <- quap(
    alist(
        K ~ dnorm(mu, sigma),
        mu <- a + bL*L ,
        a ~ dnorm(0, 0.2),
        bL ~ dnorm(0, 0.5),
        sigma ~ dexp(1)
    ),
    data = milk_data
)

precis(m_milk_kf)
#       mean   sd  5.5% 94.5%
# a     0.00 0.08 -0.12  0.12
# bF    0.86 0.08  0.73  1.00
# sigma 0.45 0.06  0.36  0.55

precis(m_milk_kl)
#        mean   sd  5.5% 94.5%
# a      0.00 0.07 -0.11  0.11
# bL    -0.90 0.07 -1.02 -0.79
# sigma  0.38 0.05  0.30  0.46
```

`perc.fat` 이 높아지면 `kcal.per.g` 도 높아진다. `perc.lactose` 가 높아지면 `kcal.per.g` 가 낮아진다는 모델링 결과를 볼 수 있다. 
그런데 두 변수를 모두 모형에 넣으면 어떻게 될까?

```r
# kcal.per.g ~ perc.fat + perc.lactose
m_milk_kfl <- quap(
    alist(
        K ~ dnorm(mu, sigma),
        mu <- a + bF*F + bL*L,
        a ~ dnorm(0, 0.2),
        bF ~ dnorm(0, 0.5),
        bL ~ dnorm(0, 0.5),
        sigma ~ dexp(1)
    ),
    data = milk_data
)

precis(m_milk_kfl)
#        mean   sd  5.5% 94.5%
# a      0.00 0.07 -0.11  0.11
# bF     0.24 0.18 -0.05  0.54
# bL    -0.68 0.18 -0.97 -0.38
# sigma  0.38 0.05  0.30  0.46
```

이제 `bF` 와 `bL` 모두 posterior mean 값이 이전보다는 0에 가까워진 것을 볼 수 있다. 
그리고 표준 편차가 거의 두 배 가량 늘었다. 이 현상은 다리 길이 예제와 동일한 통계적 현상을 나타낸다. 

다중공선성을 다루기 위한 여러 가지 방법들이 언급되는데, 인과적인 측면에서 다루는 내용은 드물다. 
각 변수 쌍의 상관계수를 보는 것은 적절하지 않다. 문제가 되는 쪽은 상관계수가 아니라 조건부 관계다. 

모유 수유를 자주 하는 종의 모유는 묽고 에너지가 적다. 이런 경우는 당(lactose)이 많아진다. 
모유 수유를 자주 하지 않는 종의 경우 에너지가 더 풍부해야 한다. 그런 경우는 지방(fat)이 풍부해진다. 
이런 현상은 다음과 같은 인과 모형으로 이어진다.

```
L <- (D) -> F
L -> K
F -> K
```

가장 중심이 되는 트레이드오프는 모유가 얼마나 진한지 (dense) 여부를 나타내는 변수가 결정한다. 
우리는 이 변수를 관찰하지 않았기 때문에 원으로 표현한다. 만약 D 변수를 관찰했다면 바로 K 변수에 대한 회귀모형을 구성해서 인과적인 효과를 추정할 수 있었을 것이다. 

다중공선성은 모델링 문제 중에서 **비식별성(Non-Identifiability)** 문제에 속한다. 
어떤 파라미터가 식별 불가능하다면 데이터와 모형이 해당 파라미터의 값을 추정할 수 없다는 것이다. 
일반적으로는 현재 데이터가 관심있는 파라미터에 대한 정보를 충분히 담고 있다는 보장이 없다. 
정보를 충분히 담고 있지 않다면, prior와 매우 비슷한 posterior 를 반환할 것이다. 
따라서 모형이 데이터로부터 정보를 얼마나 끌어내느냐를 본다는 점에서, prior와 posterior를 비교하는 작업은 좋은 방법이다.
