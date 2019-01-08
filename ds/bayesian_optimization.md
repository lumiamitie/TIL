# Practical Bayesian Optimization of Machine Learning Algorithms

[PR-080](https://www.youtube.com/watch?v=MnHCe8tGjQ8)

## (0) Introduction

* 하이퍼 파라미터 최적화
    * 한 번 트레이닝 하는 것도 굉장히 많은 시간을 필요로 한다
    * 따라서 일반적인 머신러닝 최적화 방법을 적용할 수는 없다
    * 반복 횟수를 줄이면서 최적화를 할 수 있는 방법이 없을까?
    * 최근 각광받고 있는 방법은 Bayesian Optimization
* Bayesian Optimization
    * 사용한지 이미 몇십년이 됐지만 머신러닝에는 적용하지 못하고 있었음
    * 2012년에 해당 논문에서 기존 BO의 몇 가지 문제점을 개선하여 하이퍼 파라미터 최적화에 활용

## (1) Tuning ML Hyperparameters

* 최적의 하이퍼 파라미터를 모를 경우에는 :
    * 일단 기본값으로 두고 실험을 수행하고 Loss Function 값을 재본다
    * 결과가 만족스럽지 않다면 하이퍼 파라미터 값을 바꾸어가면서 실험을 반복한다
* 하이퍼 파라미터 최적화가 중요한 이유는 무엇일까?
    * 튜닝을 통해 큰 성능 향상을 얻을 수 있다
    * 최적의 파라미터를 찾아내는 정해진 방법이 없다 (Art에 가깝다?)
    * 논문의 신뢰성에도 큰 영향을 주었다
        * 다른 사람의 논문을 재현할 때는 하이퍼 파라미터를 대충 계산하고, 내 논문을 쓸 때는 공들여서 구하는 등
    * 머신러닝 전문가가 아닌 사람이 접했을 때 어려움을 느끼는 부분이다
* 하이퍼 파라미터 최적화 문제
    * Validation Set의 데이터를 우리가 만든 머신러닝 알고리즘에 넣어서 Loss Function 값을 구한다
    * Loss 값의 평균 또는 전체합을 최소화하는 파라미터가 바로 우리가 찾는 최적의 하이퍼 파라미터
* 방법이 없으니 보통 Grid Search나 Random Search를 사용했다
    * Grid Search
        * 가능한 모든 파라미터 조합을 테스트한다
            * 두 가지 파라미터에 각각 세 가지 값이 있다면 3 x 3 = 9 가지 조합
        * 바꾸어도 성능에 큰 변화가 없는 파라미터가 있다면, 해당 파라미터를 계속 바꾸면서 실험하는 것은 시간 낭비다
            * 하지만 낭비가 발생할지 여부를 미리 알 수 없다..
    * Random Search
        * 랜덤한 파라미터 조합으로 실험한다
    * Grad Student Descent
        * 논문의 저자들이 (개그로..?) 적어놓은 것
        * 실험자(대학원생)들이 잘 될 것 같은 파라미터를 몇 개 찍어서 진행
        * 재현성의 문제가 있다
        * 실험하는 사람의 주관에 의해 달라질 우려가 있음
* 새로운 방법이 없을까??


## (2) Bayesian Optimization with Gaussian Process Priors

* Bayesian Optimization의 기본적인 프로세스는 다음과 같다
    * Bayesian 이라는 명칭에서부터 알 수 있듯이 Prior를 가정한다
        * 하이퍼 파라미터를 입력으로 하고, Loss 값을 출력으로 하는 함수를 f라고 해보자
        * 함수 f는 가우시안 프로세스를 따를 것이다 (굉장히 Smooth한 함수일 것이라고 가정)
    * 실험을 통해 나온 값을 바탕으로 모델을 업데이트한다
    * 위 과정을 반복하여 최적의 하이퍼 파라미터를 구한다
* 여기에 몇 가지 추가로 알아야 하는 개념들이 있다
    * Gaussian Process
        * mean과 covariance 가 존재한다
    * Acquisition Function
        * 최적의 하이퍼 파라미터를 찾기 위해 대신 사용할 함수
        * 원래 Loss를 구하기 위해서는 학습셋 전체를 가지고 모형을 돌려야 한다 => 비용이 너무 크다
        * 이 과정을 대신해 줄, 훨씬 간단한 함수를 정의하고 이것을 Acquisition Function 이라고 한다
        * 한 번 학습하는데 드는 비용이 워낙 크기 때문에, 다음 번 실험할 하이퍼 파라미터 셋을 결정하는데 큰 공을 들인다
            * Acquisition Function을 최대화시키는 하이퍼 파라미터 셋 Xt 를 찾는다
            * Xt를 바탕으로 새로운 Loss Function 값을 샘플링하여 구한다 ( `Yt = f(Xt) + Et` )
            * 샘플링한 정보를 바탕으로 Gaussian Process의 분포를 업데이트한다
            * 위 과정을 반복
* 점 세 개는 실험을 통해 알고 있다고 할 때, 다음 번 실험을 할 지점을 찾는다
    * 하이퍼 파라미터 최적화 서비스들은 20번 내외의 실험을 통해 최적의 파라미터를 찾는다
    * 굉장히 적은 수의 실험을 통해 효과적으로 파라미터를 최적화한다


### (2.1) Gaussian Processes

* Gaussian Process로 어떻게 모델링할까?
    * GP는 파라미터가 두 개 존재한다
        * 시간축을 따라 변화하는 "process" 이기 때문에 Mean Function, Covariance Function 이 된다
    * 이 중에서 Covariance Function의 kernel을 정의하는 방법이 굉장히 다양하다
        * 가장 간단한 것은 Squared Exponential - 파라미터 수 적음, smooth한 곡선
        * 더 복잡한 Matern
        * Neural Network
        * Periodic
        * 이 중에서 자유롭게 선택할 수 있다
        * 어떤 것을 선택하는지가 성능에 큰 영향을 미치기 때문에, 논문에서 효과적인 커널을 제안한다

### (2.2) Acquisition Function

* 다음 번 실험할 지점은 어떻게 고를까?
    * Acquisition Function을 통해 결정한다
    * Acquisition Function "Alpha"를 정의하고, 이 함수가 극대화될 때의 입력값 (하이퍼 파라미터 세트) 이 실제 Loss를 최소화 시키는 지점일 것이라고 가정한다
    * 따라서 acquisition function이 최대가 되는 지점의 하이퍼 파라미터로 샘플링하고, f(x)를 업데이트한다
* Acquisition Function을 정할 때 중요한 성질 두 가지가 있다
    * (1) Exploration
        * 불확실성이 높은 지점을 찾아간다 (High Uncertainty)
        * 불확실성이 높은 지점은 성능이 매우 나쁠 수도, 좋을 수도 있기 때문이다
    * (2) Exploitation
        * 이미 꽤 괜찮다고 알고 있는 영역에서 최적의 값을 찾는다 (Loss Minimization)
        * 평균이 낮은 지점에서 탐색한다
    * 위 두 가지 성질이 적절하게 균형을 이루어야 한다
* Bayesian Optimization 이론에서 가장 많이 사용하고 있는 Acquisition Function 세 가지가 있다
    * Probability of Improvement (Kushner 1964)
        * 개선될 확률이 가장 높은 것
        * GP의 CDF에 값을 바로 넣어서 확률을 구한다
    * Expected Improvement (Mockus 1978)
        * 이 중에서도 가장 많이 사용된다고 한다
        * 해당 논문에서는 이 방법을 중심으로 설명한다
    * GP Upper Confidence Bound (Srinivas et al. 2010)
* Expected Improvement
    * Improvement = 이제까지 최선의 Loss 값 - 이번에 예상하는 Loss 값
        * Improvement 의 기대값을 구한다
        * Expected Improvement가 가장 높은 지점에서 Loss 값이 가장 낮을 가능성이 높을 것이라 판단
    * 그냥은 사용하지 않고 노이즈를 추가한다
        * 노이즈를 추가하지 않을 경우 너무 탐색만 하는 경향이 있음 (exploration)
    * Gaussian Prior를 쓰는 이유는 계산하기가 쉽다는 장점이 있기 때문이다
        * 따라서 Closed Form 으로 계산할 수 있다
        * Monte Carlo 방식으로 샘플링해서 값을 추정할 수도 있다
    * 논문에서는 Expected Improvement를 계산하기 위해 MCMC 사용
* Bayesian Optimization - GP 업데이트
    * (1) Acquisition Function을 통해 다음번 테스트할 하이퍼 파라미터를 찾아낸다
        * Acquisition Function을 최대화 시키는 하이퍼 파라미터 셋 lambda를 다음번 테스트 지점으로 한다
    * (2) 찾아낸 하이퍼 파라미터를 바탕으로 Loss Function 값을 계산한다
    * (3) GP를 업데이트한다
* Acquisition Function과 노이즈의 형태에 따라 다른 결과물이 나온다
    * 최적의 하이퍼 파라미터를 찾기 위한 GP에 또 하이퍼 파라미터 값이 존재한다?
    * GP의 하이퍼 파라미터는 어떻게 최적화하지?
        * 여기에 대한 의문을 해결하는 것이 논문의 주된 내용 중 하나이다


## (3) Practical Considerations

* BO가 그 동안 사용되지 못한 이유가 무엇일까? 크게 두 가지 이유가 있다
    * **BO 자체의 파라미터** 에 의존한다
    * **Scalability** 가 부족하다
* 기존 BO 알고리즘에는 다음과 같은 문제점이 존재했다
    * 좋은 Covariance Function과 하이퍼 파라미터를 선택하는 방법이 명확하지 않다
    * 최적화에 걸리는 시간 또한 고려해야 한다
    * 병렬 처리가 가능해야 한다
* 해당 논문에서는 위 문제를 해결하기 위한 방법을 제안한다

### (3.1) Proposal 1. Choice of Covariance Functions and Hyperparameters

* (1) Choice of Covariance Functions
    * Smooth한 Squared Exponential (SE) 커널을 썼더니 잘 맞지 않았다
    * **Matern 커널 (중에서도 파라미터는 5/2로 하는 경우)** 을 사용했더니 성능이 좋았다
        * 이유는 잘 설명하지 않았지만, 많은 머신러닝 문제에 적절하게 대응했다고 주장한다
* (2) Choice of Hyperparameters
    * GP는 Covariance Function과 Mean Function에 하이퍼 파라미터가 존재한다
    * 예전에는 typical한 값 하나를 넣어두고 optimal이라고 주장했다 -> 하지만 최적화가 잘 안됐음
    * **Hyperparameter에 대한 디펜던시를 아예 없애버렸다**
        * 가능한 모든 하이퍼 파라미터 조합에 대해 expectation을 취한다 (Marginalize)
        * Integrated Acquisition Function을 사용한다
        * 따라서 하이퍼 파라미터와는 상관없이 적절한 Acquisition Function 을 사용할 수 있다
        * Integrated Acquisition Function 을 쓰니 수렴도 잘되고 계산도 쉽다고 한다
        * 가우시안을 가정하면 MCMC를 통해 구할 수 있다
    * MNIST에 실험해 본 결과 GP EI MCMC 조합으로 적용했을 때 빠른 속도로 최적화되는 것을 확인

### (3.2) Proposal 2. Modeling Costs

* Acquisition Function에 Cost를 반영한다
    * 이왕이면 실험을 덜 하고 빠르게 결과를 얻는 것이 좋다
    * expected improvement per second 를 제안한다
        * (Utility / 걸린 시간) 을 Cost로 한다
    * 더 빨리 계산될 것 같은 파라미터들을 먼저 시도하게 된다
    * 실험결과 GP EI MCMC 보다 GP EI per Second에서 더 빠르게 수렴했다

### (3.3) Proposal 3. Monte Carlo Acquisition for Parallelizing

* 원래 BO는 순차적으로 계산되는 알고리즘이기 때문에 병렬처리를 적용할 수 없었다
    * 서로 다른 머신에서 학습 중이라면 다른 머신의 학습이 끝나고 그 결과를 받아야 다음 번 Acquisition Function 값을 정할 수 있다
    * 모른다면 그 값을 예측하여 진행하자 (Fantasize)
* 결과가 나오기 전에 예측값의 기대값을 통해 다음번 시도할 하이퍼 파라미터를 구한다
* 이렇게 하면 절대적으로 Loss 값이 떨어질 것이라고 보장할 수는 없다
* 하지만 자원을 많이 투자할 수록 빠르게 최적화되는 것을 실험을 통해 확인했다


## (4) Conclusion

* 하이퍼 파라미터를 최적화해주는 최근의 서비스들은 대부분 Bayesian Optimization을 사용한다
* Gradient Descent를 사용하지 않는 이유는
    * Gradient가 존재하는지도 알 수 없는 Black Box 인 경우가 많다
    * 한 번 테스트 하는 비용이 너무 커서 최소한의 실험을 시도하고자 하기 때문이다
* BO를 머신러닝 문제에 적용하기 위해 논문에서는 다음과 같은 것들을 제안한다
    * Covariance Function 제안 (Matern 5/2)
    * Modeling Cost 반영 (걸린 시간)
    * 병렬처리를 위한 Acquisition Function 예측 (Monte Carlo Acquisition)
