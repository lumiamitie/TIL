# 4. Geocentric Models

클라우디오스 프톨레미오스는 이집트의 수학자이자 천문학자로, 지동설을 주장한 것으로 유명하다. 
원 안의 원인 주전원 (epicycle) 이라는 개념을 통해 높은 정확도로 천체의 궤도를 설명할 수 있었다. 
현재 우리는 실제 태양계의 형태를 알고 있기 때문에 행성들이 지구를 중심으로 돈다는 주장이 말도 안된다고 생각할 수 있다. 
하지만 고대의 사람들은 일반화된 근사 추정 시스템을 통해 그러한 결론을 도출했다. 
여러 개의 원형 궤도가 포함될 수 있는 공간이 충분하다면, 프톨레미오스의 접근 방식은 푸리에 급수와 비슷해진다. 
주기 함수를 삼각함수의 급수로 분해할 수 있게 되는 것이다. 
따라서 실제로 행성이 어떤 궤도를 돌고 있든, 지동설은 밤하늘에서 별들이 어떻게 움직이는지 설명할 수 있다. 

**선형 회귀 (Linear Regression)** 는 통계학에서 지동설 모형과 비슷한 위치에 있다. 
지동설과 마찬가지로 다양한 문제를 해결할 수 있으며, 그 구조를 제대로 파악하지 못한다면 실수를 저지르기 쉽다. 
물론 잘 사용하면 매우 유용할 것이다. 이번 장에서는 베이지안의 방식으로 선형 회귀 모형을 이해해보자.
확률적으로 해석하면, 선형 회귀는 관심사의 불확실성을 정규분포를 통해 표현한다. 이런 유형의 모형은 모든 상황에 유용하지는 않다. 
하지만 익숙해지고 나면 정규분포를 이용하지 않는 모형으로 쉽게 나아갈 수 있다.

# 4.1 Why normal distributions are normal

수많은 사람들이 운동장에 한가운데 서서 동전을 던진다. 앞면이 나오면 왼쪽으로, 뒷면이 나오면 오른쪽으로 한 걸음 움직인다. 
모든 사람들이 16번씩 동전을 던졌을 때 중앙선 부근에 서 있는 사람들의 비율을 계산할 수 있을까? 
각각의 사람들이 어떤 결과를 얻게 될지는 알 수 없지만, 전체적인 비율에 대해서는 꽤 자신감 있게 이야기 할 수 있다.

## 4.1.1 Normal by addition

위 사례를 시뮬레이션을 통해 확인해보자. 각각의 사람들이 -1, 1 사이의 임의의 숫자를 뽑는다. 
그리고 이 작업을 1000번 반복한다. 임의의 숫자를 4, 8, 16번 뽑은 결과를 비교해보자.

```r
pos4  <- replicate(1000, sum(runif(4,  -1, 1)))
pos8  <- replicate(1000, sum(runif(8,  -1, 1)))
pos16 <- replicate(1000, sum(runif(16, -1, 1)))
```

![](fig/ch4_normal_by_addition_01.png)

숫자를 뽑는 횟수가 많아질수록 익숙한 종 모양의 형태에 가까워진다. 더 많이 뽑는다면 정규분포에 점차 수렴하게 될 것이다. 왜 그렇게 되는 걸까?

**동일한 분포에서 랜덤하게 추출한 값을 더하는 모든 확률 과정은 정규분포로 수렴한다.** 그런데 왜 하필 종모양이 되는걸까? 
직관적으로 생각해보자. 모든 개별값은 평균으로부터 변동이 생긴 것이라고 볼 수 있다. 이러한 변동들이 더해지면 서로의 효과가 상쇄되기 시작한다. 
커다란 변동은 반대쪽으로의 커다란 변동을 상쇄시킨다. 이런 과정이 반복되면 모든 합계는 평균과 차이가 나지 않게 된다. 
이러한 현상은 어떤 분포에 의해 발생되는지와는 상관이 없다. 방금 예제처럼 Uniform 분포여도 되고, 다른 분포여도 상관없다. 
분포에 따라서는 수렴이 느릴 수 있지만, 결국 수렴하게 되어있다. 그리고 대부분은 빠른 속도로 수렴한다.

## 4.1.2 Normal by multiplication

정규분포를 얻을 수 있는 방법이 한 가지 더 있다. 유기체의 성장률이 12가지 유전자에 따라 다르다고 가정해보자. 
그리고 모든 위치들이 서로 상호작용해서 성장을 비율로 증가시킨다고 가정해보자. 이렇게 되면 효과는 더해지는 것이 아니라 곱해진다. 
다음 코드를 실행해보면 결과가 정규분포에 근사한다는 것을 알 수 있다. 왜 이런 결과가 나오는 것일까?

```r
# [1.0, 1.1] 사이의 임의의 수 12개를 뽑아서 총 성장률을 계산한다
prod(1 + runif(12, 0, 0.1))

# 10000번 수행했을 때의 분포를 확인해보자
growth <- replicate(10000, prod(1 + runif(12, 0, 0.1)))
rethinking::dens(growth, norm.comp = TRUE)
```

10%씩 성장하도록 하는 유전자가 2개 있다고 해보자.

- 1.1 x 1.1 = 1.21
- 1.1 x 1.1 = (1 + 0.1) x (1 + 0.1) = 1 + 0.2 + 0.01

(1.1 + 1.1) 과 (1.1 x 1.1) 은 0.01밖에 차이가 나지 않는다. 각 유전자의 효과가 작을수록 근사시키는 정확도가 더 높아진다. 
이런 방식으로 효과를 곱하는 방식은 더하기로 근사되기 때문에 결국 정규분포에 수렴하게 된다.

## 4.1.3 Normal by log-multiplication

곱하는 값의 비율이 커지면 정규분포로 근사하지 않게 된다. 하지만 이 경우에도 로그 스케일로는 정규분포를 따르게 된다.

```r
log_big <- replicate(10000, log(prod(1 + runif(12, 0, 0.5))))
```    

로그 값을 더하는 것은 원래 값을 곱하는 것과 동일하기 때문에 정규분포를 따르게 된다. 
값의 스케일과는 무관하게, 측정값에 로그를 취하게 되면 정규분포를 따르는 값을 생성할 수 있다.

## 4.1.4 Using Gaussian distributions

모형을 사용할 때 정규분포를 사용해도 될까? 두 가지 측면에서 접근해보자.

### 4.1.4.1 Ontological justification

**세상은 근사적으로는 모두 정규분포로 가득하다.** 측정에서 발생하는 오류, 추세의 변동성, 분자의 속도는 모두 정규분포로 근사한다. 
이렇게 되는 이유는 여러 변동성들을 **더하는** 과정이기 때문이다. 그 결과 정규분포를 기반으로 하는 모형은 세부적인 과정 각각에 대해서는 명확하게 판별할 수 없다. 
하지만 다시 말하면, 세부적인 각각의 과정들은 모르더라도 모형이 유용한 결과를 얻어낼 수 있다는 의미가 된다. 

자연에는 다양한 패턴이 존재하기 때문에, 만물이 정규분포만을 따를 것이라는 오해를 해서는 안된다. 
이후에 소개할 지수분포, 감마분포, 포아송분포도 자연적으로 등장하는 분포다. 
정규분포는 **Exponential Family** 라고 불리는, 자연적으로 등장하는 근본적인 분포들의 그룹에 속한다. 
이러한 분포들은 실제 세상을 구성하고 있기 때문에 과학적으로 매우 중요하다.

### 4.1.4.2 Epistemological justification

**정규분포는 우리가 얼마나 모르는지 표현한다.** 이것이 우리가 모델링을 위해 정규분포를 사용하는 또 한 가지 이유이자, 
종종 정규분포를 사용하는 것이 오히려 나쁜 결과를 내는 원인이 된다. 정규분포는 우리의 무지를 표현하는 가장 자연스러운 방식이다. 
분산이 유한하다면 정규분포는 추가적인 가정없이 가장 많은 형태의 분포를 설명할 수 있다. 이러한 관점에서는 정규분포가 가장 적합한 분포다. 
만약 정규분포가 적합하지 않다는 생각이 든다면, 다른 종류의 분포가 필요하다.

일단 지금은 정규분포를 사용해서 모델링을 진행해보자. 특정한 모형을 사용하는 것은 무언가 맹세를 하는 것이 아니라는 점을 명심하자. 
모형이라는 그 골렘은 당신의 수하일 뿐이다. 

정규분포를 쓰지 않는 것이 좋은 상황에 대해서는 나중에 살펴보자.

# 4.2 A Language for describing models

이 책에서는 통계적 모형을 표현하고 다루기 위한 표준 문법을 사용한다. 그 방식은 다음과 같다.

1. 우리가 이해하고자 하는 변수들이 있다. 그 중에서 우리가 관측할 수 있는 변수를 **Data** 라고 한다. 비율이나 평균처럼 관측할 수 없는 변수는 **Parameter** 라고 한다.
2. 각각의 변수를 **다른 변수를 통해 표현**하거나, **확률 분포**의 형태로 나타낸다. 이러한 정의를 통해 변수들 사이의 관계를 알 수 있다.
3. 변수들과 각각의 확률 분포를 통해 **Joint Generative Model** 을 구성한다. 모형을 통해 실제 데이터를 분석하거나 시뮬레이션을 수행할 수 있다.

## 4.2.1 Re-describing the globe tossing model

이전 장의 지구본 던지기 문제를 다시 표현해보자. 

```
W ~ Binomial(N, p)
p ~ Uniform(0, 1)

- W는 지구본을 던져서 물이 나온 횟수
- p는 지구본에서 물이 차지하는 비율
```

이런 식으로 표현하면 모형이 가정하고 있는 내용까지 바로 알 수 있다. 이항 분포는 각 샘플이 서로 독립적으로 뽑히는 상황을 가정한다. 
따라서 지구본을 던졌을 때도 각 포인트는 서로 독립이라고 가정하고 있는 것이다. 

- 위 모형에서 첫 번째 줄은 베이즈 정리에서 말하는 **Likelihood** 를, 두 번째 줄은 **Prior** 를 의미한다
- 두 줄 모두 확률론적(stochastic) 관계이기 때문에 `~` 기호로 표시되어 있다
    - 확률론적 관계는 변수 또는 파라미터 하나를 확률 분포와 연결지은 것이다
    - 변수의 값을 확실하게 알 수 없기 때문에 *"확률론적(stochastic)"* 이라고 말한다

# 4.3 Gaussian model of height

실제 데이터를 통해 선형 회귀 모형을 구성해보자. 여기서는 한 가지 측정 변수를 사용해 정규 분포로 모델링한다. 
정규 분포를 구성하기 위해서는 평균과 표준편차라는 2개의 파라미터가 필요하다. 
가능한 모든 평균/표준편차 조합에 대해 각 조합이 얼마나 타당한지 데이터를 통해 계산하면, 이 값이 바로 posterior 확률이 된다. 
실제로 계산할 때는 근사치로 구하게 된다. 모든 조합을 구하는 대신 "분포의 분포" 형태로 표현한다.

## 4.3.1 The data

`Howell1` 데이터는 Nancy Howell에 의해 1960년대 후반에 수집된 Dobe 지역 !Kung San 사람들을 조사한 데이터다. 
rethinking 라이브러리에서 다음과 같이 데이터를 확인할 수 있다.

```r
library(rethinking)
library(tidyverse)

# Howell1 데이터를 메모리에 불러온다
data('Howell1')
```

그 중에서도 성인들의 키를 분석 대상으로 한다. 그렇게 하는 이유는, 성인이 되기 전에는 나이와 키 사이에 강한 상관관계가 존재하기 때문이다. 
우선 지금은 복잡하게 고민하지 말고 18살 이상의 사람들의 데이터만 사용하는 것으로 한다.

```r
# age 변수의 값이 18 이상인 row만 추출하여 howell1_data 변수에 저장한다
howell1_data <- Howell1 %>% filter(age >= 18)
```

## 4.3.2 The model

우리의 목표는 정규분포를 통해 데이터의 값들을 모델링하는 것이다. `height` 변수의 분포를 그래프로 그려보면 정규분포와 유사한 형태를 보인다는 것을 알 수 있다. 
하나의 모집단에서 나온 값들이라면 성인의 키 분포는 대부분 정규 분포를 따르게 된다. 
따라서 현재로서는 데이터의 확률 분포를 표현하기 위해 정규 분포를 사용하는 것이 합리적이다. 
(하지만 그래프를 그렸을 때 정규 분포처럼 보일 때만 사용하는 것은 위험하다. 서로 다른 정규 분포가 혼합된 분포일 경우, 눈으로 판단하는 것이 쉽지 않을 수 있다.)

수많은 정규 분포가 존재하지만, 데이터는 평균이 mu 이고 표준편차가 sigma 인 정규 분포를 따른다고 정의한다.

```
h_i ~ Normal(mu, sigma)

- i는 352개의 데이터 포인트 각각의 인덱스를 의미한다 (howell1_data$height)
```

모형을 완성하기 위해서는 몇 가지 prior가 필요하다. 추정해야 하는 파라미터는 mu와 sigma이기 때문에, prior `Pr(mu, sigma)` 를 알아야 한다. 
대부분의 경우 prior는 각 파라미터별로 독립적으로 구분하기 때문에 다음과 같이 정리할 수 있다.

```
h_i   ~ Normal(mu, sigma)     : Likelihood
mu    ~ Normal(178, 20)       : mu prior
sigma ~ Uniform(0, 50)        : sigma prior

- mu의 prior는 95%의 확률로 평균이 (138, 218) 범위 안에 존재하는 분포를 의미한다
```

왜 178cm 일까? 이 책의 저자의 키는 178cm 이다. 그리고 138cm 부터 218cm 라면 성인 인간의 키가 분포할 수 있을 법한 구간을 나타낸다. 
따라서 특정 도메인의 정보를 Prior에 반영한 것이라고 볼 수 있다. 
현재 우리가 다루고 있는 문제는 모두가 알고 있는 정보기 때문에 이러한 방식으로 prior를 설정할 수 있다. 
하지만 일반적인 회귀 문제에서는 조금 더 미묘하다. 파라미터들이 항상 실질적인 의미를 가지고 있는 것은 아니기 때문이다.

실제로 각 Prior 들이 어떤 의미를 가지고 있는지 확인해보는 작업은 중요하다. 따라서 모델링 과정에 필수적으로 **Prior Predictive** 시뮬레이션을 수행한다. 
시뮬레이션을 통해 Prior가 실제 키 값에 어떤 영향을 미치는지 확인한다. Prior 로부터 데이터를 샘플링해보자.

```r
withr::with_par(list(mfrow = c(1, 2)), {
    # mu ~ Normal(178, 20) 로 샘플링
    set.seed(123)
    sample_mu <- rnorm(1e4, 178, 20)
    sample_sigma <- runif(1e4, 0, 50)
    prior_h <- rnorm(1e4, sample_mu, sample_sigma)
    rethinking::dens(prior_h, main = 'mu ~ Normal(178, 20)')
    
    # mu ~ Normal(178, 100) 로 샘플링
    set.seed(123)
    sample_mu <- rnorm(1e4, 178, 100)
    prior_h <- rnorm(1e4, sample_mu, sample_sigma)
    rethinking::dens(prior_h, main = 'mu ~ Normal(178, 100)')
})
```

![](fig/ch4_height_prior_predictive.png)

오른쪽 그래프에서는 대략 4%의 사람들이 음수의 키를 갖는 것으로 나온다. 또는 거인들도 존재하게 된다. 
이게 문제가 될 수 있을까? 지금은 데이터가 충분히 존재하기 때문에 말도 안되는 prior를 사용하더라도 큰 문제가 없다. 
하지만 데이터만으로는 충분하지 않은 문제들도 분명히 존재한다. 

## 4.3.3 Grid Approximation of the posterior distribution

우리가 책에서 처음으로 다루게 되면 정규 분포 모형이기 때문에, brute force 방법을 통해 빠르게 posterior 분포를 구해보자. 
코드 작성이 쉽지 않고 계산량이 많기 때문에 다른 곳에서는 이 방식을 사용하지 않을 것이다. 
이 계산을 위해서는 몇 가지 트릭이 필요하기 때문에 설명없이 코드만 실행해보자.

```r
set.seed(123)

mu_list <- seq(from = 150, to = 160, length.out = 100)
sigma_list <- seq(from = 7, to = 9, length.out = 100)
post <- expand.grid(mu = mu_list, sigma = sigma_list)

post$LL <- sapply(1:nrow(post), function(i) {
    sum(dnorm(howell1_data$height, post$mu[i], post$sigma[i], log = TRUE))
})

post$prod <- post$LL + 
    dnorm(post$mu, 178, 20, TRUE) +
    dunif(post$sigma, 0, 50, TRUE)

post$prob <- exp(post$prod - max(post$prod))
```

키 데이터의 posterior 샘플링 결과 분포는 다음과 같다.

```r
# Heatmap을 그려서 분포를 살펴보자
rethinking::image_xyz(post$mu, post$sigma, post$prob)
```

![](fig/ch4_height_grid_approx.png)

## 4.3.4 Sampling from the posterior

Posterior 분포를 더 자세히 살펴보기 위해 3장에서 지구본 던지기 문제에 적용했던 보다 유연한 방법을 적용해 보자. 
달라지는 것이 있다면 이번에는 두 개의 파라미터의 조합에서 샘플링해야 한다는 점이다. 복원 추출로 10,000개의 키 데이터 posterior 분포를 구해보자.

```r
set.seed(123)

# post$prob 의 확률값에 비례하여 post 데이터프레임의 row index를 샘플링한다
sample_rows <- sample(1:nrow(post), size = 1e4, replace = TRUE, prob = post$prob)

# 샘플링한 row index를 바탕으로 mu, sigma 값을 추출한다
sample_mu <- post$mu[sample_rows]
sample_sigma <- post$sigma[sample_rows]

# 키 데이터의 Posterior 분포를 그래프로 살펴보자
plot(sample_mu, sample_sigma, cex = 0.5, pch = 16, col = col.alpha(rangi2, 0.1))
# 참고. col.alpha 는 rethinking 라이브러리의 함수로, 색상에 투명도를 부여한다
```

![](fig/ch4_height_posterior_sampling.png)

이제 샘플링 결과를 요약하는 방식으로 파라미터 조합의 신뢰도 분포를 계산할 수 있다. 
예를 들면, 각 파라미터의 marginal 분포를 구하기 위해서는 다음과 같이 하면 된다.

```r
# 각 파라미터의 분포를 그래프를 통해 확인한다
rethinking::dens(sample_mu)
rethinking::dens(sample_sigma)

# Posterior compatibility interval 계산하기
rethinking::PI(sample_mu)
#       5%      94% 
# 153.9394 155.2525 
rethinking::PI(sample_sigma)
#       5%      94% 
# 7.323232 8.252525
```

*"marginal"* 이라는 것은 **"다른 파라미터에 대해 평균한다" 는 것을 의미한다.** 
각각의 분포는 정규 분포와 비슷한 형태를 띄고, 대체로 이런 경우가 많다. 샘플 수가 많아질수록 Posterior 분포가 정규분포에 가까워진다. 
자세히 보면 sigma의 분포는 살짝 오른쪽 꼬리가 긴데, 이 부분에 대해서는 나중에 자세히 다룰 예정이다. 
(표준 편차와 같은 형태의 파라미터에서 자주 나타나는 형태의 분포다)

샘플링을 통해 추출한 값은 일반적인 벡터 형태이기 때문에, 평균 등 자료를 요약할 때 사용하는 통계량을 적용할 수 있다.

## 4.3.5 Finding the posterior distribution with `quap`

이제 Grid Approximation은 내려놓고, **Quadratic Approximation** 을 사용해보자. 
Posterior 분포에서 가장 높은 지점인 **MAP (Maximum a posteriori)** 를 추정해야 하는데, 
Quadratic approx를 통해 posterior 분포를 근사하여 구하게 된다. 
Quadratic approximation 을 위해 rethinking 패키지의 `quap` 함수를 사용한다. 
참고로 이 작업은 베이지안이 아닌 다른 방법론과 유사하게 Prior를 사용하지 않는 방식이다.

```r
library(rethinking)
library(tidyverse)

data('Howell1')
howell1_data <- Howell1 %>% filter(age >= 18)

# base::alist 함수를 통해 모형을 정의한다
# - mu ~ dnorm( 178 , 20 ) 은 굉장히 약한 prior다 
# - mu ~ dnorm( 178 , 0.1 ) 은 굉장히 강한 prior가 된다
model_definition <- alist(
    height ~ dnorm(mu, sigma),
    mu ~ dnorm( 178 , 20 ),
    sigma ~ dunif( 0 , 50 )
)

# 모형에 데이터를 fitting한다
model_quap_01 <- quap(model_definition , data = howell1_data)

# Posterior 분포를 간단히 살펴보자
# - 각 파라미터의 marginal distribution을 정규 분포에 근사한 형태
# - 5.5%, 94.5% 백분위 값을 통해 89% 신뢰구간을 구할 수 있다
# - 왜 89%냐면, 95%로 설정하면 사람들이 자꾸 유의성 검정 테스트처럼 생각해버려서
#   기본값을 바꾸어두었다
precis(model_quap_01)
#         mean   sd   5.5%  94.5%
# mu    154.61 0.41 153.95 155.27
# sigma   7.73 0.29   7.27   8.20
```

## 4.3.6 Sampling from a `quap`

`quap` 함수로 Posterior 분포를 근사시켰다면, 샘플링은 어떻게 할 수 있을까? 
이를 위해서는 quadratic approximation의 결과가 mu, sigma 두 개의 차원으로 이루어진 다변량 정규분포라는 것을 이해해야 한다. 
따라서 R에서 계산하기 위해서는 각 파라미터의 표준편차 뿐만 아니라 파라미터 간의 공변량까지 구해야 한다. 

```r
# variance - covariance 행렬을 구한다
rethinking::vcov(model_quap_01)
#                 mu        sigma
# mu    0.1697357114 0.0002186345
# sigma 0.0002186345 0.0849009400

# variance - covariance 행렬은 두 가지 항목으로 분리할 수 있다
# (1) 각 파라미터의 분산
diag(vcov(model_quap_01))
#         mu      sigma 
# 0.16973571 0.08490094

# (2) 각 파라미터 사이의 상관관계 행렬
cov2cor(vcov(model_quap_01))
#                mu       sigma
# mu    1.000000000 0.001821276
# sigma 0.001821276 1.000000000
```

이제 학습시킨 다변량 정규분포에서 샘플링한다. rethinking 라이브러리에서 이 작업을 쉽게 하기 위한 함수를 제공한다.

```r
m_quap_posterior <- rethinking::extract.samples(model_quap_01, n = 1e4)
head(m_quap_posterior)
#         mu    sigma
# 1 154.8397 7.041067
# 2 154.7018 7.780093
# 3 153.9656 7.459495
# 4 154.5776 7.896715
# 5 154.5540 7.665521
# 6 153.9013 7.399590
```

각각의 값이 posterior 에서 샘플링한 결과이기 때문에, 각 열의 평균을 구하면 MAP와 매우 근사한 값을 구할 수 있다.

```r
rethinking::precis(m_quap_posterior)
# quap posterior: 10000 samples from model_quap_01
#         mean   sd   5.5%  94.5%   histogram
# mu    154.61 0.41 153.95 155.26     ▁▁▅▇▂▁▁
# sigma   7.73 0.29   7.26   8.20 ▁▁▁▂▅▇▇▃▁▁▁
```

이 샘플링 결과는 두 파라미터의 공분산까지 보존한다. 지금은 크게 문제가 되지 않지만, 파라미터가 많아질수록 공분산이 문제가 되는 경우가 많아진다.

# 4.4 Linear Prediction

성인 모집단의 키 분포를 정규 분포를 통해 모델링 해보았다. 하지만 그것만 가지고는 일반적인 회귀 모형을 수행하는 것과는 거리가 있다. 
우리가 모델링을 하는 이유 중 하나는 결과 변수가 다른 변수들(predictor variable)과 어떻게 관련되어 있는지를 알고자 한다. 
만약 입력 변수들이 결과 변수와 특정한 통계적인 관계가 존재한다면 이를 예측에 활용할 수 있다. 

그러면 이제 키가 체중과 어떤 연관이 있는지 살펴보자. 크게 학문적으로 흥미로운 질문이 아니라는 것은 알고 있지만, 모델링을 시작하기에는 좋은 사례다. 
그래프를 그려서 대략적인 관계를 살펴보자.

```r
ggplot(howell1_data, aes(x = height, y = weight)) +
    geom_point(color = '#1D4E89') +
    theme_minimal()
```

![](fig/ch4_linear_relation_01.png)

## 4.4.1 The linear model strategy

이전의 정규 분포 모형과 입력 변수 사이의 관계를 통합하기 위해 사용하는 전략이 있다. 정규분포의 평균인 mu와 다른 입력 변수를 연결하는 선형 함수를 만드는 것이다. 
이것을 바로 **선형 모형 (Linear model)** 이라고 한다. 그러면 이런 선형 관계 가정을 통해 posterior 분포를 계산할 수 있다. 

어떻게 하는지 살펴보자.

```
h_i   ~ Normal(mu_i, sigma)          : Likelihood
mu_i  ~ alpha + beta * (x_i - mu_x)  : Linear Model
alpha ~ Normal(178, 20)              : alpha prior
beta  ~ Log-Normal(0, 10)            : beta prior
sigma ~ Uniform(0, 50)               : sigma prior
```

## 4.4.2 Finding the posterior distribution

이제 새로 정의한 모형을 R 코드로 변환해보자.

```
h_i   ~ Normal(mu_i, sigma)          : Likelihood    ->  height ~ dnorm(mu, sigma)
mu_i  ~ alpha + beta * (x_i - mu_x)  : Linear Model  ->  mu <- a + b*weight
alpha ~ Normal(178, 20)              : alpha prior   ->  a ~ dnorm(178, 20)
beta  ~ Log-Normal(0, 10)            : beta prior    ->  b ~ dlnorm(0, 1)
sigma ~ Uniform(0, 50)               : sigma prior   ->  sigma ~ dunif(0, 50)
```

```r
# 평균 몸무게값을 x_bar 로 정의한다
x_bar <- mean(howell1_data$weight)

# 모형을 학습해보자
model_quap_03 <- quap(
    flist = alist(
        height ~ dnorm(mu, sigma),
        mu <- a + b*(weight - x_bar),
        a ~ dnorm(178, 20),
        b ~ dlnorm(0, 1),
        sigma ~ dunif(0, 50)
    ), 
    data = howell1_data
)
```

## 4.4.3 Interpreting the posterior distribution

이렇게 생성한 모형을 해석하는 방식은 크게 두 가지가 있다.

1. 표를 만들어서 읽는다
2. 시뮬레이션 결과를 그래프로 그린다

간단한 문제라면 marginal 값에 대한 표를 그리는 것 만으로도 많은 것을 해결할 수 있다. 하지만 대부분의 문제들은 표의 몇몇 수치만으로 이해하기 어렵다. 파라미터 수가 많아지면 모든 파라미터들이 예측 결과에 어떤 영향을 미치게 될지 파악하기 어려워진다. 따라서 이 책에서는 Posterior 분포와 Posterior 예측 결과를 그래프로 그려보는 것을 권장한다. 그래프를 통해 다음과 같은 질문들을 던져보자. 

1. 모형 학습 과정이 잘 이루어졌는가
2. 예측 변수와 결과 변수간 관계에 대한 절대적인 크기
3. 예측 변수와 결과 변수간 평균적인 관계가 가지는 불확실성
4. 파라미터의 불확실성과는 별개로 모형의 암묵적인 예측이 가지는 불확실성

# 4.5 Curves from lines

이번에는 선형 회귀 방법론을 통해 곡선 모형을 학습하는 방법을 알아보자. 첫 번째는 **Polynomial Regression** , 두 번째는 **B-Spline** 이다. 두 방법론 모두 하나의 입력 변수를 여러 개로 만든 후에 가중치를 이용해 조정하는 방식을 사용한다. 하지만 spline 쪽이 좀 더 명확한 장점을 가지고 있다. 두 가지 모두 변수들 간의 관계를 표현하는 함수 역할만을 하기 때문에, 인과 관계를 추론하고자 할 때는 더 많은 것들이 필요해진다.

## 4.5.1 Polynomial Regression

Polynomial Regression 은 변수들의 거듭제곱 형태를 추가적인 입력 변수로 사용한다. 어떤 방식으로 동작하는지 확인해보기 위해 !Kung 데이터 전체를 가지고 적용해보자.

```r
library(rethinking)
library(tidyverse)

data('Howell1')
str(Howell1)
# 'data.frame':	544 obs. of  4 variables:
#  $ height: num  152 140 137 157 145 ...
#  $ weight: num  47.8 36.5 31.9 53 41.3 ...
#  $ age   : num  63 63 65 41 51 35 32 27 19 54 ...
#  $ male  : int  1 0 0 1 0 1 0 1 0 1 ...
```

가장 일반적으로 사용되는 polynomial regression 은 평균에 대한 포물선 모형이다.

```
mu_i = alpha + (beta1 * x_i) + (beta2 * x_i^2)
```

이런 모형은 쉽게 학습할 수는 있지만, 해석하기가 어렵다. 이제 몸무게를 통해 키를 설명하는 포물선 모형을 학습해보자. 우선 해야 하는 작업은 예측 변수를 표준화(Standardize)하는 것이다. 이 작업은 polynomial 모형을 학습할 때 특히 도움이 된다. 예측 변수 중에 스케일이 큰 값이 있다면 잘못된 예측으로 이어질 가능성이 있다. polynomial 모형에는 제곱이나 세제곱 등이 포함되어 있기 때문에 더 큰 영향을 받게 된다. 포물선 모형을 만들 때는 `mu_i` 부분만 수정하면 된다.

```
h_i   ~ Normal(mu_i, sigma)                 ->  height ~ dnorm(mu, sigma)
mu_i  ~ alpha + beta1*{x_i} +beta2*{x_i}^2  ->  mu <- a + b1*weight_s +b2*weight_s^2
alpha ~ Normal(178, 20)                     ->  a ~ dnorm(178, 20)
beta1 ~ Log-Normal(0, 1)                    ->  b1 ~ dlnorm(0, 1)
beta2 ~ Normal(0, 1)                        ->  b2 ~ dnorm(0, 1)
sigma ~ Uniform(0, 50)                      ->  sigma ~ dunif(0, 50)
```

beta2 의 prior를 설정하는 부분이 조금 헷갈릴 수 있다. beta1 과는 달리, 굳이 양수 값만 받아야 할 필요가 없다. 이번 장이 끝날 쯤에 prior predictive 시뮬레이션을 통해 왜 그런지 살펴보자. Polynomial 파라미터는 보통 현실적인 prior를 설정하는 것이 어려운데, polynomial 모형을 피하고자 하는 또 다른 이유기도 하다.

Posterior 를 근사시키는 것은 직관적이다. 

```r
howell_data <- Howell1 %>% 
    as_tibble() %>% 
    # weight 변수를 표준화시킨다
    mutate(weight_s = (weight - mean(weight)) / sd(weight),
            weight_s2 = weight_s^2)

model_quap_04 <- quap(
    alist(
        height ~ dnorm(mu, sigma),
        mu <- a + b1*weight_s + b2*weight_s2,
        a ~ dnorm(178, 20),
        b1 ~ dlnorm(0, 1),
        b2 ~ dnorm(0, 1),
        sigma ~ dunif(0, 50)
    ), 
    data = howell_data
)
```

이제 height와 weight 변수 간의 관계가 두 개의 기울기 값을 통해 표현되기 때문에 모델링 결과의 계수를 해석하는 것이 쉽지 않다.

```r
precis(model_quap_04)
#         mean   sd   5.5%  94.5%
# a     146.06 0.37 145.47 146.65
# b1     21.73 0.29  21.27  22.19
# b2     -7.80 0.27  -8.24  -7.37
# sigma   5.77 0.18   5.49   6.06
```

그래프를 통해 살펴보자. 

```r
# 예측값을 구하기 위해 표준화된 weight 값의 그리드를 만든다
pred_data_raw <- tibble(
    weight_s = seq(from = -2.2, to = 2, length.out = 30),
    weight_s2 = weight_s^2
)

# height ~ weight의 평균적인 관계와 그 Percentile Interval
mu <- link(model_quap_04, data = pred_data_raw)
mu_mean <- apply(mu, 2, mean)
mu_PI <- apply(mu, 2, PI, prob = 0.89)

# 시뮬레이션을 통해 생성한 height의 Percentile Interval
simulated_height <- sim(model_quap_04, data = pred_data_raw)
sim_height_PI <- apply(simulated_height, 2, PI, prob = 0.89)

# 예측값을 모아서 데이터프레임으로 구성한다
pred_data <- pred_data_raw %>% 
    mutate(mu_mean = mu_mean,
            mu_PI_05 = mu_PI[1,],
            mu_PI_94 = mu_PI[2,],
            height_PI_05 = sim_height_PI[1,],
            height_PI_94 = sim_height_PI[2,])

# 그래프로 그린다
ggplot(howell_data, aes(x = weight_s)) +
    geom_point(aes(y = height), color = '#1D4E89', alpha = 0.5) +
    geom_line(data = pred_data, aes(y = mu_mean), color = '#1D4E89', size = 1) +
    geom_ribbon(data = pred_data, aes(ymin = mu_PI_05, ymax = mu_PI_94), fill = '#1D4E89', alpha = 0.5) +
    geom_ribbon(data = pred_data, aes(ymin = height_PI_05, ymax = height_PI_94), fill = '#1D4E89', alpha = 0.2) +
    labs(x = 'Standardized Weight', 
        y = 'Height',
        title = 'Polynomial Regression : Quadratic Model') +
    theme_minimal()
```

![](fig/ch4_polynomial_quadratic_01.png)

2차항 대신 3차항을 사용할 경우 더 유연하기 때문에 데이터가 더 잘 학습된다. 하지만 어떤 모형이 더 좋은지 판단하기는 쉽지 않다. 

1. 학습이 더 잘 되었다고 해서 더 나은 모형이라는 법은 없다. (Ch 7에서 다룬다)
2. 모형이 생물학적인 정보는 담고 있지 않기 때문에, 키와 몸무게 사이의 인과적인 관계에 대해서는 알 수 없다. (Ch 16에서 다룬다)

## 4.5.2 Splines

곡선을 학습하는 또 한 가지 방법은 **Spline** 이라는 것을 구성하는 것이다. 
Spline에는 많은 종류가 있는데, 그 중에서도 우리가 살펴볼 **B-Spline** 은 가장 널리 사용되기도 하고, 좋은 성질이 많은 방법이다. 
(여기서 B는 "Basis" 를 의미한다. Component를 의미한다고 생각하자.) 

**B-Spline** 은 특정한 예측 변수를 여러 부분으로 나누고, 각 부분에 파라미터를 설정한다. 
이 파라미터들은 점진적으로 켜지거나 꺼지면서 주기적으로 반복되는 형태의 곡선을 구성한다. 
이렇게 곡선과는 거리가 먼 로컬 함수를 여러 개 만들고, 가중치를 통해 합쳐가면서 점차 하나의 곡선을 표현하는 함수를 만들어낸다. 

조금 더 자세하게 살펴보자. 연도별 온도 데이터를 B-Spline을 통해 근사시켜보자. 
B-Spline은 Polynomial Regression과 달리 예측 변수에 직접 제곱이나 세제곱을 취하지 않는다. 대신 여러 개의 인공적인 예측 변수를 생성한다. 
이 변수들 각각을 **Basis Function** 이라고 한다. 
그리고 각 파라미터는 기울기처럼, 대응되는 Basis function이 평균 `mu_i` 에 얼마나 영향을 미치는지를 나타낸다. 선형 모형을 정리해보면 다음과 같다.

```
mu_i = alpha + w1 * B_{i,1} + w2 * B_{i,2} + ...

여기서, 
* B_{i,1} 은 i행의 n번째 Basis Function
* w는 각 Basis Funciton에 대응하는 가중치를 의미한다
```

basis 변수 B는 어떻게 구성할 수 있을까? 

1. 전체 가로축을 4개의 영역으로 나눈다. 이 때 각 영역을 나누기 위핸 piovt point를 **Knots** 라고 한다.
2. 이렇게 영역을 나누면 5개의 Basis Function (B 변수) 가 생기는데, 각 영역에서 다음 영역으로 이동시키는 역할을 한다.
3. 모형에 데이터를 학습시키면 각 basis function의 가중치를 구할 수 있다.
4. 이렇게 구한 spline 을 통해, 온도 데이터에 대한 97% posterior interval을 구할 수 있다.
5. 다음과 같은 방법을 통해 spline의 정확도를 높일 수 있다.
    - 더 많은 knots 를 사용한다
    - 각각의 basis function을 구성할 때 선형 근사를 사용하는 대신 높은 차수의 다항 함수를 사용한다

실제 데이터에 적용해보자.

```r
# rethinking 라이브러리의 cherry_blossoms 데이터를 메모리상에 불러온다
data('cherry_blossoms', package = 'rethinking')

# temp 변수가 존재하는 행으로만 필터링한다
cherry_blossoms_data <- cherry_blossoms %>% 
    as_tibble() %>% 
    filter(complete.cases(temp))

# 주어진 개수의 knot을 생성한다
NUM_KNOTS <- 15
knot_list <- quantile(cherry_blossoms_data$year, probs = seq(0, 1, length.out=NUM_KNOTS))

# Degree=3 의 basis function을 생성한다
# * [1124, 17] 사이즈의 행렬이 만들어진다
# * 각 행은 year 변수를, 각 열은 basis function을 의미한다
basis_functions <- splines::bs(
    cherry_blossoms_data$year,
    knots = knot_list[-c(1, NUM_KNOTS)],
    degree = 3,
    intercept = TRUE
)

# 각 basis function의 값을 그래프를 통해 확인해보자
basis_functions %>% 
    as_tibble() %>% 
    mutate(year = cherry_blossoms_data$year) %>% 
    tidyr::pivot_longer(names_to = 'knot', -year) %>% 
    ggplot(aes(x = year, y = as.numeric(value), group = knot)) +
        geom_line(color = '#1D4E89', alpha = 0.5) +
        labs(x = 'Year', y = 'Basis Value') +
        theme_minimal()
```

![](fig/ch4_spline_01.png)

이제 각 basis function의 파라미터 가중치를 구해보자. 수학적인 형태로 spline 모형을 표현하면 다음과 같다.

```
T_i   ~ Normal(mu_i, sigma)
mu_i  ~ alpha + SUM_{k=1}^{K}( w_k * B_{k,i} )
alpha ~ Normal(6, 10)
w_j   ~ Normal(0, 1)
sigma ~ Exponential(1)

* 각 basis value에 대응하는 파라미터 w_j 를 곱하고, 모두 합한다
```

R 코드로는 다음과 같이 구할 수 있다.

```r
model_spline_01 <- quap(
    alist(
        T ~ dnorm(mu, sigma),
        mu <- a + B %*% w,
        a ~ dnorm(6, 10),
        w ~ dnorm(0, 1),
        sigma ~ dexp(1)
    ),
    data = list(T = cherry_blossoms_data$temp, B = basis_functions),
    start = list(w = rep(0, ncol(basis_functions))) 
)
```

Posterior 예측 결과를 그래프로 그려보자.

```r
# Basis Value * Weight 값을 계산하여 그래프로 그려보자
posterior_spline <- rethinking::extract.samples(model_spline_01)
posterior_means <- apply(posterior_spline$w, 2, mean)
weighted_basis <- t(apply(basis_functions, 1, function(x) x * posterior_means))

weighted_basis %>% 
    as_tibble() %>% 
    mutate(year = cherry_blossoms_data$year) %>% 
    tidyr::pivot_longer(names_to = 'knot', -year) %>% 
    ggplot(aes(x = year, y = as.numeric(value), group = knot)) +
        geom_vline(data = data.frame(x = knot_list), aes(xintercept = x), linetype = 2, alpha = 0.3) +
        geom_line(color = '#1D4E89', alpha = 0.5, size = 0.8) +
        labs(x = 'Year', y = 'Basis Value') +
        theme_minimal(base_size = 14)
```

![](fig/ch4_spline_02.png)

이제 각 연도별 평균 온도에 대한 97% Posterior Interval을 계산해보자.

```r
# 97% Posterior Interval 을 생성한다
mu_temp <- link(model_spline_01)
mu_temp_PI <- apply(mu_temp, 2, PI, 0.97)

cherry_blossoms_data %>% 
    mutate(mu_temp_PI_02 = mu_temp_PI[1,],
            mu_temp_PI_98 = mu_temp_PI[2,]) %>% 
    ggplot(aes(x = year)) +
    geom_point(aes(y = temp), color = '#1D4E89', size = 1, alpha = 0.5) +
    geom_ribbon(aes(ymin = mu_temp_PI_02, ymax = mu_temp_PI_98), fill = '#1D4E89', alpha = 0.5) +
    labs(x = 'Year', y = 'Temperature',
        title = '97% Posterior Interval for mu, at each year') +
    theme_minimal(base_size = 14)
```

![](fig/ch4_spline_03.png)
