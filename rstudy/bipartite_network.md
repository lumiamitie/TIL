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
