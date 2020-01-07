# Causal Inference using Difference in Differences, Causal Impact, and Synthetic Control

- 다음 포스팅을 간단하게 요약해보자
- <https://towardsdatascience.com/causal-inference-using-difference-in-differences-causal-impact-and-synthetic-control-f8639c408268>

# How to estimate the true causal impact?

어떠한 대상에 개입했을 때 벌어지는 인과적인 효과를 추정하는 방법은 크게 두 가지가 있다.

- **Randomized Experiment**
    - 무작위로 대상을 추출하여 변화를 일으킨다
    - 인과 효과를 추정할 수 있는 가장 신뢰성 있는 방법론이다
    - 실험을 수행하기 어렵거나, 완전한 무작위성을 구현하는 것이 어려운 경우가 많다
- **Causal Inference in Econometrics**
    - 교란 변수를 통제하면서, 사전에 수집한 데이터에 통계적 과정을 적용하여 인과 관계를 추정하기도 한다
    - 다음과 같은 방법론이 있다
        - Difference in Differences (DD)
        - Causal Impact
        - Synthetic Control

# Dataset

- R `Synth` 라이브러리의 `Basque` 데이터를 사용한다
    - 스페인 바스크 지방의 테러 및 분쟁이 경제에 미친 영향을 추정한다
    - <https://www.rdocumentation.org/packages/Synth/versions/1.1-5/topics/basque>
    - 데이터는 다음과 같은 내용을 포함하고 있다
        - 1955~1997년 사이의 정보들
        - 스페인의 18개 지역에 대한 정보 (그 중 하나는 스페인 전체에 대한 정보)
        - 확인하고자 하는 연도(treatment year)는 1975년 이후
        - 확인하고자 하는 지역(treatment region)은 "Basque Country (Pais Vasco)"
        - 경제에 미친 영향은 "**GDP per capita"** 지표로 추정한다
- 저자의 분석 결과 (R)
    - <https://github.com/prasanna7/Causal_Inference/blob/master/Basque/Basque.Rmd>

# Methods

## (1) First Difference Estimate

- Difference in Differences 방법에 대해 알아보기 전에, First Difference가 무엇인지 살펴보자
- 우리의 목표는 바스크 지방에 테러가 일어난 이후 GDP에 얼마나 영향이 있었는지 추정하는 것이다
- 단순하게 접근해보면, first difference regression 을 구해서 추정해 볼 수 있다

다음은 바스크 지방의 GDP 추이를 나타낸 그래프다

- 테러 직후 수치가 급감했다가 이후 다시 상승하여 회복하고 있다
- 그렇다면 우리는 **테러로 인해 GDP가 얼마나 감소했는지,** 그 정도를 확인해보자

![](https://miro.medium.com/max/2800/1*NbWee0TF8zCfnnAyQw0RCw.png)

- **First difference estimate** 는 Treatment(여기서는 테러) 전후의 GDP 차이를 추정한다
- GDP를 종속 변수, pre/post 여부를 독립 변수로 놓고 First difference equation 을 구해보자

```r
# 필요한 라이브러리
library(tidyverse)
library(Synth)

# basque 데이터 불러오기
data(basque, package = 'Synth')

# 필요한 데이터만 추출 + 전처리
basque_clean <- basque %>% 
    as_tibble() %>% 
    select(regionno, regionname, year, gdpcap, invest) %>% 
    mutate(post = if_else(year > 1975, 1, 0),
            treat = if_else(regionname == 'Basque Country (Pais Vasco)', 1, 0),
            regionname = as.factor(regionname)) %>% 
    filter(regionno != 1)

# Linear Model을 이용해 First Difference 추정
model_first_diff <- lm(data = basque_clean %>% filter(treat == 1), gdpcap ~ post)

# 학습한 Linear Model을 요약한다
summary(model_first_diff)
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)    
# (Intercept)   5.3823     0.2515  21.399  < 2e-16 ***
# post          2.4844     0.3516   7.065 1.33e-08 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

- 우리는 감소하는 추세에 대한 정보를 얻고 싶은데, post 변수의 계수를 보면 단위 당 GDP가 2.5씩 상승하고 있다는 결과가 나온다
- GDP가 테러 뿐만 아니라 다양한 변수로부터 영향을 받아서 변화했기 때문이다
    - 이러한 변수를 교란 변수(Confounder) 라고 한다
    - 예를 들면, 내수나 GDP에 영향을 주는 법이 제정되거나 폭동이 발생했을 수 있고, 정부의 부패로 인한 것일 수도 있다
- 이러한 문제를 해결하기 위해서는 **테러의 영향을 받지 않은 대조군 지역이 필요하다**

## (2) Difference in differences (DD)

- DD 방법론은 **대조군의 추세가 실험군에서 처리효과를 제외한 추세를 간접적으로 나타낸다고** 가정한다
    - 또한 실험군과 대조군 **모두 pre-period 에서는 동일한 추세를 보인다고 가정한다**
    - 따라서 **기울기가 변화하는 정도의 차이가** 실제 효과를 의미한다
- 연도별 GDP 비율 차이가 가장 작은 지역을 계산하거나, 그래프로 확인한다
    - 카탈루냐(Cataluna) 지방이 가장 적합한 것으로 확인되어 대조군으로 사용한다

![](https://miro.medium.com/max/2800/1*AHwX3SDU08LxScY29sjdMQ.jpeg)

- GDP를 종속 변수로, treatment 여부와 pre/post 여부를 독립 변수로 하여 회귀 모형을 구성한다
- 두 독립 변수의 상호작용을 계산하여 post-period 에만 treatment 효과가 포함되도록 한다
- 회귀 모형을 학습해보면 다음과 같은 결과를 얻을 수 있다
    - interaction을 보면 테러의 개입으로 인해 단위 당 -0.85 의 효과를 보인다
    - First Difference 와는 다른 결과가 나온 것을 볼 수 있다

```r
# 바스크와 카탈루냐 지방의 데이터만 추출한다
basque_did <- basque_clean %>%
    filter(regionname %in% c('Basque Country (Pais Vasco)', 'Cataluna'))

# 회귀 모형을 학습한다
model_did <- lm(data = basque_did, gdpcap ~ treat * post)

# 학습 결과를 확인한다
summary(model_did)
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)    
# (Intercept)   5.2436     0.2657  19.735  < 2e-16 ***
# treat         0.1387     0.3758   0.369    0.713    
# post          3.3392     0.3715   8.989 7.56e-14 ***
# treat:post   -0.8547     0.5253  -1.627    0.108    
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

- DD 방법론에 관심이 있다면 다음 글을 참고해보자
    - <https://www.mailman.columbia.edu/research/population-health-methods/difference-difference-estimation>

## (3) CausalImpact

- `CausalImpact` 는 실험군의 인과적 효과를 추정하기 위해 구글에서 만든 방법론이다.
    - 공식문서 : [https://google.github.io/CausalImpact/CausalImpact.html](https://google.github.io/CausalImpact/CausalImpact.html)
- DD의 다음과 같은 한계점 때문에 방법론을 만들게 되었다고 한다
    - DD는 시간에 따라 변화하는 데이터를 사용하는데도 iid 가정(Independent and identically distributed)을 기반으로 하는 정적인 회귀 모형을 기반으로 한다
    - 대부분의 DD 분석은 개입 이전과 이후의 두 시점만 비교하지만, 실제로 분석할 때는 효과가 처음 등장할 때부터 사라질 때까지, 시간에 따른 변화를 고려해야 한다
- Idea
    - 대조군의 추세를 이용해서 실험군에 treatment가 존재하지 않았을 경우(일어나지 않은 일)의 추세를 예측하려고 한다
    - 예측한 추세(Counterfactual)와 실제 추세의 차이가 인과적 효과를 추정한 값이 된다
    - Bayesian structural time-series models 를 사용해서 관측한 데이터의 시간에 따른 변화를 설명한다
    - (다음에 다룰) **Synthetic Control 과 유사한 컨셉을** 가지고 있다
- R 코드를 통해 살펴보자
    - 모형의 결과 요약을 보면, **Absolute effect가 단위 당 -0.75** 라는 것을 볼 수 있다
    - 테러로 인해 1인당 GDP가 0.76 unit (비율로는 8.8%) 감소했다고 해석할 수 있다
    - DD 방법론으로 확인한 결과와 비슷한 수치가 나왔다

```r
# CausalImpact 함수가 원하는 형태로 데이터를 변환한다
basque_ci <- basque_clean %>%
    filter(regionname %in% c('Basque Country (Pais Vasco)', 'Cataluna')) %>% 
    mutate(date = as.Date(glue::glue('{year}-01-01'), format = '%Y-%m-%d')) %>% 
    select(date, regionname, gdpcap) %>% 
    pivot_wider(names_from = regionname, values_from = gdpcap) %>% 
    select(date, basque = `Basque Country (Pais Vasco)`, another = Cataluna)

# CausalImpact 모형을 학습한다
basque_impact <- CausalImpact::CausalImpact(
    data = basque_ci, 
    pre.period = as.Date(c('1955-01-01', '1975-01-01')), 
    post.period = as.Date(c('1976-01-01', '1997-01-01'))
)

# 학습 결과를 확인한다
summary(basque_impact)
# Posterior inference {CausalImpact}
# 
#                          Average         Cumulative    
# Actual                   7.9             173.1         
# Prediction (s.d.)        8.6 (0.31)      189.5 (6.91)  
# 95% CI                   [8, 9.2]        [176, 203.4]  
#                                                        
# Absolute effect (s.d.)   -0.75 (0.31)    -16.46 (6.91) 
# 95% CI                   [-1.4, -0.11]   [-30.4, -2.45]
#                                                        
# Relative effect (s.d.)   -8.7% (3.6%)    -8.7% (3.6%)  
# 95% CI                   [-16%, -1.3%]   [-16%, -1.3%] 
# 
# Posterior tail-area probability p:   0.01131
# Posterior prob. of a causal effect:  98.869%
# 
# For more details, type: summary(impact, "report")
```

- `CausalImpact` 에 대한 자세한 설명이 궁금하다면 방법론 저자의 글을 확인해보자
    - <https://storage.googleapis.com/pub-tools-public-publication-data/pdf/41854.pdf>

## (4) Synthetic Control

- Synthetic Control는 `CausalImpact` 와 비슷하게 대조군을 통해 실험군에 treatment가 없을 때를 가정한 데이터를 생성하는 방식으로 treatment 효과를 추정한다
    - 대조군의 GDP 추세와 여러 가지 공변량을 바탕으로, 실험군에 테러가 일어나지 않았을 경우를 가정했을 때의 GDP를 예측한다
    - 알고리즘을 통해 대조군의 다양한 변수에 적절한 가중치를 부여하여 일어나지 않은 상황을 추정한다
- Synthetic Control 과 CausalImpact 의 **차이점**
    - Synthetic Control 은 **pre-treatment 기간의 데이터만** 사용한다
    - CausalImpact는 **pre/post treatment 기간 모두의 데이터를** 사용한다

![](https://miro.medium.com/max/2800/1*uhzVrpNFmlIXFAw6gO-fJA.jpeg)

- R의 `Synth` 라이브러리에 구현되어 있다
    - 계산해보면 `RMSE = 0.57` 이 나온다
    - **테러로 인해 0.57 단위 GDP가 떨어졌다고** 해석할 수 있다

```r
library(Synth)

# Synthetic Control
basque_dataprep <- dataprep(
    foo = basque,
    predictors = c('school.illit','school.prim','school.med','school.high','school.post.high','invest'),
    predictors.op = 'mean',
    dependent = 'gdpcap',
    unit.variable = 'regionno',
    time.variable = 'year',
    special.predictors = list(
        list('gdpcap', 1960:1969, c('mean')),                            
        list('sec.agriculture', seq(1961,1969,2), c('mean')),
        list('sec.energy', seq(1961,1969,2), c('mean')),
        list('sec.industry', seq(1961,1969,2), c('mean')),
        list('sec.construction', seq(1961,1969,2), c('mean')),
        list('sec.services.venta', seq(1961,1969,2), c('mean')),
        list('sec.services.nonventa', seq(1961,1969,2), c('mean')),
        list('popdens', 1969, c('mean'))
    ),
    treatment.identifier = 17,
    controls.identifier = c(2:16, 18),
    time.predictors.prior = 1964:1969,
    time.optimize.ssr = 1960:1969,
    unit.names.variable = 'regionname',
    time.plot = 1955:1997
)

basque_synth = synth(basque_dataprep)

# 실제값과 예측값을 통해 RMSE를 계산한다
actual_gdp <- basque_dataprep$Y1plot
predicted_gdp <- basque_dataprep$Y0plot %*% basque_synth$solution.w
round(sqrt(mean((actual_gdp - predicted_gdp)^2)), 2)
# 0.57
```

# Comparison

- 각각의 방법론을 통해 **테러로 인해 변화한 1인당 GDP를** 추정해 본 결과는 다음과 같다
    - Difference in Differences = -0.85
    - CausalImpact = -0.76
    - Synthetic Control = -0.57
- 이 중에서 완벽한 정답이라 할 수 있는 것은 없다

# Some other useful techniques

- Propensity score matching
- Fixed effect Regression
- Instrumental variables
- Regression Discontinuity
