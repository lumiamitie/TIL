- 다음 포스팅을 요약해서 정리해보자

[Causal inference bake off (Kaggle style!) - Just be-cause](https://iyarlin.github.io/2019/05/20/causal-inference-bake-off-kaggle-style/)

---

# Causal Inference objectives and the need for specialized algorithms

## ATE: Average Treatment Effect

X가 Y에 미치는 인과적인 영향을 예측하기 위해서는 "Backdoor Criteria"를 만족하는 변수 집단 Zb 를 알아야 한다. 그러면 다음과 같은 공식을 적용할 수 있다. 

```
E(Y | do(x)) = SUM_Zb( f(x, Zb) * P(Zb) )

-> Y는 목표 변수를 의미한다
-> do(x) 는 변수 X를 x값으로 설정하는 행위를 말한다
-> f(x, Zb) = E_hat(Y | x, Zb)
```

위 공식에서 f(x, Zb) 는 일반적인 ML 알고리즘을 통해 구할 수 있는 예측 함수다. 그렇다면 머신러닝 알고리즘 대신 특수한 인과 관계 알고리즘이 왜 필요한걸까?

그 이유는 인과관계 추론의 목적이 머신러닝과 다르기 때문이다. 

- **Machine Learning** : `E(Y | x)` 을 예측하고자 한다
- **Causal Inference** : `E(Y | do(x1)) - E(Y | do(x2))` 를 예측하고자 한다
    - 여기서 X에 서로 다른 값을 적용했을 때 발생하는 예측값의 차이를 **Average Treatment Effect (ATE)** 라고 한다

왜 `E(Y | x)` 값의 예측값이 ATE의 예측값과 달라질 수 있는 것일까? 예제를 통해 살펴보자.

- 일부 고객들을 대상으로 새로 개발한 자동 입찰 알고리즘에 대한 테스트를 진행했다
- 자동 입찰 알고리즘을 적용한 경우 treated 군으로 분류한다
- Proportion은 플랫폼 내 전체 캠페인 중에서 얼마나 비중을 차지하는지 알려준다

| Treatment | Company Size | ROI | Proportion |
|-----------|--------------|-----|------------|
| untreated | small        | 1%  | 0.1        |
| treated   | small        | 2%  | 0.4        |
| untreated | large        | 5%  | 0.4        |
| treated   | large        | 5%  | 0.1        |
