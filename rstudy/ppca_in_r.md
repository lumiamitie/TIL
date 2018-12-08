# Probabilistic PCA를 구현해보자

다음 구현을 참고하여 작업!

<https://github.com/hredestig/pcaMethods/blob/master/R/ppca.R>

x를 D 차원의 관찰값이라고 할 때 우리가 구하고자 하는 것은 다음과 같다

```
x = Wz + mu + e

* z는 M차원의 가우시안 잠재변수
* e는 평균이 0이고 분산이 sigma^2인 가우시안 분포를 따르는 D차원의 노이즈
```

```r
# 데이터프레임을 행렬로 변환
iris_mat = as.matrix(iris[, 1:4])
N_ROW = dim(iris_mat)[1]
N_COL = dim(iris_mat)[2]

# Missing Value가 있다면 우선 0으로 채운다
index_na = which(is.na(iris_mat))
is_missing = length(index_na)

# 주성분은 두 개 추출
N_PC = 2

# 평균이 0이 되도록 해야 한다
iris_mat_centered = apply(iris_mat, 2, function(x) x - mean(x))

# Initial Random Matrix를 구성한다
# C = t(iris_mat[sample(N_ROW, N_PC), ,drop = FALSE])
# C = matrix(rnorm(C), nrow(C), ncol(C), dimnames = labels(C))

# 여기가 latent space를 구성하는 부분인 것 같다
C = matrix(rnorm(N_ROW * N_COL), N_COL, N_PC, 
           dimnames = list(colnames(iris_mat_centered)))
CtC = t(C) %*% C

# 
X = iris_mat_centered %*% C %*% solve(t(C) %*% C)
reconstruction = X %*% t(C)

# ss를 최소화하는 C를 찾는건가?
ss = sum((reconstruction - iris_mat_centered)^2) / (N_COL * N_ROW)

#### EM ####
# (1) Setting
# temp values
count = 1
old_objective = Inf
threshold = 1e-5
max_iterations = 1000

while(count) {
  # Covariance
  Sx = solve(diag(N_PC) + (t(C) %*% C / ss))
  ss_old = ss
  
  # Missing Value가 있을 경우, Projection 결과인 X %*% t(C) 의 해당 위치 값을 대신 사용
  if (is_missing) iris_mat_centered[index_na] = (X %*% t(C))[index_na]
  
  # (2) E Step : E(z), E(zz')
  # Expected Value
  X = iris_mat_centered %*% C %*% Sx/ss
  
  # (3) M Step : W, sigma^2
  XtX = t(X) %*% X
  C = (t(iris_mat_centered) %*% X) %*% solve((XtX + N_ROW*Sx))
  CtC = t(C) %*% C
  
  ss = (sum( (C %*% t(X) - t(iris_mat_centered))^2 ) + 
        (N_ROW * sum(CtC %*% Sx)) + 
        (is_missing * ss_old)
       ) / (N_ROW * N_COL)
  
  objective = N_ROW * (N_COL * log(ss) + sum(diag(Sx)) - log(det(Sx))) +
    sum(diag(XtX)) -
    (is_missing * ss_old)
  
  relative_changes = abs(1 - objective / old_objective)
  old_objective = objective
  count = count + 1
  
  if (relative_changes < threshold & count > 5) {
    count = 0
  } else if (count > max_iterations) {
    count = 0
    warning('Stopped after max iterations, but relative_changes > threshold')
  }
}
```

To Be Continued
