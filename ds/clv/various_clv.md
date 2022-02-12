# CLV를 구하기 위한 다양한 방법

<http://srepho.github.io/CLV/CLV>

- List of models
    - **Contractual**
        - Naive
        - Recency Frequency Monetary (RFM) Summaries
        - Markov Chains
        - Hazard Functions
        - Survival Regression
        - Supervised Machine Learning using Random Forest
    - **Non-Contractual**
        - Management Heuristics
        - Distribution Based Approaches

## CLV의 기본적인 컨셉

CLV는 보통 다음과 같은 생각으로 한다.

> 고객 생애 가치(CLV)란, 특정 고객을 통해 얻게 된 이익에서 고객에게 투입한 총 비용을 제거한 값을 말한다.

```
CLV = SUM(E(Vhat_t) / (1 + delta)^(t-1))
```
