# Structure of Graphs

## Structure of Networks?

* 네트워크는 링크를 통해 연결되어있는 오브젝트 쌍의 집합이다
* 네트워크는 어떤 구조로 되어있을까?
    * Objects : nodes, vertices (N)
    * Interactions : links, edges (E)
    * System : network, graph ( G(N, E) )

## Networks or Graphs?

* 네트워크
    * 보통 실제 시스템을 의미한다
    * 웹, 소셜 네트워크, 물질 대사 네트워크
    * Network, node, link 라고 표현한다
* 그래프
    * 네트워크를 수학적으로 표현한 것을 의미한다
    * 웹 그래프, 소셜 그래프 (페이스북의 용어)
    * Graph, vertex, edge 라고 표현한다
* 필요한 경우에는 두 용어를 분리해서 사용하겠지만, 대부분의 경우에는 혼용할 것이다

## 적절한 표현방법 선택하기

* 그래프를 구성하는 방법
    * 데이터에서 노드에 해당하는 것이 무엇일까?
    * 엣지에 해당하는 것이 무엇일까?
* 주어진 도메인/문제에 적합한 네트워크 표현 방식을 적용해야 한다
    * 특정한 방식으로만 표현해야하는 경우도 있다
    * 하지만 다양한 방식을 사용할 수 있는 경우, 링크를 어떻게 연결하는지에 따라 해결할 수 있는 문제가 결정될 것이다


# Choice of Network Representation

## Directed vs. Undirected Graphs

* Undirected
    * 링크에 방향이 없다 (대칭, 상호관계)
    * Example : 협업, 페이스북 친구관계
* Directed
    * 링크에 방향이 있다
    * Example : 전화, 트위터 팔로잉

## Node Degrees

* Undirected
    * Node Degree `K_i` = i번째 노드와 인접한 노드의 개수
    * Avg. Degree = 2E / N
* Directed
    * Directed Network 에서는 in-degree와 out-degree를 정의할 수 있다
    * Total Degree = in-degrees + out-degrees
    * Avg. Edgree = E / N
    * in-degree = 0 인 노드를 **Source**, out-degree = 0 인 노드를 **Sink** 라고 한다

## Complete Graph

* N개의 노드를 가진 네트워크의 경우 총 `E_max = N(N-1) / 2` 개의 엣지를 가질 수 있다
* `E_max` 개의 엣지를 가지는 Undirected Network를 **Complete Graph** 라고 한다
* Complete Graph의 평균 degree 값은 N-1 이다

## Bipartite Graph

* 다음과 같은 그래프를 Bipartite Graph 라고 한다
    * 그래프의 노드가 겹치지 않는 두 가지 종류로 구성되어 있다
    * 서로 다른 종류의 노드끼리만 연결되어 있다
* Examples
    * 저자 - 논문
    * 배우 - 영화
    * 평점을 부여한 사용자 - 영화
    * 레시피 - 재료
* Folded Network
    * Bipartite Network를 특정한 노드끼리의 네트워크로 projection 할 수 있다
    * 논문 저자들의 협업 네트워크
    * 함께 평가된 영화들의 네트워크

## 그래프 표현하기

* Adjacency Matrix
    * Aij = 1 : 노드i 로부터 노드j로 연결된 링크가 있을 경우
    * Aij = 0 : 연결된 링크가 없을 경우
    * Undirected Graph의 경우 대칭행렬이 된다 (Directed 에서는 대칭아님)
    * 일반적으로 Adjacency Matrix 는 sparse하다
* Edge List
    * 그래프를 edge 들의 집합으로 표현할 수 있다
    * `{(2,3) , (2,4) , (3,2) , (3,4) , (4,5) , (5,2) , (5,1)}`
* Adjacency List
    * 네트워크의 규모가 크면서 희소할 경우 유용하다
    * 주어진 노드와 인접한 노드를 빠르게 확인할 수 있다
    * Examples
        * 1:
        * 2: 3,4
        * 3: 2,4
        * 4: 5
        * 5: 1,2

## 네트워크는 Sparse Graph 이다

* 현실 세계의 네트워크들은 대부분 Sparse 하다
    * `E << E_max (또는 Avg Degree << K - 1)`
    * 따라서 Adjacency Matrix 들은 0 값으로 가득차있다

## 다른 종류의 네트워크

* Weight
    * Unweighted : 친구관계, 하이퍼링크
    * Weighted : 협업, 인터넷, 도로
* Self-Edges (Self-loops)
    * `A_ii != 0` 인 케이스가 존재한다
* Multigraph
* Examples
    * 이메일 네트워크 : directed multigraph with self-edges
    * 페이스북 친구관계 : undirected, unweighted
    * 인용 네트워크 : unweighted, directed, acyclic
    * 협업 네트워크 : undirected multigraph or weighted graph
    * 핸드폰 전화 : directed, (weighted?) multigraph
    * 단백질간의 상호작용 : undirected, unweighted with self-interactions

## 그래프의 연결성

* Undirected Graph의 연결성 : Connected (Undirected) Graph
    * 임의의 두 노드가 path를 통해 연결될 수 있는 그래프를 말한다
    * Disconnected Graph는 2개 이상의 Connected Components로 구성된다
    * 특정 엣지를 지웠을 때 그래프의 연결이 끊어지는 경우, 해당 엣지를 **Bridge Edge** 라고 한다
    * 특정 노드를 지웠을 때 그래프의 연결이 끊어지는 경우, 해당 노드를 **Articulation Node** 라고 한다
* Directed Graph의 연결성
    * Strongly connected directed graph
        * 특정한 노드로부터 다른 임의의 노드로 path가 이어지고, 그 반대도 성립하는 경우를 말한다 (A->B, B->A 가 모두 존재)
        * Strongly connected components (SCCs) 는 식별될 수 있지만, 연결된 모든 노드가 SCC에 속하지는 않는다
            * In-component : SCC 방향으로 연결할 수 있는 노드
            * Out-component : SCC로부터 연결할 수 있는 노드
    * Weakly connected directed graph
        * 방향성을 생각하지 않았을 때 임의의 두 노드가 이어지는 경우를 말한다
