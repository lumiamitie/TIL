# Bayesian A/B Testing

다음 아티클을 읽고 간단히 정리해보자.

[Chris Stucchio | Bayesian A/B Testing at VWO](https://cdn2.hubspot.net/hubfs/310840/VWO_SmartStats_technical_whitepaper.pdf)

# Problem

A/B 테스트를 할 때마다 사람들이 가장 궁금해하는 것 중에 하나는 B안이 A안보다 좋을 확률이 얼마나 되냐는 것이다. 일반적으로 사용하는 frequentist 방법론으로는 이러한 질문에 대한 답을 할 수 없다. frequentist 방법론들은 보통 이런 방법을 따른다.

1. 귀무가설(Null Hypothesis)을 선택한다. 보통 A, B안 사이에 차이가 없을 것이라고 가정하게 된다.
2. 이제 실험을 수행하고, 통계량을 구한다.
3. p-value를 계산한다. p-value는 귀무가설이 맞다고 가정했을 때, 현재보다 더 극단적인 케이스의 통계량 수치가 나올 확률을 의미한다.
    - p-value가 의미하는 것은 다음과 같다.
    - "동일한 샘플 크기로 A/A 테스트를 수행할 경우, 방금 본 결과와 같거나 더 극단적인 결과가 나올 확률이 p값보다 작다."

p-value 는 B안이 A안보다 좋을 확률을 의미하는 것이 아니지만, 그렇게 사용되는 경우가 종종 있다.

흔히 사용하는 A/B 테스트 방식은 false positive 를 발생시키기 쉽다. 예를 들어, 여러 가지 목표를 만들어 두고 테스트가 끝날 때 특정 목표를 선택해버릴 수도 있다. 

# The Joint Posterior for 2 variants

A안과 B안이라는 2개의 선택지가 있다고 해보자. 이 때, joint posterior는 다음과 같다.

```
P(lambda_A, lambda_B) = P_A(lambda_A) * P_B(lambda_B)

lambda_A : A안의 true conversion rate
lambda_B : B안의 true conversion rate
P_A(lambda_A) : A안에 대한 Posterior distribution
P_B(lambda_B) : B안에 대한 Posterior distribution
```

Joint posterior 를 알고있으면 다양한 값을 구할 수 있다. 그 중에서 가장 중요한 것은 loss function 이다.
이 함수를 바탕으로 어떤 안을 선택할지, 언제 테스트를 멈출지 결정할 것이다.
