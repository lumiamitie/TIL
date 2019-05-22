# PageRank

## 1. Web as a Graph

### Q: 웹을 전체적으로 살펴보게 되면 어떤 구조를 가지고 있을까?

* Web As a Graph
    * Nodes = 웹페이지
    * Edges = 하이퍼링크
* 웹을 그래프 형태로 이해하고자 할 때 발생하는 이슈
    1. 동적으로 생성되는 페이지 (예를 들면, 로그인 해야 접근 가능한 개인화된 페이지)
    2. "암흑물질" : 데이터베이스를 통해 자동으로 생성되는 페이지 (파라미터화된 페이지)
* 인터넷 초창기에는 링크가 대부분 페이지의 이동을 위해 사용되었다 (navigational)
    * 현재는 많은 링크들이 트랜잭션을 처리하기 위해 사용된다 (transactiional)
    * 페이지 간의 이동을 위해 사용되기도 하지만, 포스트로 이동 / 댓글 / 좋아요 / 구매 등 액션을 위해 사용되는 경우가 많다
    * 하지만 그래프를 통해 웹을 분석할 때는 대체로 navigational link를 대상으로 할 것이다
* 웹은 어떤 모습일까?
    * Web as a **Directed Graph** [Broder et al. 2000]
    * 노드 v가 주어졌을 때 v에서 도달할 수 있는 노드에는 어떤 것들이 있을까? ( In(v) = {w | w can reach v} )
    * 노드 v에 도달할 수 있는 노드는 어떤 것들이 있을까? ( out(v) = {w | v can reach w} )

### Directed Graphs에 대해 더 알아보자

* Directed Graph에는 두 가지 종류가 있다
    * **Strongly Connected** : 모든 노드에 서로 도달할 수 있다
    * **Directed Acyclic Graph (DAG)** : cycle이 없다 (u에서 v에 도달할 수 있다면, v에서 u로는 도달할 수 없다)
* 모든 Directed Graph는 이 두 가지 중 하나에 속한다
    * 그렇다면 웹은 Strongly Connected Graph일까 DAG일까?
* Strongly Connected Component (SCC)
    * SCC는 집합 내의 노드들끼리는 서로 도달할 수 있는 노드들의 집합을 말한다
    * 컴포넌트로 분리했을 때 고립된 노드들은 그 자체로 SCC를 구성한다
    * 그래프 G의 SCC를 하나의 노드처럼 취급하여 새로운 그래프 G' 를 만든다면, G'는 DAG가 된다

### 웹의 구조

* Broder et al : Altavista Web crawl (1999)
    * 시작지점이 될 url 을 최대한 많이 확보하고 링크를 탐색해나가는 방식으로 웹 크롤링을 수행한다 (BFS)
    * 웹의 스냅샷을 구해서 SCC가 어떻게 DAG로 피팅되는지 확인하고자 한다
* 계산상의 문제 : 특정 노드 v를 포함하는 SCC를 어떻게 구할 수 있을까?
    * Out(v) 는 특정 노드 v에서 도달할 수 있는 노드의 집합을 말한다. 이것은 BFS를 통해 구할 수 있다.
    * 노드 v를 포함하는 SCC
        * Out(v) ⋂ In(v)
        * = Out(v, G) ⋂ Out(v, G') 여기서 G'는 G에서 모든 edge 방향을 뒤집은 그래프
    * 예를 들면,
        * Out(A) = {A, B, D, E, F, G, H}
        * In(A) = {A, B, C, D, E}
        * SCC(A) = Out(A) ⋂ In(A) = {A, B, D, E}
* 웹의 그래프 구조
    * 논문에서 확인한 결과, 웹에는 단 하나의 거대한 SCC가 존재했다고 한다
    * 왜 SCC가 하나밖에 없을까? 다음과 같이 짐작해 볼 수 있다
        * 두 개의 거대한 SCC가 있다고 가정해보자
        * 한 SCC에서 다른 SCC로 이어지는데는 링크 한 개면 충분하다
        * 각각의 SCC가 수백만개의 페이지를 가지고 있을 경우, 두 SCC가 이어지지 않았을 가능성이 너무나도 작다
    * 알타비스타 웹 크롤러를 통해 웹의 랜덤 노드로부터 In(v)과 Out(v) 를 계산해보았다
        * BFS로 탐색한 결과 많은 수의 노드를 방문하거나 거의 방문하지 않았다
        * 단 하나의 거대한 SCC를 가지고 있다는 점과 연결된다
        * 평균적으로 다음과 같은 결과를 얻을 수 있었다
            * Out(v) = 약 100 million (50% 노드)
            * In(v) = 약 100 million (50% 노드)
            * Largest SCC : 56 million (28% 노드)
    * Bowtie Structure
        * 웹 그래프의 구조를 분석한 결과, 웹은 Bowtie 형태의 구조를 가진다고 볼 수 있었다
        * IN -> SCC -> OUT
        * tendrils : IN 또는 OUT 컴포넌트에서 SCC가 아닌 다른 곳으로 연결되는 경우
        * Tubes : IN 컴포넌트와 Out 컴포넌트를 연결하는 경우
        * Disconnected Components


## 2. PageRank

### 그래프 상의 노드에 순위를 매기기

* 모든 웹 페이지들이 동등하게 중요하지 않다
    * 웹에서는 다양한 웹페이지들이 서로 연결되어 있다
    * 웹의 그래프 구조를 통해 어떤 페이지가 더 중요한지 순위를 매겨보자
* 다음과 같은 방법론을 통해 그래프에 있는 노드의 중요도를 계산하고자 한다
    * PageRank
    * Random Walk with Restarts
    * SimRank

### PageRank

* 링크를 "투표" 로 이해하기
    * "링크를 더 많이 가지고 있는 페이지가 더 중요할 것이다"
    * 들어오는 링크로 세어야 할까? 나가는 링크로 세어야 할까?
    * 모든 링크의 중요도가 동일한가?
        * 중요한 페이지의 링크는 더 높은 가중치를 부여할 수 있다
        * Recursive Question!
* PageRank : "Flow" Model
    * **중요한 노드의 한 표는 더 큰 가치를 가진다**
        * 각 링크의 투표는 소스 페이지의 중요도에 비례하는 가치를 갖는다
        * 특정 페이지 i의 중요도가 `r_i` 이고 out-link가 `d_i` 개 있다면, 각각의 링크는 `r_i / d_i` 만큼의 투표를 한다
        * 특정 페이지 j의 중요도는 in-link를 통해 받은 투표를 모두 합한 값을 의미한다
    * **다른 중요한 페이지에서 연결된 페이지도 중요하다**
        * 노드 j의 rank를 다음과 같이 정의해보자
            * i에서 j로 연결된 모든 노드의 SUM(rank / out-degree)
        * 모든 노드에 대해서 식을 구하면 그래프에 대한 Flow Equation을 구할 수 있다
            * 가우시안 소거법을 쓰고 싶게 생겼지만, 그래프 G가 너무 크기 때문에 적용할 수 없다
* PageRank : 행렬로 표현하기
    * Stochastic adjacency matrix M
        * 페이지 j가 `d_j` 개의 out-link를 가지고 있을 때, j -> i 의 링크가 있다면 `M_ij = 1 / d_j` 이다
        * M은 column stochastic matrix 이기 때문에, 열의 합계가 1이 된다
    * Rank Vector r
        * 특정 페이지의 중요도 점수를 나타낸다
        * `SUM( r_i ) = 1`
    * Flow Equation은 다음과 같이 작성할 수 있다
        * r = M * r
* 랜덤워크로 이해하기
    * 임의의 웹 서퍼를 가정해보자
        * 특정 시점 t에 서퍼는 페이지 i에 있다
        * t+1 시점에는 i로 부터 연결된 out-link 중 하나에 랜덤하게 이동한다
        * 계속해서 반복한다
    * p(t)를 정의해보자
        * p(t) 벡터의 i번째 요소는 시점 t에 페이지 i에 서퍼가 존재할 확률을 말한다
        * 따라서 p(t)는 페이지에 대한 확률 분포이다
    * 시점 t+1 에 서퍼는 어디에 있을까?
        * 연결된 링크에 균일한 확률로 접근한다
        * p(t + 1) = M * p(t)
    * 만약 `p(t + 1) = M * p(t) = p(t)` 인 상태에 도달한다면, p(t)는 랜덤워크의 stationary distribution이라고 할 수 있다
    * 원래의 rank 벡터 r은 r = M * r 이 성립한다
        * 따라서 r은 랜덤워크의 stationary distribution이다


## 3. PageRank를 어떻게 계산할까?

### PageRank 계산하기

* 웹 그래프가 n개의 노드를 가지고 있고, 노드는 페이지를 엣지는 하이퍼링크를 의미한다
    * 각각의 노드에 페이지랭크 초기값을 부여한다
    * 수렴할 때 까지 각 노드의 페이지랭크를 계산하는 작업을 반복한다
* Power Iteration
    1. `r_j <- 1 / N` 으로 설정한다
    2. `r_j' <- SUM(ri / di)`
    3. `r <- r'`
    4. 만약 `| r - r' | > epsilon` 이라면 2번으로 돌아간다
* 페이지랭크에 대한 세 가지 의문
    * 수렴하는가?
    * 우리가 원하는 값으로 수렴하는가?
    * 납득할만한 결과물이 나오는가?

### PageRank의 문제

* Dead Ends
    * out-link가 없는 노드를 말한다
    * 어떤 페이지들은 외부로 연결된 링크가 없다
* Spider Traps
    * 모든 out-link가 그룹 내로 연결되어 있는 경우를 말한다
    * 이 경우 중요도 값을 spider traps 이 모두 흡수해 버릴 우려가 있다
* **Dead Ends 와 Spider Traps 문제 때문에 우리가 원하는 형태로 수렴하지 못한다!**
* Spider Traps에 대한 구글의 해결 방법
    * 매 step 마다 서퍼는 두 가지 선택을 하게 된다
        * beta의 확률로 연결된 링크를 통해 이동한다
        * (1-beta)의 확률로 임의의 페이지로 이동한다
        * 일반적으로 beta 값은 0.8 ~ 0.9 사이의 값을 사용한다
    * 서퍼는 몇 번의 step을 거치면 spider trap에서 빠져나올 수 있다
* Dead Ends에 대한 해결 방법
    * Dead Ends에 도달하면 1의 확률로 다른 페이지로 이동한다
    * 행렬 자체를 그에 맞게 변경한다
* 최종 PageRank 공식
    * `r_j = SUM(beta * r_i / (out-degree of node i)) + (1 - beta) / n`
    * 위 공식에서는 행렬 M에 dead ends가 없다고 가정한다
        * 따라서 계산을 위해서는 행렬 M을 전처리해야한다
        * 하지만 그렇게 되면 계산이 어렵기 때문에, dead-ends에 도달하면 1의 확률로 텔레포트하도록 구현한다


## 4. 재시작이 존재하는 랜덤워크 & 개인화된 페이지랭크

* 예시 : 그래프 탐색 문제
    * 컨퍼런스 - 저자 그래프가 있다고 가정해보자
    * 그래프 상에서 각 노드가 얼마나 근접한지 알고자 한다
    * 예를 들면, ICDM과 가장 연관성이 높은 컨퍼런스는 어떤 것일까?
* Personalized PageRank
    * 목표 : 각각의 페이지를 인기도뿐만 아니라 각 주제에 얼마나 근접한지를 기준으로 평가해보자
    * 텔레포트하는 상황에 따라 다음과 같이 나눌 수 있다
        * 모든 페이지에 동일한 확률로 이동한다 : **PageRank**
        * 토픽을 기준으로 했을 때 유사한 페이지로 이동한다 : **Personalized (Topic-specific) PageRank**
        * 특정한 페이지, 노드로 이동한다 : **Random Walk with Restarts**
* PageRank 예시
    * Q: KDD와 ICDM과 가장 근접한 컨퍼런스를 구하려면 어떻게 해야할까?
    * A: 텔레포트 셋 S = {KDD, ICDM} 을 기준으로 Personalized PageRank를 계산한다

## 5. SimRank

* SimRank의 기본적인 컨셉은 다음과 같다
    * 두 오브젝트가 비슷한 오브젝트들과 연결되어 있다면, 유사하다고 볼 수 있다
    * 연결된 이웃의 수를 normalized하여 사용한다
