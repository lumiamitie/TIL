# Probabilistic Programming

[The Algorithms behind Probabilistic Programming](http://blog.fastforwardlabs.com/2017/01/30/the-algorithms-behind-probabilistic-programming.html)

## The Algorithms Behind Probabilistic Programming
    
Bayesian Inference 는 약 한 세기 전의 개념이지만, 이제서야 주목받고 있다

- 베이지안 기반의 방법론들이 구현하기 어렵고, 연산이 너무 무거웠기 때문이다
- 임의의 분포에서 샘플링하는 경우, brute force 방법이나 rejection sampling 기법은 acceptance rate이 너무 낮다. 따라서 속도가 너무 느리고 비효율적이다
- 비교적 최근까지 사용되었던 대안은 Metropolis-Hastings 나 Gibbs sampling과 같은 MCMC 계열 방법론이다. 하지만 이러한 방법론들도 복잡한 구조나 대용량 데이터에서는 느린 경향을 보였다

그런데, 최근 5~10년 사이에 훨씬 효율적이고 빠른 샘플링이 가능한 두 가지 방법론이 등장했다

- (1) **Hamiltonian Monte Carlo** (HMC, NUTS)
    - 모형의 gradient를 사용해서 빠르게 학습
    - Discrete Variable에는 적용불가
    - parameter tuning에 민감하게 반응 => Robust한 NUTS(No U-Turn Sampler) 알고리즘이 등장
- (2) **Variational Inference and Automatic Differentiation** (ADVI)
    - VI는 원래 분포를 우리가 잘 알고 있고 계산하기 쉬운 분포로 근사시켜서 샘플링을 수행하는 방법이다
    - 근사시키는 과정에서 보통 SGD (Stochastic Gradient Descent) 를 활용한다
    - 원래의 확률 모형을 VI를 적용할 수 있는 형태로 변경하는데 복잡한 수학 지식이 요구되어 난이도가 높았다
    - Automatic Differentiation 을 통해 임의의 함수를 VI가 가능한 형태로 자동으로 변환하고 미분을 계산한다

PPL을 실용적으로 사용할 수 있게 된 것에는 다음과 같은 영향이 있었다

- 사용자는 직접 파라미터를 튜닝하거나 함수를 미분할 필요가 없다. ADVI, HMC/NUTS로 인해 성능도 확보할 수 있었다
- 모형을 구축하기 위한 간결한 문법체계가 필요해졌다

널리 사용되고 있는 probabilistic programming 도구는 다음과 같은 것들이 있다

- Stan (R / Py)
- PyMC3 (Py + theano)
- Edward (Py + tensorflow)
    - 현재는 tensorflow에 포함되어 있다 (tf.contrib.distributions, tf.contrib.bayesflow)
