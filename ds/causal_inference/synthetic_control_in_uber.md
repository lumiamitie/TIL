# Uber's Synthetic Control

- **Uber's Synthetic Control Experimentation Framework When A/B Tests are Not Possible**
- PyData Amsterdam 2019 (Nick Jones, Sam Barrows)
- <https://youtu.be/j5DoJV5S2Ao>

# Overview

- Cases when A/B testing is not possible
- Alternatives to A/B testing
- Synthetic control at Uber
    - Model developed by our Marketplace team

# Motivating Example: Cash Trips at Uber

## Cash Trips at Uber

- 원래는 현금 결제를 크게 고려하지 않았지만 중남미와 인도 시장에 진출하게 되면서 시작하게 됨
- 현금 결제를 가능하게 하면서 시장을 더 확대시킬 수 있었지만, 그에 따른 문제점들이 생겨남
    - 거스름돈을 어떻게 해야 할까? (드라이버가 거스름돈이 부족하다면?)
    - 드라이버는 우버에 서비스 이용료를 어떻게 지불해야 할까?

## Experiment: Tell Drivers if a Trips is Cash

- Some drivers don't like cash trips, for example because they don't like to deal with change
- Build a feature to tell drivers whether a trip is cash when they get the trip request
    - Says "Cash" if a trip is cash, and nothing is a trip is not cash
- We want to test whether if affects metrics like trip acceptance rates, and how much unpaid service fees drivers had to deal with

---

- 원래는 새로 만든 기능에 A/B를 적용하고 싶었다
- A/B 테스트를 하려면 사용자를 임의로 나눌 수 있어야 한다

## Why an A/B Test Doesn't Work Here

- **Spillover effects** : treatment applied to one group affects the other group
    - Turns out drivers preferred cash trips → declined more credit card trips
    - Control group received those trips that the treatment group declined
- Leads to **biased result**
    - Treatment group accepted more cash, declined more credit card trips → more unpaid service fees
    - Drivers in control group receive those declined digital trips, so their unpaid service fees are lower than they would be without the experiment

# So What do we do instead of A/B?

- **Before and After** : 실험 전과 후를 비교한다
    - 대조군이 없기 때문에 유효한 검증 방법이 아니다
    - 실험 외적인 요소가 피실험자들에게 미칠 수 있는 영향을 통제할 수 없다
- **Switchbacks**
    - 동일한 도시의 모든 사용자에 대해 실험 여부를 계속 변경한다
    - 유저들이 실제로 보게 되는 화면에는 이 방식을 적용하기 어렵다
    - 서비스의 뒷 단에서 돌아가는 알고리즘을 테스트하기 좋은 방법
- **Difference-in-Differences**
    - 한 도시에서 사용자를 나누기 어렵다면 두 도시를 비교하는 방법도 있다
    - 두 도시의 경향이 비슷할 것이라고 가정한다
    - 두 도시 각각의 고유한 효과와 시간에 따른 변화(실험의 효과)를 분리하여 비교한다
    - 경제학에서 오랫동안 널리 사용되어 온 방법이다
    - "두 도시의 경향이 비슷할 것"이라는 가정을 확인하기 어렵다는 문제가 있다
- 이러한 문제로 인해 **Synthetic Control** 을 사용한다

## An A/B Alternative: Synthetic Control

- Main Idea
    - Start of Treatment (Imaginary date)
    - "Synthetic" City : What would have happened without experiment
    - Treatment City : What we actually observed
    - Treatment Effect = difference between Synthetic City and Treatment City

---

- 실험을 하지 않는다면 어떻게 될지 설명하는 모형을 만든다
    - 실험 시작하기 이전의 데이터로 이후의 데이터를 예측한다
    - 예측한 값과 실제 데이터의 차이로 실험의 효과를 추정한다
- 그렇다면 어떻게 예측할 수 있을까?

# The Model

## How do we form our synthetics?

1. **Data**
    - Control City Data
    - Treatment City Patterns in Previous Years
    - Treatment City Data in Control Period
    - Weather & Event Data
2. **Synthetic Control Algorithm**
3. **Synthetic "Counterfactual" City in Treatment Period**

- Synthetic Model
    - What we're trying to predict : An outcome of interest in Sao Paulo (Special cash trips for a driver)
    - Fitting the model on data from training period (Pre-treatment period)
        - Fit a loss function that minimize the difference between our prediction for the outcome in Sao Paulo and the outcome that we actually observe in Sao Paulo in that pre-treatment period

---

- 데이터
    - 우선 실험하고자 하는 도시의 이전 데이터가 필요하다
    - 날씨, 휴일 등 고려해야 하는 정보를 확인한다

## How do we estimate treatment effect?

- Estimate of the treatment effects (on any given day)
    - = the difference between what we actually observe in Sao Paulo and what we predicted from our model in Sao Paulo
    - using those features that we talked about earlier and the covariance that we fitted from the pre-treatment period
    - This is about an average treatment effect (not on any particular day)

# Synthetic Control Performance

## It Actually works!

- Using synthetic control we've been able to model some surprisingly irregular time series

# Implementation At Scale

## Synthetic Control at Uber scale

- Precise counterfactual models
    - We have built Spark infrastructure to **select hyperparameters that minimize our prediction bias and RMSE on a sliding window of "placebo" data** in many cities and time periods
    - We build and test over **120000 models** (100 cities x 10 metrics x 120 days) and train parameters in a matter of minutes!

# Other Synthetic Control use cases at Uber

## Other Use Cases at Uber

- Synthetic Control has been used at Uber for evaluating the impact of a variety of large initiatives
    - Driver surge (탄력 요금제)
        - Improvements to the surge pricing algorithm
    - Uber eats
    - UberPool (카풀)
        - Changes to core driver-rider matching algorithm

---

- UberPool 에서 매칭 알고리즘을 테스트하는데 synthetic control을 사용했다
    - 사용자가 화면으로 확인할 수 있는 변화는 아니지만, 알고리즘이 변하면 사용성에 큰 영향을 미치기 때문에 switchback을 사용할 수 없었다
- surge pricing 알고리즘을 테스트할 때도, switchback이 종종 더 나은 성능을 보이긴 하지만 사용자가 알고리즘이 테스트 중이라는 것을 눈치채면 spillover effect가 발생할 우려가 있기 때문에 synthetic control을 사용했다

# Potential Drawbacks

## Limitations of Synthetic Control

- Exogenous shocks can still invalidate results
- Difficult to detect small effects
- Can't dig into user level heterogeneous effects
- Potential to manipulate results without strict pre-registration
    - There is a danger of manipulating or picking results until you get something that looks reasonable

# Takeaways

- **Sometimes A/B Testing is not possible**, particularly in a marketplace
- **Synthetic control** has become a popular alternative
- **Performs well** and we have found **many use cases** at Uber
- But be careful - like all methods, **has drawbacks**
