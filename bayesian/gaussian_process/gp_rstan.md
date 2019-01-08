# Gaussian Process in rstan

[다음 포스팅](https://betanalpha.github.io/assets/case_studies/gp_part1/part1.html)에서
간단히 필요한 부분만 정리할 예정

```r
library('tidyverse')
library('rstan')

# To avoid recompilation of unchanged Stan programs
rstan_options(auto_write = TRUE)

# Stan Code
basic_gp_model = "
data {
  int<lower=1> N;
  real x[N];

  real<lower=0> rho;
  real<lower=0> alpha;
  real<lower=0> sigma;
}
transformed data {
  matrix[N,N] cov = cov_exp_quad(x, alpha, rho) + diag_matrix(rep_vector(1e-10, N));
  matrix[N,N] L_cov = cholesky_decompose(cov);
}
parameters {}
model {}
generated quantities {
  vector[N] f = multi_normal_cholesky_rng(rep_vector(0, N), L_cov);
  vector[N] y;
  for (n in 1:N)
    y[n] = normal_rng(f[n], sigma);
}
"

alpha_true = 3
rho_true = 5.5
sigma_true = 2

N_total = 501
x_total = 20 * (0:(N_total - 1)) / (N_total - 1) - 10

simulate_data = list(
  alpha = alpha_true,
  rho = rho_true,
  sigma = sigma_true,
  N = N_total,
  x = x_total
)

# Sampling from Gaussian Process
simulate_fit = stan(model_code = basic_gp_model,
                    data = simulate_data,
                    iter = 1,
                    chains = 1,
                    seed = 1,
                    algorithm = 'Fixed_param')

# 총 501개의 샘플에서 균일하게 추출한 11개를 관측치라고 생각해보자
f_total = rstan::extract(simulate_fit)$f[1,]
y_total = rstan::extract(simulate_fit)$y[1,]
```
