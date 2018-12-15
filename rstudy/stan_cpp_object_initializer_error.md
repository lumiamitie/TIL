# 문제상황

* R에서 Stan을 사용해 모델링하려고 하는데 다음과 같은 에러가 발생함
    * could not find function "cpp_object_initializer"

```r
model_result = rstan::stan(
  model_code = model_str,
  data = list(
    N = 150,
    P = 4,
    Y = scale(as.matrix(iris[, 1:4])),
    D = 2
  ),
  pars = c('L','psi','sigma_psi','mu_psi','sigma_lt','mu_lt'), 
  cores = 2, chains = 2, iter = 1000
)

Error in cpp_object_initializer(.self, .refClassDef, ...) : 
  could not find function "cpp_object_initializer"
failed to create the sampler; sampling not done
```

# 해결방법

* rstan::stan 으로 호출하는 대신 library('rstan') 으로 네임스페이스 attach 하여 해결
* https://github.com/stan-dev/rstan/issues/353
    * library('rstan') 으로 attach 하지 않을 경우 발생할 수 있는 에러라고 한다....
