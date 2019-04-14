# 중요한 노드 찾기

- 그래프/네트워크 분석에서 중요한 부분 중 하나는, 어떤 노드가 중요한지 파악하는 것이다
- 여기서 **중요하다** 는 것을 어떻게 정의하느냐에 따라 다양한 결과를 얻을 수 있다
    - 친구수가 가장 많은 사람
    - 모든 사람이 한 번씩은 거쳐야 하는 프로세스
    - 네트워크 전반에 걸쳐 영향력이 높은 인플루언서
    - 권위있는 연구자가 극찬한 문서/논문
- 특정 노드가 얼마나 네트워크 상에서 중심에 있는지 측정한 값을 **중심성(Centrality)** 이라고 한다
- 중심성을 측정하기 위한 다양한 지표들이 존재한다

## Degree Centrality

- 특정 노드가 몇 개의 노드와 연결되어 있는지 계산한다
- `igraph::degree(graph, mode)`
- Undirected Network 에서는 몇 개의 노드와 연결되어 있는지 계산하면 된다
- Directed Network의 경우 화살표의 방향에 따라 세 가지 경우가 있다
    - `mode='all'` (기본값) : in-degree와 out-degree를 합한 값이다
    - `mode='in'` : 들어오는 방향의 엣지가 얼마나 되는지 계산한다
    - `mode='out'` : 나가는 방향의 엣지가 얼마나 되는지 계산한다

```r
# mode = 'all'
degree(graph)

# mode = 'in'
degree(graph, mode = 'in')

# mode = 'out'
degree(graph, mode = 'out')
```

## Betweenness Centrality

- 특정 두 노드 사이의 최단거리에 많이 포함될수록 수치가 높아진다
- 네트워크 내의 **좋은 중개자** 를 찾기 위한 지표다
    - Betweenness Centrality 가 높은 노드들은 전체 네트워크의 흐름에서 큰 영향력을 가진다
- `igraph::betweenness(graph)`

```{r}
betweenness(main_tidyverse_packages)
```

## Closeness Centrality

- 모든 노드와의 평균적인 거리가 작을수록 중심에 있는 노드라고 본다
    - 특정 노드에 대해서 다른 모든 노드들과의 최단 거리를 계산한다
    - `1 / 전체 노드들에 대한 최단거리 합계` 를 계산한다
    - 중심에 있는 노드라도 외곽과의 거리가 멀다면 수치가 낮아진다
    - 전체적으로 편차가 작은 지표가 될 수 있다
- 최단 경로를 반복적으로 계산해야 하기 때문에 데이터가 커질 경우 연산이 많이 필요하다
- `igraph::closeness(graph)`

```{r message=FALSE, warning=FALSE}
closeness(main_tidyverse_packages)
```

## Eigenvector Centrality

- 많은 노드와 연결되어 있을수록 수치가 증가한다 (영향력이 높아진다)
- 연결된 노드의 영향력이 클수록 가중치가 높아진다
- Closeness Centrality에 비해 큰 자료에도 잘 동작한다
- 기본적으로 Undirected Network를 가정한다
- `eigen_centrality(graph)`
    - 함수의 결과물에서 `vector` 프로퍼티를 통해 중심성 정도를 추출할 수 있다

```r
eigen_centrality(graph)$vector
```

## Page Rank

- Eigenvector Centrality 와 유사한 컨셉으로 동작한다
    - 많은 노드와 연결되어 있을수록 수치가 증가한다 (영향력이 높아진다)
    - 연결된 노드의 영향력이 클수록 가중치가 높아진다
    - Eigenvector Centrality가 수렴하지 않는 상황에서도 비교적 잘 동작한다
- 기본적으로 Directed Network를 가정한다
- 구글에서 중요한 웹페이지를 찾기 위해 개발한 알고리즘이다

```r
page_rank(graph)$vector
```
