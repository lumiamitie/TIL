# walker 라이브러리를 사용한 time-varying coefficients model 학습하기

라이브러리 공식 문서의 내용을 간단히 정리한다.

[Efficient Bayesian generalized linear models with time-varying coefficients](https://cran.r-project.org/web/packages/walker/vignettes/walker.html)

```r
library(zeallot)
library(walker)

generate_variables <- function(n, seed = 123) {
  # Random Walk와 2개의 입력변수로 생성되는 값을 시뮬레이션한다
  set.seed(seed)
  beta1 <- cumsum(c(0.5, rnorm(n - 1, 0, sd = 0.05)))
  beta2 <- cumsum(c(-1, rnorm(n - 1, 0, sd = 0.15)))
  x1 <- rnorm(n, mean = 2)
  x2 <- cos(1:n)
  rw <- cumsum(rnorm(n, 0, 0.5))
  signal <- rw + beta1 * x1 + beta2 * x2
  y <- rnorm(n, signal, 0.5)
  
  list(
    beta1 = beta1,
    beta2 = beta2,
    x1 = x1,
    x2 = x2,
    rw = rw,
    signal = signal,
    y = y
  )
}

# 100개의 시뮬레이션 값을 생성한다
c(beta1, beta2, x1, x2, rw, signal, y) %<-% generate_variables(100)
```

이제 모형을 학습한다. 공식 문서가 작성된 이후에 sigma 파라미터를 입력하는 기준이 변경된 것으로 보인다.


```r
# 모형을 학습한다
vc_fit <- walker(
  y ~ -1 + rw1(~ x1 + x2, beta = c(0, 10), sigma = c(2, 1e-04)), 
  refresh = 0, 
  chains = 2, 
  seed = 123
)
```

`walker` 는 내부적으로 stan을 사용하고 있기 때문에, 학습결과가 stanfit 객체로 반환된다.
따라서 stanfit 객체를 사용할 수 있는 다른 라이브러리와 함께 사용할 수 있다.

```r
# 학습된 모형 객체를 출력해보면 대략적인 정보를 확인할 수 있다
vc_fit
# Inference for Stan model: walker_lm.
# 2 chains, each with iter=2000; warmup=1000; thin=1; 
# post-warmup draws per chain=1000, total post-warmup draws=2000.
# 
#                 mean se_mean   sd    2.5%     25%     50%     75%   97.5% n_eff Rhat
# sigma_y         0.60    0.00 0.08    0.44    0.54    0.60    0.65    0.76  1287    1
# sigma_rw1[1]    0.36    0.00 0.09    0.20    0.30    0.36    0.42    0.56  1345    1
# sigma_rw1[2]    0.05    0.00 0.03    0.01    0.02    0.04    0.06    0.13  1733    1
# sigma_rw1[3]    0.15    0.00 0.06    0.06    0.11    0.14    0.19    0.28  1809    1
# lp__         -158.61    0.06 1.53 -162.47 -159.33 -158.30 -157.55 -156.70   701    1
# 
# Samples were drawn using NUTS(diag_e) at Sat Feb 13 23:55:07 2021.
# For each parameter, n_eff is a crude measure of effective sample size,
# and Rhat is the potential scale reduction factor on split chains (at 
# convergence, Rhat=1).

# $stanfit 프로퍼티에 실제 stanfit 객체가 저장되어 있기 때문에 다른 관련 라이브러리와 함께 사용할 수 있다
print(vc_fit$stanfit, pars = c('sigma_y', 'sigma_rw1'))
# Inference for Stan model: walker_lm.
# 2 chains, each with iter=2000; warmup=1000; thin=1; 
# post-warmup draws per chain=1000, total post-warmup draws=2000.
# 
#              mean se_mean   sd 2.5%  25%  50%  75% 97.5% n_eff Rhat
# sigma_y      0.60       0 0.08 0.44 0.54 0.60 0.65  0.76  1287    1
# sigma_rw1[1] 0.36       0 0.09 0.20 0.30 0.36 0.42  0.56  1345    1
# sigma_rw1[2] 0.05       0 0.03 0.01 0.02 0.04 0.06  0.13  1733    1
# sigma_rw1[3] 0.15       0 0.06 0.06 0.11 0.14 0.19  0.28  1809    1
# 
# Samples were drawn using NUTS(diag_e) at Sat Feb 13 23:55:07 2021.
# For each parameter, n_eff is a crude measure of effective sample size,
# and Rhat is the potential scale reduction factor on split chains (at 
# convergence, Rhat=1).
```
