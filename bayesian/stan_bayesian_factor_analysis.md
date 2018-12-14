# Bayesian Factor Analysis

Stan을 이용해 Bayesian 스타일로 Factor Analysis를 적용해보자!

다음 [포스팅](https://rfarouni.github.io/assets/projects/BayesianFactorAnalysis/BayesianFactorAnalysis.html) 의 Stan 코드를 참고하여 rstan을 통해 작업했다.

다음과 같이 두 가지 방식으로 학습하는 코드를 각각 작성하는 것이 목표!

- (1) 원본 데이터로부터 학습하기
- (2) 상관관계 행렬로부터 학습하기

## (1) 원본 데이터로부터 학습하기

### Stan Code

```r
model_str = "
  data {
    int<lower=1> N;  // Row
    int<lower=1> P;  // Column
    matrix[N, P] Y;  // Data
    int<lower=1> D;  // Latent Dimension 개수
  }
  transformed data {
    int<lower=1> M;
    vector[P] mu;
    M = D * (P-D) + D * (D-1)/2;  // Non-Zero Loadings 개수
    mu = rep_vector(0.0, P);
  }
  parameters {
    vector[M] L_t;           // lower triangular elements of L
    vector<lower=0>[D] L_d;  // lower diagonal elements of L
    vector<lower=0>[P] psi;  // Vector of Variances
    real<lower=0> mu_psi;
    real<lower=0> sigma_psi;
    real mu_lt;
    real<lower=0> sigma_lt;
  }
  transformed parameters {
    cholesky_factor_cov[P, D] L;  // Factor Loadings Matrix (lower triangular matrix)
    cov_matrix[P] Q;  // Covariance Matrix
    {
      int idx = 1;
      real zero = 0;

      for (i in 1:P) {
        for (j in (i+1):D) {
          L[i, j] = zero;  // Upper Triangular Elements는 0으로 고정
        }
      }

      for (j in 1:D) {
        L[j, j] = L_d[j];
        for (i in (j+1):P) {
          L[i, j] = L_t[idx];
          idx = idx + 1;
        }
      }
    }
    Q = L*L' + diag_matrix(psi);
  }
  model {
    // Hyperpriors
    mu_psi ~ cauchy(0, 1);
    sigma_psi ~ cauchy(0, 1);
    mu_lt ~ cauchy(0, 1);
    sigma_lt ~ cauchy(0, 1);

    // Priors
    L_d ~ cauchy(0, 3);
    L_t ~ cauchy(mu_lt, sigma_lt);
    psi ~ cauchy(mu_psi, sigma_psi);

    // Likelihood
    for (j in 1:N)
      Y[j] ~ multi_normal(mu, Q);
  }"
```

### Stan 컴파일 + 샘플링

```r

library('rstan')
library('purrr')

model_result = rstan::stan(
  model_code = model_str,
  data = list(
    N = 150,
    P = 4,
    # normalization 하고 넣어야 psych::fa 와 비슷해진다
    Y = scale(as.matrix(iris[, 1:4])),
    D = 2
  ),
  pars = c('L','psi','sigma_psi','mu_psi','sigma_lt','mu_lt'),
  # seed = 11, # 필요한 경우 Random Seed 값 지정
  cores = min(4, parallel::detectCores()),
  chains = min(4, parallel::detectCores()),
  iter = 2000
)
```

### 샘플링 결과 확인

```r
# Sampling 결과 추출
model_samples = rstan::extract(model_result)

# Sample psi의 평균 계산
model_psi = apply(model_samples$psi, 2, function(x) mean(x))

# Sample Loading의 평균을 계산
n_iter_wo_warmup = dim(model_samples$L)[1]
model_loadings = seq_len(n_iter_wo_warmup) %>%
  purrr::map(~ model_samples$L[.x,,]) %>%
  purrr::reduce(~ .x + .y) %>%
  magrittr::divide_by(n_iter_wo_warmup)


# 아래 FA 결과와 비슷하게 나오는 것을 볼 수 있다!
model_loadings
#            [,1]       [,2]
# [1,]  0.9263893  0.0000000
# [2,] -0.1286887  0.9381479
# [3,]  0.9426873 -0.3340463
# [4,]  0.9202184 -0.2844980
```

### psych 결과와 비교해보자

```r
# resmin + varimax 로 FA 학습
fa_iris = psych::fa(as.matrix(iris[,1:4]), nfactors = 2, rotate = 'varimax')

# Loading Matrix
fa_iris$loadings
# Loadings:
#                 MR1    MR2   
# Sepal.Length  0.901       
# Sepal.Width  -0.145  0.973
# Petal.Length  0.962 -0.294
# Petal.Width   0.919 -0.242
#
#                  MR1   MR2
# SS loadings    2.602 1.093
# Proportion Var 0.651 0.273
# Cumulative Var 0.651 0.924
```
