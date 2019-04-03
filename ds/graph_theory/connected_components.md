# Connected Components

그래프 내에서 서로 연결되어 있는 여러 개의 고립된 subgraph 각각을 **Connected Components** 라고 한다.

![png](https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Pseudoforest.svg/800px-Pseudoforest.svg.png)

Connected Components는 동일한 컴포넌트에 속한 모든 노드를 연결하는 경로가 있어야 한다.
또한 다른 Connected Component의 노드와 연결하는 경로가 있어서는 안된다.

Connected Components를 찾기 위해서는 BFS 또는 DFS 탐색을 이용한다.

TODO : 이게 왜 중요하지?

# Reference

- [[알고리즘] 연결 성분(Connected Component) 찾는 방법](https://gmlwjd9405.github.io/2018/08/16/algorithm-connected-component.html)
- [Data Scientists, The one Graph Algorithm you need to know](https://towardsdatascience.com/to-all-data-scientists-the-one-graph-algorithm-you-need-to-know-59178dbb1ec2)
