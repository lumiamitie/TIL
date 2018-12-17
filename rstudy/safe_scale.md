# 0/0 케이스에 scale 적용하기

아래와 같이 한 열이 전부 0일 경우, 평균이 0이고 표준편차 또한 0이 되기 때문에 정규화를 시킬 경우 0/0이 계산된다.
따라서 두 번째 열이 전부 NaN으로 변하는 사태가 발생한다.

```r
sample_matrix = matrix(c(1:3, rep(0, 3), 1:3), 3, 3)
#      [,1] [,2] [,3]
# [1,]    1    0    1
# [2,]    2    0    2
# [3,]    3    0    3

scaled_matrix = scale(sample_matrix)
#      [,1] [,2] [,3]
# [1,]   -1  NaN   -1
# [2,]    0  NaN    0
# [3,]    1  NaN    1
# attr(,"scaled:center")
# [1] 2 0 2
# attr(,"scaled:scale")
# [1] 1 0 1
```

일단 nan이 발생하는 인덱스를 전부 0으로 치환하는 방법으로 해결. 분명 더 깔끔한 방식이 있을 것 같은데..

```r
safe_scale = function(mat) {
  scaled_mat = scale(mat)
  scaled_mat[is.nan(scaled_mat)] = 0
  return(scaled_mat)
}

safe_scale(sample_matrix)
#      [,1] [,2] [,3]
# [1,]   -1    0   -1
# [2,]    0    0    0
# [3,]    1    0    1
# attr(,"scaled:center")
# [1] 2 0 2
# attr(,"scaled:scale")
# [1] 1 0 1
```
