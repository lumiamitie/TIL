다음 포스팅을 정리하여 공유한다.

<https://solomonmessing.wordpress.com/2012/09/30/working-with-bipartiteaffiliation-network-data-in-r/>

# Bipartite/Affiliation Network Data

네트워크 형태의 데이터는 서로 다른 성질의 노드로 구성될 수 있다. (two-mode network data)

- 사람들과 그 사람들이 속한 그룹들
- 유저와 유저가 활동하고 있는 게시판/스레드

위와 같은 형태로 구성된 데이터 예제를 살펴보자. 

```r
library('tidyverse')

df <- data_frame(
  person = c('Sam','Sam','Sam','Greg','Tom','Tom','Tom','Mary','Mary'), 
  group = c('a','b','c','a','b','c','d','b','d')
)

df
# A tibble: 9 x 2
#   person group
#    <chr> <chr>
# 1    Sam     a
# 2    Sam     b
# 3    Sam     c
# 4   Greg     a
# 5    Tom     b
# 6    Tom     c
# 7    Tom     d
# 8   Mary     b
# 9   Mary     d
```

## Two-mode to One-mode conversion in R

위와 같은 데이터에서 사람들이 어떻게 직접 연결되어 있는지 궁금할 수 있다. 예를 들면, 같은 그룹의 속한 사람들을 연결해보고 싶다면 어떻게 해야 할까? 이런 경우에는 two-mode 네트워크를 one-mode 네트워크로 변환해야 한다.

two-mode의 incidence matrix를 one-mode의 adjacency matrix로 변환하기 위해서는 incidence matrix에 자기 자신의 전치행렬을 곱해주면 된다. incidence matrix는 0과 1로 구성되어 있기 때문에, 대각선상의 원소를 제외한 나머지 값들이 두 사람 사이에 공통적으로 존재하는 그룹을 나타내게 된다. 

```r
m <- df %>% table %>% as.matrix()

m
#       group
# person a b c d
#   Greg 1 0 0 0
#   Mary 0 1 0 1
#   Sam  1 1 1 0
#   Tom  0 1 1 1

m %*% t(m)
#       person
# person Greg Mary Sam Tom
#   Greg    1    0   1   0
#   Mary    0    2   1   2
#   Sam     1    1   3   2
#   Tom     0    2   2   3
```

`network`나 `sna` 라이브러리를 사용한다면 `as.matrix()`, `igraph` 라이브러리를 사용한다면 `get.adjacency()` 함수를 통해 위와 같은 네트워크 객체를 만들 수 있다. 

하지만 대용량 데이터를 다룬다면 어떻게 될까? 네트워크 데이터는 대체로 희소(sparse)하다. 연결된 노드보다 연결되지 않은 노드가 훨씬 많다. 그렇기 때문에 edgelist 형태로 데이터를 저장하는 방식을 선호한다. 여기서는 R의 행렬 관련 기능을 활용해보자. 

- `person` 열을 i 인덱스에 두고 (행렬의 행을 구성한다)
- `group` 열을 j 인덱스에 둔다 (행렬의 열)
- 연결되어 있는 경우 1을 표기한다

```r
sparse_m <- Matrix::spMatrix(
  nrow = length(unique(df$person)),
  ncol = length(unique(df$group)),
  i = as.numeric(factor(df$person)),
  j = as.numeric(factor(df$group)),
  x = rep(1, length(df$person))
)
row.names(sparse_m) <- levels(factor(df$person))
colnames(sparse_m) <- levels(factor(df$group))

sparse_m
# 4 x 4 sparse Matrix of class "dgTMatrix"
#      a b c d
# Greg 1 . . .
# Mary . 1 . 1
# Sam  1 1 1 .
# Tom  . 1 1 1
```

Row간의 (위 예제에서는 person) 연결관계에 대한 one-mode 표현을 보기 위해서는 원래의 행렬에 전치행렬을 곱하면 된다. 

```r
sparse_m %*% Matrix::t(sparse_m)
# 4 x 4 sparse Matrix of class "dgCMatrix"
#      Greg Mary Sam Tom
# Greg    1    .   1   .
# Mary    .    2   1   2
# Sam     1    1   3   2
# Tom     .    2   2   3
```

하지만 더 좋은 방법이 있다. `Matrix::tcrossprod()` 함수는 더 빠르고 효율적으로 계산한다.

```r
sparse_m_row = Matrix::tcrossprod(sparse_m)
# 4 x 4 sparse Matrix of class "dsCMatrix"
#      Greg Mary Sam Tom
# Greg    1    .   1   .
# Mary    .    2   1   2
# Sam     1    1   3   2
# Tom     .    2   2   3
```

`sparse_m_row` 는 row 항목들로 구성된 one-mode 행렬을 표현한다. 같은 그룹에 속한 사람들을 나타낸다. 

Column 항목에 대한 one-mode 표현은 다음과 같이 계산할 수 있다

```r
Matrix::t(sparse_m) %*% sparse_m
# 4 x 4 sparse Matrix of class "dgCMatrix"
#   a b c d
# a 2 1 1 .
# b 1 3 2 2
# c 1 2 2 1
# d . 2 1 2

sparse_m_col = sparse_m %>% 
  Matrix::t() %>% 
  Matrix::tcrossprod()
# 4 x 4 sparse Matrix of class "dsCMatrix"
#   a b c d
# a 2 1 1 .
# b 1 3 2 2
# c 1 2 2 1
# d . 2 1 2
```

여기서는 굉장히 작은 네트워크를 다루었지만, 위 방식은 거대한 네트워크 데이터로도 확장할 수 있다.

## Two-mode 데이터 분석하기 : Mobility Model

실제 데이터를 가지고 살펴보자. 3년간의 학생 방과후 활동에 대한 정보를 분석하려고 한다. 학생과 학생들이 속한 단체에 대한 정보로 구성되어 있다.

[참고](http://www.stat.cmu.edu/~brian/780/stanford%20social%20network%20labs/05%20Affiliation%20Data%20and%20Network%20Mobility/lab_5.R)

```r
magact96 = read_tsv("http://sna.stanford.edu/sna_R_labs/data/mag_act96.txt", na = "na")
magact97 = read_tsv("http://sna.stanford.edu/sna_R_labs/data/mag_act97.txt", na = "na")
magact98 = read_tsv("http://sna.stanford.edu/sna_R_labs/data/mag_act98.txt", na = "na")
```

