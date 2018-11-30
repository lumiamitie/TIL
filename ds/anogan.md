# AnoGAN

PR-115 Unsupervised Anomaly Detection with Generative Adversarial Networks

* youtube: https://youtu.be/R0H0gqtnMyA
* paper: https://arxiv.org/abs/1703.05921
* 발표자료: https://www.slideshare.net/MingukKang/anomaly-detection-121788059
* 참고자료
    * https://www.slideshare.net/ssuser06e0c5/anomaly-detection-with-gans
    * https://blog.lunit.io/2017/06/13/ipmi-2017-unsupervised-anomaly-detection-with-gans-to-guide-marker-discovery/
    * https://kangbk0120.github.io/articles/2018-01/ano-gan
    * 구현체 : https://github.com/tkwoo/anogan-keras


# 1. Motivation

1. 데이터 부족
    * 환자의 처방을 위해서는 좋은 진단이 필요하다
    * 정확한 진단을 위해 이중으로 진단을 내려보면 좋겠다 (의사 + 모델링)
    * 그런데 의료 데이터의 특성상 데이터를 모으기가 어렵다
    * 특히 abnormal 한 상태의 데이터를 모으는 것이 어렵다
2. 이미지 정보를 전부 활용하지 못한다
    * 특정한 질병의 상태와 관련이 있는 이미지상의 특징들이 존재한다
    * 하지만, 예측을 위한 feature가 부족한 경우도 있고, feature의 예측력이 떨어지는 경우도 존재한다
3. 데이터 불균형 문제
    * 정상 데이터는 많고 비정상 데이터는 적은 클래스별 불균형이 발생하기 쉽다
4. 라벨링 문제
    * 클래스별 데이터가 균등하게 존재한다고 하더라도 각각의 이미지에 대해서 상세한 라벨링이 필요하다

**양이 많은 normal 데이터를 사용하여 unsupervised 방법론으로 문제를 해결해보자**

# 2. Training

간단하게는 다음과 같은 과정을 거친다

1. 영상의 프레임을 잘라서 얻은 이미지에 전처리 작업을 수행한다
    * GAN에서 적용할 수 있는 해상도에는 한계가 있기 때문
    * 임의의 지점을 잘라서 정상 데이터를 구성하고 해상도는 64x64로 조절한다
    * 논문에서는 망막에 대한 이미지를 학습했다
2. 전처리를 통해 얻은 정상 데이터를 가지고 모형을 학습한다
3. 테스트하고자 하는 데이터를 모형에 적용해서 정상/비정상 여부를 판단한다
    * 어떤 부분 때문에 정상 데이터가 아니라고 판단했는지 확인할 수 있다

세부적인 프로세스를 살펴보자

![png](https://github.com/tkwoo/anogan-keras/blob/master/image/loss.png?raw=true)

1. GAN을 학습한다
    * Normal 데이터를 통해 Generator와 Discriminator를 구성한다
    * Normal 데이터에 대해서 유의미한 정보를 가지도록 Latent Space를 학습한다
        * 해당 Latent Space를 Generator에 넣으면 이미지가 생성된다
        * 여기서는 일반적인 GAN에서 사용하는 Loss와 같은 것을 사용한다
2. 새로운 이미지를 Latent Space에 맵핑한다
    * Latent Space에서 랜덤하게 샘플링하여 이미지를 생성한다 (=G(z1))
    * 판별하고자 하는 이미지와 비교하기 위해 Loss를 계산한다
        * Residual Loss와 Discriminator Loss를 선형으로 결합한 Total Loss를 사용한다
        * **Residual Loss**
            * Real Sample에서 온 타겟 이미지와 Latent Space가 Generator를 통해 맵핑된 이미지의 L1 Distance를 Residual Loss 라고 정의한다
            * 시각적으로 얼마나 다른지 측정하는 역할을 한다
            * `Lr(z) = SUM( | x - G(z) |)`
        * **Discriminator Loss**
            * 이미지를 Discriminator에 넣고 계산한 Loss
            * Discriminator의 분류 결과 대신, 특정 layer f 의 Feature를 사용한다
                * Discriminator를 classifier 대신 feature 추출기로 사용한다
            * 생성된 이미지를 latent space에 강제로 맵핑시키는 역할을 한다
            * `Ld(z) = SUM( | f(x) - f(G(z)) | )`
        * **Total Loss** `= (1 - lambda) * Residual Loss + (lambda) * Discriminator Loss`
            * 논문에서는 lambda = 0.1 값을 사용
            * Real Data의 샘플이 정상 데이터라면, Residual Loss 와 Discriminator Loss 가 낮게 나올 것이다
    * 이제 Generator와 Discriminator의 weight를 고정시키고 Latent Space를 학습한다
        * 모든 weight를 고정시키고 Loss를 최소화하는 Z를 찾는다 (BackPropagation)
            * = Query Image x가 주어졌을 때, 생성된 이미지 G(z)가 x에 최대한 비슷해지도록 하는 latent space 상의 점 z를 찾는다
        * 한 번에 최적화는 안되고, Z1, Z2, Z3, ... 각각에 대해 차례대로 적용하는 것을 반복한다
            * 논문에서는 500번 정도 반복했음
        * 반복하고 나면 정상 케이스에 해당하는 Real Sample과 유사한 이미지를 만들어 낼 것이다
            * 반면에 비정상 케이스에 해당하는 샘플에는 잘 작동하지 않는다
            * 비정상 feature의 latent vector를 잘 찾지 못한다
        * Discriminator에서 Total Loss를 비교하면 정상 케이스보다 비정상 케이스에서 더 높은 값이 나온다
3. Anomaly Score를 구한다
    * Anomaly Score `= Total Loss = (1 - a) * RL + (a) * DL`
        * Residual Loss와 Discrimination Loss의 선형결합으로 표현된다
    * Residual Image
        * 목표로 하는 target image와 생성된 이미지 간의 차이의 절대값
        * Residual Image `Xr = | X - G(Zr) |`
        * 이렇게 할 수 있는 이유는 Generator 자체가 정상 이미지를 생성하도록 학습되었기 때문

* Summary?
    * Generator를 Normal한 데이터에 대해서 학습시킨다
    * 학습한 GAN 모형을 바탕으로 Gradient Descent를 적용하여 Latent Vector 를 찾는다
    * Anomaly Score를 계산한다

# 실험 과정

1. 데이터셋
    * Train Data  : 100만개의 2D 패치, 그레이스케일, 64x64 pixel
    * Test Data : 8192개의 패치
        * Normal / Abnormal 비율은 논문에서 알 수 없었다
2. GAN 아키텍쳐
    * DCGAN을 사용했다
    * 원래의 DCGAN은 RGB 값을 사용하는데 논문에서는 그레이스케일만 사용하기 때문에 채널을 줄였다
        * DCGAN : 1024 -> 512 -> 256 -> 128 -> 3
        * AnoGAN : 512 -> 256 -> 128 -> 64 -> 1
3. 성능
    * 어떤 기준으로 정상/비정상을 나누는지 Decision Boundary가 굉장히 불분명하다 (주관적 기준)
    * 논문에서는 ROC 커브와 AUC를 사용하여 성능 평가
        * 데이터의 클래스 비율이 불균형하게 분포되어 있을 때문에 Accuracy를 적용하기는 어렵다
    * Total Loss를 다른 방식으로 사용하여 약간의 성능 향상이 있었다
        * 원래는 Discrimination Loss를 Feature Space 상에서의 Perceptual L1 Loss로 정의
        * Generator가 Discriminator를 속이기 위한 Loss로 대체한다

![png](https://bloglunit.files.wordpress.com/2017/06/fig3.png)

# 결론

* GAN을 사용해서 Anomaly Detection을 수행한 첫 번째 논문
* 학습 과정에는 포함되지 않았던 이상 케이스에 대해서도 잘 판별해내는 결과를 얻었다
* 논문에서 자체적으로 정의한 Loss를 사용했을 때 작게나마 성능이 향상되었다

# 문제점

* Decision Boundary를 잡는 기준이 주관적이다
* Discrimination Loss 를 변형하여 적용했지만 큰 성능 향상을 거두지 못함
* Inference를 위해 Latent Vector를 구해야하는데, 이 과정에서 Back Propagation이 필요하기 때문에 Inference 하는데 시간이 많이 소요된다
