# 8. Conditional Manatees

매너티(Manatee)는 따뜻하고 얕은 물에 사는 포유류이다. 자연적인 천적은 없지만, 매너티들이 살고 있는 물가에는 모터 보트가 많아서 보트의 프로펠러로 인해 위험을 겪을 때가 많다. 
성장한 매너티 중 상당수는 보트와 충돌하면서 생긴 상처를 가지고 있다고 한다.

암스트롱 휘트워스 휘틀리(Armstrong Whitworth A.W.38 Whitley)는 제 2차 세계대전 기간에 사용된 폭격기다. 
매너티와는 달리 위험한 천적들이 있다. 바로 대포와 요격 사격이다. 많은 폭격기들이 임수에서 돌아오지 못했고, 살아서 돌아온 폭격기들도 무수한 상처를 가지고 있다. 

매너티와 폭격기의 공통점은 무엇일까? 매너티는 프로펠러로 인해 생긴 상처를 가지고 있고, 폭격기는 사격으로 인한 구멍이 생겼다. 
그렇다면 남아있는 상처를 토대로 생존율을 높일 방법을 찾아볼 수 있지 않을까? 
매너티를 위해서는 보트의 프로펠러가 매너티와 충돌하지 않게 감싸고, 폭격기가 많이 사격 받는 위치에 추가로 장갑을 덧대는 방법이 있을 것이다.

하지만 두 경우 모두, 정보들이 우리를 헷갈리게 만든다. 프로펠러는 사실 매너티가 부상을 입거나 죽는 가장 주요 원인이 아니다. 
부검 결과를 살펴보면 오히려 보트의 용골처럼 날카롭지 않은 부분에 부딪혔을 때 더 큰 피해를 입는다는 것을 알 수 있다. 
마찬가지로 폭격기에 사격으로 인한 상처가 많은 곳의 장갑을 덧대는 것은 큰 효과가 없다. 오히려 상처가 적은 곳을 집중적으로 보완해야 한다. 

살아남은 매너티와 폭격기에서 정보를 얻었을 때 잘못된 판단을 하게 되는 이유가 무엇일까? 바로 **생존했다는 조건 하에서만** 정보를 얻었기 때문이다. 
용골에 부딪힌 매너티는 프로펠러에 부딪히는 경우보다 살아남는 경우가 적었다. 따라서 살아있는 매너티 중에서는 프로펠러와 충돌했던 경우가 많았다. 
폭격기도 비슷하다. 조종석과 엔진에 손상을 입지 않은 기체들은 무사히 기지로 돌아올 수 있었다. 그 반대는 돌아오지 못했다. 
제대로 된 답을 찾기 위해서는 양쪽의 맥락을 모두 이해할 수 있어야 한다.

조건을 부여하는 것(Conditioning)은 통계적 추론 과정에서 중요한 원칙 중 하나다. 모든 추론은 무언가를 조건으로 한다. 
비록 우리가 파악하지 못했더라도 말이다. 선형 모형은 각 데이터의 예측 변수를 조건으로 했을 때 결과 변수를 설명한다. 
하지만 단순한 선형 모형에서는 여러 조건을 충분하게 설명하지 못할 때가 많다. 
이제까지 다룬 예시 모형에서는 대부분 각 예측변수가 결과변수의 평균과 독립적인 상관관계가 있다고 가정했다. 그 관계가 조건부일 수 있다면 어떨까? 

더 깊은 조건을 모형에서 표현하려면, 다시 말해 한 예측 변수의 중요도가 다른 예측 변수의 값에 따라 달라질 수 있다면 
이것을 표현하기 위해서는 **교호작용(Interaction)** 이 필요하다. Interaction은 흔하게 볼 수 있지만, 다루기는 쉽지 않다.

# 8.1 Building an interaction

아프리카는 참 특별한 곳이다. 그 중에서도 지리적으로는 이상한 방향으로 특별하다. 
보통 지정학적으로 나쁜 위치에 있는 경우 경제력에 부정적인 영향을 미친다. 그런데 아프리카는 정반대의 추이가 나타난다. 
이 현상에 대해 더 살펴보기 위해 지형 기복지표(Terrain Ruggedness Index, 좋지 않은 지형의 사례다)와 log GDP 간의 회귀모형을 구성해보자. 

TRI가 높을 경우 운송수단이 발달하기 어려워지고 이로 인해 시장에 접근하기 어려워진다. 따라서 대부분의 국가에서는 TRI가 높아질수록 GDP가 낮아지는 추이를 보인다. 
그렇기 때문에 반대의 현상이 나타나는 아프리카가 신기해진다. 왜 이런 결과가 나타나는 것일까? 
이유를 고민해보면, 험준한 지형의 국가들은 노예 거래가 적게 이루어졌기 때문일 수 있다. 
하지만 GDP에 영향을 주는 요인이 너무 많기 때문에 정확히 어떤 이유로 그런 현상이 발생했는지 알기는 어렵다. 

이러한 현상을 데이터에서 찾아내고 설명하려면 어떻게 해야 할까? 앞서 살펴봤던 것처럼 아프리카 여부로 데이터를 나누어 쪼개보는 것은 그다지 좋은 방법이 아니다. 
크게 다음과 같은 4가지 이유가 있다.

1. sigma 처럼 아프리카 여부와는 상관없는 파라미터들이 존재한다. 데이터를 특정 변수를 기준으로 쪼갠다면 이러한 변수에 대한 추정 정확도가 낮아질 수 있고, 이 과정에서 암묵적인 가정들이 포함될 수 있다.
2. 데이터를 나누기 위한 기준이 되는 변수에 대한 확률 정보를 얻기 위해서는 해당 변수가 모형에 포함되어야 한다. 여기서는 "아프리카 여부" 변수가 해당된다. 해당 변수의 값에 따라 불확실성이 어떻게 달라지는지 파악하는 것은 중요한 정보다.
3. 여러 모형을 비교하기 위해서는 동일한 데이터를 사용해야 한다. 따라서 데이터를 나누는 것이 아니라 모형이 자체적으로 데이터를 나누어 파악하게 해야 한다.
4. 다층 모형으로 확장하게 되면 특정 카테고리에서 샘플 사이즈가 매우 적어지는 문제가 생길 수 있다. 데이터를 한 번에 모델링하게 되면 다른 카테고리의 정보를 빌려오는 방식으로 문제를 일부 해결할 수 있다.

이제 간단한 모형을 통해 살펴보자.

## 8.1.1 Making two models

데이터를 불러와서 아프리카 아프리카가 아닌 경우 두 그룹으로 나누어보자.

```r
library(rethinking)
library(tidyverse)

# rugged 데이터
# - 각 행은 국가, 각 열은 경제/지리/역사와 관련된 변수들
data(rugged, package = 'rethinking')

# rugged 데이터 전처리
rugged_std <- rugged %>% 
  as_tibble() %>% 
  filter(complete.cases(rgdppc_2000)) %>% 
  mutate(log_gdp = log(rgdppc_2000),
         log_gdp_std = log_gdp / mean(log_gdp),
         rugged_std = rugged / max(rugged)) # 0에 의미가 있기 때문에 z-score를 사용하지 않는다

# 아프리카 여부에 따라 데이터를 분리한다
rugged_std_af <- rugged_std %>% filter(cont_africa == 1)
rugged_std_naf <- rugged_std %>% filter(cont_africa == 0)
```

변수들의 관계를 모델링하기 위해 우선 다음과 같은 형태의 모형을 세워보자.

- alpha 값은 ruggedness가 평균일 때 log GDP 값을 의미한다
    - 따라서 1에 가까워야 하기 때문에 Prior를 `Normal(1, 1)` 로 시작해보자
- beta 값은 0일 때 편향이 없는 것을 의미한다
    - 표준 편차는 아직 잘 모르니 1에서 시작한다 : `Normal(0, 1)`
- sigma의 Prior는 넓게 `exp(1)` 로 시작해보자

```
log(y_i) ~ Normal(mu_i, sigma)
mu_i = alpha + beta * (r_i - r_bar)
alpha ~ Normal(1, 1)
beta ~ Normal(0, 1)

y_i : 각 국가별 GDP
r_i : 각 국가별 Terrain Ruggedness
r_bar : 전체 Terrain Ruggedness 평균 (여기서는 0.215)
```

아프리카 국가들의 데이터에 모델링을 적용해보자.

- 그래프에서 점선은 실제 관측한 log GDP 값의 최대, 최소 값을 의미한다
    - 생성된 회귀선을 보면 실제 값 영역을 한참 넘어선 구간에도 많이 위치하는 것을 볼 수 있다
    - 회귀선은 ruggedness의 평균값인 0.215와 평균 log GDP인 1을 많이 지나가야 할 것 같다
- 기울기도 너무 실제 값에서 나타날 수 있는 영역을 많이 벗어나고 있다
- `a ~ dnorm(1, 0.1)` , `b ~ dnorm(0, 0.3)` 인 경우의 그래프와 비교해서 살펴보자

```r
m8.1_rugged_af_01 <- quap(
  alist(
    log_gdp_std ~ dnorm(mu, sigma),
    mu <- a + b * (rugged_std - 0.215),
    a ~ dnorm(1, 1),
    b ~ dnorm(0, 1),
    sigma ~ dexp(1)
  ),
  data = rugged_std_af
)

# Prior Prediction
set.seed(123)
m8.1_rugged_af_01_prior <- extract.prior(m8.1_rugged_af_01)
m8.1_rugged_af_01_mu <- link(
  m8.1_rugged_af_01, 
  post = m8.1_rugged_af_01_prior, 
  data = data.frame(rugged_std = seq(-0.1, 1.1, length.out = 30))
)

# 그래프 그리기 위한 형태로 변경
m8.1_rugged_af_01_mu_long <- t(m8.1_rugged_af_01_mu[1:50, ]) %>% 
  as_tibble() %>% 
  mutate(ruggedness = seq(-0.1, 1.1, length.out = 30)) %>% 
  tidyr::pivot_longer(cols = V1:V50, names_to = 'group', values_to = 'log_gdp')

ggplot(m8.1_rugged_af_01_mu_long, aes(x = ruggedness, y = log_gdp)) +
  geom_line(aes(group = group), alpha = 0.3) +
  geom_hline(yintercept = min(rugged_std$log_gdp_std), linetype = 2) +
  geom_hline(yintercept = max(rugged_std$log_gdp_std), linetype = 2) +
  ylim(0.5, 1.5) +
  labs(title = 'a ~ dnorm(1,1), b ~ dnorm(0,1)', y = 'log GDP') +
  theme_minimal()
```

![](fig/ch8_ruggedness_01.png)

![](fig/ch8_ruggedness_02.png)
