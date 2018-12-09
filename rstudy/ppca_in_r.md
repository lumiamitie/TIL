# Probabilistic PCA를 구현해보자

## EM을 통해 PCA 구현해보기

다음 논문 참고하여 정리하였다. [EM algorithms for PCA and sPCA](https://papers.nips.cc/paper/1398-em-algorithms-for-pca-and-spca.pdf)

PCA는 Linear Gaussian 모형의 특수한 경우다.
Linear Gaussian 모형 `y = Cx + v` 에서, 노이즈 v의 공분산이 매우 작고 모든 방향으로 동일하다는 제약이 추가되었다.
PCA는 명시적인 해가 존재하지만 EM을 통해 학습시키는 방법도 존재한다.

```
X : k x n matrix of the unknown states
Y : p x n matrix of all the observed data
C : Columns of C will span the space of the first k principal components

E-step : X = (CtC)^-1 * Ct * Y
M-step : Cnew = Y * Xt * (XXt)^-1
```

논문에 정의된 X, Y는 현재 우리가 사용하고 있는 데이터와는 달리 각각의 열이 관측치이다.
따라서 transpose 시키고 논문대로 작성해보자

```r
# 데이터프레임을 행렬로 변환
iris_mat = as.matrix(iris[, 1:4])
N_ROW = nrow(iris_mat)
N_COL = ncol(iris_mat)

# 주성분은 두 개 추출
N_PC = 2

# 평균이 0이 되도록 해야 한다
original_mat = apply(iris_mat, 2, function(x) x - mean(x))

# Loading Matrix의 초기값을 설정한다
C = matrix(data = rnorm(N_PC * N_COL),
           nrow = N_COL,
           ncol = N_PC,
           dimnames = list(colnames(original_mat)))

# EM
while (count < 10000) {
  # E-step
  X = t( solve(t(C) %*% C) %*% t(C) %*% t(original_mat) )
  # M-step
  C = t(original_mat) %*% X %*% solve(t(X) %*% X)
  count = count + 1
}

# 이제 여기서 학습시킨 C의 열들이 k개 주성분 공간으로 span된다
orth_weight = svd(C)$u
vecs = eigen(cov(original_mat %*% orth_weight))$vectors

#### 최종 결과 ####
# (1) Loading Matrix (original space를 latent space에 맵핑하기 위한 weight)
result_weight = orth_C %*% vecs
#             [,1]        [,2]
# [1,]  0.36138659  0.65658877
# [2,] -0.08452251  0.73016143
# [3,]  0.85667061 -0.17337266
# [4,]  0.35828920 -0.07548102

# (2) Score Matrix (원본 데이터를 latent space에 맵핑한 결과)
result_scores = original_mat %*% result_weight
```

## (작성중..) Probabilistic PCA

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
