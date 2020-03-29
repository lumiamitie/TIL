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

# 6.2 Post-treatment bias

중요한 예측 변수를 빠뜨려서 잘못된 추론을 하게 될까봐 걱정하는 일은 항상 발생한다. 
변수를 빠뜨려서 발생하는 편향( **Omitted variable bias** ) 은 이전 장의 예제에서 많이 다루었다. 
이것보다 조금 덜 발생하는 문제 중 하나는, 어떤 변수의 결과로 이루어진 변수를 포함하는 것이다. 
이것을 **Post-Treatment Bias** 라고 한다. 

"post-treatment" 라는 말은 실험 설계에서 나온 용어다. 온실에서 식물을 기르기로 했다고 생각해보자. 
식물에 자라는 토양에 곰팡이가 생기면 성장에 방해가 되기 때문에, 곰팡이 방지 토양이 얼마나 효과가 있는지 알아보기로 했다. 
최종적으로 식물이 발아한 뒤 높이와 곰팡이 발생 여부를 측정한다. 우리의 최종 관심사는 식물의 높이다. 
그런데 만약 인과 관계를 파악하고 싶은 거라면 곰팡이 존재 여부를 모형에 포함해서는 안된다. 왜냐면 그건 post-treatment 효과이기 때문이다.

시뮬레이션을 통해 구체적으로 어떻게 문제가 되는지 살펴보자.

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

# 100개의 식물 데이터를 생성한다
sim_plant <- simulate_plants(100)
precis(sim_plant)
# 'data.frame': 100 obs. of 4 variables:
#            mean   sd  5.5% 94.5%  histogram
# h0        10.18 1.83  7.51 13.09 ▁▁▃▃▇▇▃▂▂▁
# h1        14.33 2.27 10.61 17.55 ▁▃▃▃▅▅▇▇▃▁
# treatment  0.50 0.50  0.00  1.00 ▇▁▁▁▁▁▁▁▁▇
# fungus     0.29 0.46  0.00  1.00 ▇▁▁▁▁▁▁▁▁▃
```

## 6.2.1 A prior is born

실제 분석과정에서는 데이터가 생성되는 프로세스를 모를 가능성이 더 높다. 
하지만 과학적인 정보를 통해 모형을 어떻게 구성해야 좋을지 감을 잡을 수 있다. 

우선 시간 `t=1` 시점의 식물은 `t=0` 보다는 커야 한다. 
따라서 높이의 절대값을 사용하는 대신 `t=0` 대비 상대적인 비율을 파라미터로 두게 되면 prior를 더 쉽게 설정할 수 있다. 
우선 단순하게 하기 위해 예측 변수 없이 키 변수에만 집중해보자. 다음과 같은 모형이 된다.

```
h_{1,i} ~ Normal(mu_i, sigma)
mu_i = h_{0,i} * p

* h_{0,i} : 식물 i의 t=0 시점의 높이
* h_{1,i} : 식물 i의 t=1 시점의 높이
* p       : h_{0,i} 대비 h_{1,i} 의 비율
```

따라서 prior를 결정할 때 p의 평균을 1로 두면 식물들의 키가 더 자라지 않을 것이라 생각한다는 것을 의미한다. 
실험이 잘못되어 식물이 죽어버릴 수 있기 때문에 p가 1보다 작아질 수도 있다. 하지만 비율이기 때문에 0보다는 커야한다. 
항상 양수인 이 값을 위해 **Log-Normal** 분포를 prior로 사용해보자.

```r
m_plant_h <- quap(
    alist(
        h1 ~ dnorm(mu, sigma),
        mu <- h0 * p,
        p ~ dlnorm(0, 0.25),
        sigma ~ dexp(1)
    ),
    data = sim_plant
)

# 평균 40% 정도 성장한다는 것을 알 수 있다
precis(m_plant_h)
#       mean   sd 5.5% 94.5%
# p     1.39 0.02 1.36  1.42
# sigma 1.86 0.13 1.65  2.06
```

이제 treatment와 곰팡이 변수를 추가해보자. 

```r
m_plant_htf <- quap(
    alist(
        h1 ~ dnorm(mu, sigma),
        mu <- h0 * p,
        p <- a + bt*treatment + bf*fungus,
        a ~ dlnorm(0, 0.2),
        bt ~ dnorm(0, 0.5),
        bf ~ dnorm(0, 0.5),
        sigma ~ dexp(1)
    ),
    data = sim_plant
)

precis(m_plant_htf)
#        mean   sd  5.5% 94.5%
# a      1.49 0.02  1.45  1.53
# bt    -0.02 0.03 -0.06  0.02
# bf    -0.30 0.03 -0.35 -0.25
# sigma  1.24 0.09  1.10  1.38
```

결과를 보면 treatment의 효과는 0에 가깝고, 곰팡이로 인한 효과는 식물의 성장에 악영향을 미치는 것으로 보인다. 
그런데 여기서 treatment가 식물의 성장에 영향을 준다는 것을 **알고 있다면** 어떻게 될까? 실제로 우리는 그렇게 시뮬레이션을 했다.

## 6.2.2 Blocked by consequence

문제는 곰팡이가 대부분 treatment의 결과로 나타난다는 것이다. 따라서 이 경우에는 `fungus` 변수가 post-treatment 변수라고 할 수 있다. 
만약 `fungus` 변수를 통제하려고 하면 모형은 다음과 같은 질문을 하는 것이 된다. 
*식물에 곰팡이가 피었다는 것을 알고 있을 때 토양의 곰팡이 방지 처리 여부가 영향을 미치는가?* 답은 "아니오" 다. 
왜냐면 토양의 처리 결과는 곰팡이를 방지하는 형태로 식물의 성장에 영향을 미치기 때문이다. 
하지만 우리가 실험을 통해 알고자 하는 것은 토양이 식물의 성장에 미치는 영향이다. 
이것을 제대로 추정하기 위해서는 `fungus` 같은 post-treatment 변수를 모형에서 제거해야 한다.

```r
m_plant_ht <- quap(
    alist(
        h1 ~ dnorm(mu, sigma),
        mu <- h0 * p,
        p <- a + bt*treatment,
        a ~ dlnorm(0, 0.2),
        bt ~ dnorm(0, 0.5),
        sigma ~ dexp(1)
    ),
    data = sim_plant
)

precis(m_plant_ht)
#       mean   sd 5.5% 94.5%
# a     1.33 0.02 1.29  1.37
# bt    0.11 0.03 0.06  0.17
# sigma 1.77 0.12 1.57  1.96
```

이제 토양에 곰팡이 방지 처리를 하는 것이 식물의 성장에 효과적인 것으로 제대로 나타난다. 
식물의 초기 높이인 h0 처럼 인과적 영향을 추정하는데 영향을 미칠 수 있는 요소들은 통제하는 것이 합리적이다. 
그런데 post-treatment 변수를 포함해버리면 treatment의 효과 자체를 가려버릴 수 있다. 

## 6.2.3 Fungus and d-separation

DAG의 형태로 문제를 살펴보는 것이 도움이 된다.

```
H0 -> H1 <- F <- T

* H0 : plant height at time 0
* H1 : plant height at time 1
```

현재 모형이 F 변수를 포함할 경우, treatment가 결과 변수에 영향을 미치는 경로를 막아버린다. 
이것은 곰팡이가 피었는지 여부를 알고 있는 한은 treatment의 정보를 아는 것이 결과 변수에 영향을 미치지 못한다는 것을 의미한다.

DAG를 중심으로 이야기하면, F 변수에 조건을 부여하는 경우 **d-separation** 이 발생한다. 
d-separation 은 DAG 상의 어떤 변수들이 다른 변수들에 대해 독립이라는 것을 말한다. 서로를 이어주는 경로가 없는 것이다. 
여기서는 **F를 알고 있을 때 H1이 T로부터 d-separated** 되어 있다. 왜 이런일이 발생할까? 
우리가 F 변수에 대해 알고 있다면 T를 안다고 해서 H1에 대한 정보를 더 얻을 수 없기 때문이다. 
다음과 같은 코드를 통해 DAG에 어떤 조건부 독립 관계가 있는지 알아볼 수 있다.

```r
library(dagitty)

dag_plant <- dagitty('
dag {
    H_0 -> H_1
    F -> H_1
    T -> F
}')

impliedConditionalIndependencies(dag_plant)
# F _||_ H_0
# H_0 _||_ T
# H_1 _||_ T | F
```

총 세 가지가 있는데, 이 중 우리가 관심을 가지고 있는 것은 세 번째 항목이다. 
하지만 다른 2개의 항목들도 DAG를 테스트 해 볼 방법을 제시해준다. 
원래의 식물 높이인 `H0` 는, 우리가 아무런 조건을 부여하지 않는다면 T 또는 F 변수와는 연관이 있어서는 안된다는 것이다. 

Post-treatment 변수는 실험과 관찰 연구 모두에서 문제가 되지만, 실험에서는 어떠한 변수가 treatment 로 인해 발생하는지 관찰 연구에 비해 파악하기가 더 쉬운 편이다. 
하지만 실험에서도 조심해야 하는 함정이 있다. 
예를 들면, post-treatment 변수에 조건을 거는 행위는 treatment의 효과가 없는 것처럼 느껴지는 것 뿐만 아니라 없던 효과도 있는 것처럼 보이게 만드는 경우가 있다. 
다음 DAG를 살펴보자.

```
H0 -> H1           F <- T
        H1 <- (M) -> F
```

위 그래프에서 T는 F에 영향을 미치지만, F가 H1에 영향을 주지 못한다. 
그런데 새로운 변수 M (Moisture) 을 추가하면 어떻게 될까? H1에 대한 T의 회귀 모형에서는 treatment가 식물의 성장에 영향을 준다는 관계를 찾을 수 없다. 
하지만 F를 모형에 추가하면 갑자기 연관성이 생겨난다. 왜 그런 현상이 발생할까? 다음 섹션에서 그러한 현상에 대해 살펴보자.

# 6.3 Collider bias

이번에는 **Collider bias** 라는 현상에 대해서 살펴보자. 다음과 같은 DAG를 생각해보자. T와 N은 통계적으로 독립이며, 둘 모두 S에 영향을 준다.

```
T -> S <- N

* T : Trustworthiness
* N : Newsworthiness
* S : Selection
```

두 화살표가 동시에 S로 향하는 것은 S가 **Collider** 라는 것을 의미한다. 
쉽게 설명하자면, **collider에 조건을 부여할 경우 그 원인에 해당하는 변수들 사이에 상관관계(인과관계가 아닐 수 있는)를** 만들어 낸다. 
왜 이런 현상이 발생할까? 예를 들면, 신뢰성이 떨어지는 연구가 뉴스거리로 선택되려면 그만큼 뉴스거리로서는 높은 가치가 있어야 한다. 
그렇지 않았다면 아예 선택조차 받지 못했을 것이다. 그 반대도 마찬가지다. 

관측치의 샘플을 선택하는 과정을 주의깊게 진행하지 않을 경우, 변수들 사이의 관계가 왜곡될 가능성이 있다. 
collider 를 예측변수로서 모형에 포함시킬 경우 그러한 문제가 발생할 수 있다. 
주의깊게 다루지 않으면 인과 관계를 해석하는데 오류를 범할 수 있다. 예제를 더 살펴보자.

## 6.3.1 Collider of false sorrow

나이를 먹는 것이 행복에 어떻게 영향을 미치는지 생각해보자. 이런 가정은 논란이 있겠지만 다음과 같이 가정해보자.

- 각 개인의 행복은 태어났을 때 결정되고 나이를 더 먹는다고 해서 변하지 않는다
- 행복은 한 사람의 결혼 여부에 큰 영향을 미친다
- 나이 또한 결혼 여부에 영향을 미친다

그러면 다음과 같은 DAG를 얻을 수 있다. 여기서 행복과 나이가 모두 결혼의 공통 원인이기 때문에, 결혼(M) 은 Collider 라고 볼 수 있다. 
만약 우리가 **M 변수에 조건을 건다면 (회귀 모형의 예측 변수로 포함하는 것을 의미한다)** 행복과 나이 사이에 통계적인 상관관계를 만들어 낼 수 있다. 
이로 인해 행복을 고정된 상수로 설정했는데도 불구하고 나이와 연관이 있는 것처럼 보일 수 있다.

```
H -> M <- A

* H : Happiness
* A : Age
* M : Marriage
```

인과 모형을 가지고 있지 않다면 다중 회귀모형으로부터 추론을 이끌어낼 수 없다. 
그리고 회귀 모형 그 자체만으로는 주어진 인과 모형을 증명할만한 증거를 제시할 수 없다. 

## 6.3.2 The Haunted DAG

Collider Bias는 앞에서 살펴봤던 대로 공통의 결과 변수에 조건을 걸 때 발생한다. 
그래프를 잘 그려서 피해갈 수 있지만, 측정되지 않은 변수들 때문에 항상 쉽게 피해갈 수 있는 것은 아니다. 
다음과 같은 DAG에서 G, P 변수가 C 변수에 직접 미치는 영향을 측정하는 상황을 생각해보자. 

```
G -> P -> C
G -> C

* P : Parents
* G : Grandparents
* C : Children
```

그런데 다음과 같이 P와 C에 모두 영향을 미치면서 관측되지 않은 변수 U가 있다고 해보자.

```
P <- (U) -> C
G -> P -> C
G -> C
```

이 경우에는 P가 G와 U의 공통 결과가 되기 때문에, U 변수를 관측하지 않더라도 P에 조건을 걸면 G → C 에 대한 추론에서 편향이 발생한다.

200건의 데이터를 시뮬레이션하여 살펴보자. 

```r
simulate_triad <- function(seed = 123) {
    set.seed(seed)
    
    N <- 200  # Triad 수
    b_GP <- 1 # G -> P 의 직접적인 효과
    b_GC <- 0 # G -> C 의 직접적인 효과
    b_PC <- 1 # P -> C 의 직접적인 효과
    b_U <- 2  # U -> P, U -> C 의 직접적인 효과
    
    tibble(
        G = rnorm(N),
        U = 2*rbern(N, 0.5) - 1,
        P = rnorm(N, b_GP*G + b_U*U),
        C = rnorm(N, b_PC*P + b_GC*G + b_U*U)
    )
}

# 시뮬레이션 결과를 생성한다
sim_triad <- simulate_triad()
```

이제 조부모(G)의 영향을 추정하려면 어떻게 해야 할까? 조부모(G)의 영향 중 일부는 부모(P)를 통해 전달된다. 
따라서 부모의 효과를 통제해야 한다. 회귀 모형을 구성하기 전에, 원래는 변수를 표준화하는 것을 권장하지만 
추론 과정에서 기울기에 대한 추론이 어떻게 변하는지 살펴보기 위해 원래의 스케일을 유지하기로 한다. 또한 예시를 위해 정보가 약한 prior를 사용한다.

```r
m_triad_pgc <- quap(
    alist(
        C ~ dnorm(mu, sigma),
        mu <- a + b_PC*P + b_GC*G,
        a ~ dnorm(0, 1),
        c(b_PC, b_GC) ~ dnorm(0, 1),
        sigma ~ dexp(1)
    ),
    data = sim_triad
)

precis(m_triad_pgc)
#        mean   sd  5.5% 94.5%
# a     -0.12 0.10 -0.27  0.04
# b_PC   1.82 0.04  1.75  1.89
# b_GC  -0.72 0.11 -0.89 -0.54
# sigma  1.38 0.07  1.27  1.49
```

추정된 P의 효과는 실제보다 2배 가량 커보인다. 이런 결과는 이상하지 않다. P와 C의 상관관계 중 일부는 U로 인해 발생했는데 모형은 U에 대해 전혀 알지 못한다. 
이것은 **교란변수** 에 대한 간단한 예제다. 게다가 이 모형은 G가 C에 대해 부정적인 영향을 미친다고 계산했다. 
회귀 모형은 틀리지 않았지만, 이 관계를 인과적으로 해석한다면 잘못된 해석이 된다. 

여기서 Collider bias 는 어떻게 등장하는지 살펴보자. P 변수에서 백분위 기준 45% ~ 60% 사이에 존재하는 항목만 진하게 표시하면 아래와 같은 결과가 나온다. 
해당 데이터에 대해서만 회귀 모형을 구하면 음의 상관관계가 나타난다. 그런데 왜 이런 현상이 나타나게 되는 걸까?

```r
local({
sim_triad_condition <- sim_triad %>% 
    mutate(p_conditioned = between(P, quantile(P, 0.45), quantile(P, 0.60)),
        U = factor(U))

ggplot(sim_triad_condition, aes(x = G, y = C)) +
    geom_point(aes(color = U, alpha = p_conditioned), size = 2.5) +
    geom_smooth(data = sim_triad_condition %>% filter(p_conditioned), 
                method = 'lm', se = FALSE, fullrange = TRUE, color = '#1D4E89') +
    scale_color_brewer(palette = 'Set1') +
    scale_alpha_manual(values = c(0.2, 1)) +
    labs(alpha = 'Parents in 45th~60th quantile',
        title = 'Unobserved confounds and collider bias') +
    theme_minimal(base_size = 12)
})
```

![](fig/ch6_collider_bias_01.png)

왜냐하면, **P를 알고 있을 때 G 값을 안다면 자연스럽게 U에 대한 정보를 얻게된다.** 그리고 U는 C와 연관성이 있다. 
다시, 다음 예제를 통해 확인해보자. 교육 수준이 같은 (중앙값에 가깝다고 해두자) 두 부모가 있다고 가정해보자. 
한 쪽은 교육 수준이 높은 조부모가 있고 다른 한쪽은 조부모의 교육 수준이 낮다. 
이 예제에서 두 부모의 교육 수준이 같으려면 살고 있는 동네에 차이가 있어야 한다. 우리는 사는 곳의 효과를 알 수 없다. 측정하지 않았기 때문이다. 
하지만 측정하지 않았는데도 결과 변수 C에는 여전히 영향을 미치고 있다. 따라서 조부모의 교육 수준이 낮은 경우 (사는 곳 때문에) 자녀의 교육 수준이 높은 것으로 보인다. 

**측정되지 않은 U 변수가 P를 Collider 로 만들고, 이 P 변수에 조건을 부여하면 Collider bias가 만들어진다.** 
그렇다면 우리는 어떻게 해야 할까? U 변수를 측정해야 한다. U 변수를 포함하여 회귀 모형을 구성해보자. 
이번에는 시뮬레이션 때 넣었던 파라미터와 근사한 값이 나오는 것을 볼 수 있다.

```r
m_triad_pgcu <- quap(
    alist(
        C ~ dnorm(mu, sigma),
        mu <- a + b_PC*P + b_GC*G + b_U*U,
        a ~ dnorm(0, 1),
        c(b_PC, b_GC, b_U) ~ dnorm(0, 1),
        sigma ~ dexp(1)
    ),
    data = sim_triad
)

precis(m_triad_pgcu)
#        mean   sd  5.5% 94.5%
# a     -0.09 0.07 -0.20  0.02
# b_PC   0.97 0.07  0.86  1.08
# b_GC   0.05 0.09 -0.10  0.20
# b_U    2.10 0.15  1.86  2.34
# sigma  0.98 0.05  0.90  1.05
```

이번에 살펴본 예제는 **Simpson's Paradox** 가 발생한 사례이다. 
어떤 예측 변수(여기서는 P)를 추가했더니 다른 예측 변수(G)와 결과 변수(C)의 상관 관계가 역전되는 상황이 발생했다.

# 6.4 Confronting confounding

실험을 통해 변수 X의 값을 결정했을 때, 예측 변수 X와 결과 변수 Y 사이의 관계가 실제와 달라지는 경우를 통틀어서 교란되었다(Confounding)고 말한다. 

교육(E)과 임금(W) 사이의 관계를 DAG를 통해 살펴보자. 보통 이런 경우에는 두 변수에 모두 영향을 미치는 항목들이 존재한다. 사는 곳, 부모님 또는 친구들의 특성들은 교육과 임금에 모두 영향을 미칠 수 있다. DAG를 그려보면 아래와 같이 구성된다.

```
E -> W
E <- U -> W
```

E를 통해 W를 설명하는 회귀 모형을 구성해보면, 추정한 인과 효과가 U 변수로 인해 교란된다. 교란이 발생하는 이유는 E와 W를 잇는 경로가 2가지 존재하기 때문이다. 
여기서 "경로" 라는 것은 화살표의 방향과 무관하게 그래프 상에서 서로 왔다갔다 할 수 있는 변수들의 순열을 의미한다. 
2가지 경로 모두 통계적인 상관 관계를 만들어내지만, 인과 관계를 의미하는 것은 하나( `E→W` )뿐이다. 다른 경로가 인과 관계가 아닌 이유는 무엇일까? 
E 값을 바꾸어도 해당 경로로는 W에 영향을 미치지 않기 때문이다. 

그렇다면 인과적인 경로만 남기고 싶다면 어떻게 해야 할까? 가장 많이 사용되는 해결 방법은 바로 실험을 하는 것이다. 
만약 교육 수준을 임의로 할당한다면, DAG가 다음과 같이 변한다. 
이렇게 두 번째 경로를 막아버리게 되면 실험을 통해 측정한 E와 W의 연관성을 인과적인 영향으로 해석할 수 있게 된다. 

```
U -> W
E -> W
```

다행스럽게도 E 변수에 직접 개입하지 않으면서 동일한 효과를 얻는 방법이 있다. 바로 U 변수를 추가하여 조건을 부여하는 것이다. 
이것 또한 E에서 U를 통해 W로 이어지는 영향을 막는 효과가 있다. 이렇게 해도 두 번째 경로가 막힌다.
