# bayesAB 라이브러리를 이용해 간단한 MAB 시스템 만들기

- `bayesAB` 라이브러리는 베이지안 모형을 바탕으로 AB 테스트 결과를 쉽게 분석할 수 있게 해주는 라이브러리다.
- 추가적으로 쉽게 MAB를 구현할 수 있는 `banditize` 까지 사용해보자.

## 베이지안 모형 학습하기

- bandit 객체를 생성하기 전에 데이터를 학습한다.

```r
library(bayesAB)

# 일반적인 A/B 테스트 상황을 가정하여 샘플 데이터를 생성한다.
A_binom <- rbinom(100, 1, .5)
B_binom <- rbinom(100, 1, .6)

# 생성된 데이터를 바탕으로 베이지안 모형을 학습한다.
AB1 <- bayesTest(
  A_binom, 
  B_binom, 
  priors = c('alpha' = 1, 'beta' = 1), 
  distribution = 'bernoulli'
)
```

## Bandit 생성하기

- 학습한 데이터를 바탕으로 MAB를 위한 Bandit 객체를 생성할 수 있다.

```r
# bayesTest 객체를 바탕으로 빠르게 MAB를 제공할 수 있도록 Bandit 객체를 생성한다.
binomialBandit <- banditize(AB1)

#### Bandit Object methods ####
# 데이터를 추가한다
binomialBandit$setResults(list(A = 1))
binomialBandit$setResults(list(B = 0))
# 데이터를 한꺼번에 추가할 수도 있다
binomialBandit$setResults(list(A = c(1, 0, 1, 0, 0), B = c(0, 0, 0, 0, 1)))

# bandit이 실행되기 전 A/B 테스트 결과를 확인한다
binomialBandit$getOriginalTest() 

# 현재 데이터를 바탕으로 A/B안 중 하나를 샘플링한다
binomialBandit$serveRecipe() 

# 추가된 데이터의 정보를 확인한다
binomialBandit$getUpdates()
```

## Deploying MAB

- Bandit 객체를 쉽게 생성할 수 있도록 `deployBandit` 을 적용할 수 있다.
- `plumber` 라이브러리를 통해 API 서버를 제공하므로, plumber가 설치되어 있어야 한다.
    - plubmer를 사용하므로 swagger UI 페이지가 함께 제공된다.
- 다음과 같은 2개의 API가 제공된다.
    - **GET** `/serveRecipe`
    - **POST** `/setResults`

```r
# MAB JSON API를 제공한다
deployBandit(binomialBandit, port = 8000)
```
