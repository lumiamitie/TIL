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

# 주성분은 두 개 추출
N_PC = 2

# 평균이 0이 되도록 해야 한다
iris_mat_centered = apply(iris_mat, 2, function(x) x - mean(x))

# Random Matrix를 구성한다
C = t(iris_mat[sample(N_ROW)[1:N_PC], , drop = FALSE])
C = matrix(rnorm(C), nrow(C), ncol(C), dimnames = labels(C))
```

To Be Continued
