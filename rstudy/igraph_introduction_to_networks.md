Datacamp의 **Network Analysis in R** 강의 듣고 정리

# 1. Introduction to networks

## Data Structure

네트워크 데이터를 표현하는 두 가지 자료 구조

- Adjacency Matrix
- Edgelist

`igraph` 라이브러리를 사용하여 분석 진행

## igraph object

```r
# 데이터프레임을 행렬로 변환
friends.mat <- as.matrix(friends)

# igraph 객체로 변환
g <- graph.edgelist(friends.mat, directed = FALSE)

# 그래프 시각화
plot(g)
```

### Counting vertices and edges

```r
# Edges 개수 세기
gsize(g)

# Vertices 개수 세기
gorder(g)
```

## attributes

### Node attributes 

```r
# node에 'gender' attributes 추가하기
g <- set_vertex_attr(g, "gender", value = genders)

# node에 'age' attributes 추가하기
g <- set_vertex_attr(g, "age", value = ages)

# 모든 node attributes를 리스트 형태로 확인하기
vertex_attr(g)

# 처음 5개 vertices를 데이터프레임 형태로 확인하기
V(g)[[1:5]]
```

### Edge attributes 

```r
# edge에 'hours' attributes 추가하기
g <- set_edge_attr(g, 'hours', value = hours)

# 모든 edge attributes를 리스트 형태로 확인하기
edge_attr(g)

# 'Britt' 이라는 node를 포함하는 edge로 필터링하기
E(g)[[inc('Britt')]]

# hours attributes 값이 4 이상인 edge로 필터링하기
E(g)[[hours>=4]]
```

### Visualizing attributes

```r
g1 <- graph_from_data_frame(
    # d: 네트워크의 모든 edge (attributes 포함)
    # vertices: 네트워크의 모든 vertices (attributes 포함)
    d = friends1_edges, 
    vertices = friends1_nodes, 
    directed = FALSE
)

# gender 값에 따라 노드 색상 조정
V(g1)$color <- ifelse(V(g1)$gender == "F", "orange", "dodgerblue")

# 그래프 그리기
plot(g1, vertex.label.color = "black")
```

## Network Visualization Principles

### network layouts

```r
library(igraph)

# Circle layout
plot(g1, vertex.label.color = "black", layout = layout_in_circle(g1))

# Fruchterman-Reingold layout 
plot(g1, vertex.label.color = "black", layout = layout_with_fr(g1))

# Tree layout 
m <- layout_as_tree(g1)
plot(g1, vertex.label.color = "black", layout = m)

# layout_nicely()은 데이터에 가장 적합한 layout을 찾아서 반영한다
m1 <- layout_nicely(g1)
plot(g1, vertex.label.color = "black", layout = m1)
```

### Visualizing Edges

```r
w1 <- E(g1)$hours

# Edge별로 가중치를 다르게 하여 시각화한다
m1 <- layout_nicely(g1)
plot(
    g1, 
    vertex.label.color = "black", 
    edge.color = 'black',
    edge.width = w1,
    layout = m1
)

# 2hour보다 작은 edge를 제거하고 시각화한다
g2 <- delete_edges(g1, E(g1)[hours < 2])
w2 <- E(g2)$hours
m2 <- layout_nicely(g2)

plot(
    g2, 
    vertex.label.color = "black", 
    edge.color = 'black',
    edge.width = w2,
    layout = m2
)
```
