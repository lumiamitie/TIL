# Local Structure in Markov Networks

## Log-Linear Models

전체 테이블을 필요로 하지 않는 Local Structure는 directed / undirected 구분과 상관없이 중요하다. Undirected 모형에 Local Structure를 포함시키려면 어떻게 할까? 이러한 작업을 위한 프레임워크를 바로 Log-Linear 모형이라고 한다. 

### Log-Linear Representation

* 기존에는 unnormalized density를 표현하기 위해서 P tilde 를 정의했다. 
    * 이 값은 factor들을 모두 곱한 값이다. 전체 확률 분포를 표현할 수 있다 (Full Table)
* 이번에는 Linear form을 따르도록 표현하는 방식을 변경한다
    * logarithm 부분이 선형 관계를 구성하기 때문에 Log-Linear 모형이라고 한다
    * Factor 대신 Linear Function 을 통해 분포를 표현한다
        * Coefficient * Feature 의 형태
        * Feature는 factor 처럼 각각의 scope를 갖는다
        * 서로 다른 feature 들이 같은 scope를 가질 수 있다
        * 각각의 feature에 해당하는 파라미터 Wj 가 존재하여 feature 값에 곱해진다
    * Summation 형태를 바꾸어보면, PROD( exp( -Wj * Fj(Dj) ) ) 형태가 된다
        * 따라서 exp( -Wj * Fj(Dj) ) 부분이 기존의 factor와 같은 역할을 수행한다
        * 하지만 파라미터는 단 한개에 불과하다 ( Wj )

### Representing Table Factors

* 간단한 factor 테이블을 가지고 어떻게 log-linear 모형으로 변환시킬 수 있을지 살펴보자
* X1, X2가 binary 변수일 때, phi(X1, X2) 는 4가지 파라미터 a00, a01, a10, a11을 갖는다
* 이것을 log-linear 모형으로 표현하기 위해서는 Indicator Function을 통해 feature를 정의해야 한다
    * ex) f_{12}^{00} = 1{X1 = 0, X2 = 0}
        * X1 = 0, X2 = 0 이라면 1, 그렇지 않을 경우 0을 나타낸다
    * k, l 각각의 entry에 대해 모든 값을 더한다 : `sum( weight * feature )`
    * a00 을 계산해보면 exp( -w00 ) 이 된다
        * w00 = - log(a00)
        * 따라서 `W_{kl} = - log a_{kl}` 라고 정리할 수 있다
* 이것은 일반적인 표현법이다. 따라서 factor로 표기할 수 있는 것들은 log-linear 모형으로 표현할 수 있다.

### Features for Language

* Language Model 에서는 다음과 같은 feature가 있다
    * 변수 Y : 단어가 속하는 카테고리
        * 이름의 시작, 장소의 시작, 장소를 나타내는 단어의 중간 등등
    * 변수 X : 문장 내에 존재하는 실제 단어
* 이제 이 모형에 대해서 테이블 형태로 모든 항목을 표현하면 어떻게 될까?
    * 모든 영어단어들 각각에 대한 값을 계산해두어야 한다
    * 계산량이 매우 많아지고, 파라미터 수 또한 많아진다
* 다음과 같이 Feature를 정의할 수 있다 : `f( Yi, Xi )`
    * f( Yi, Xi ) = 1{ Yi = person, Xi is capitalized }
        * Yi : i번째 단어의 레이블
    * f( Yi, Xi ) = 1{ Yi = Beginning of location, Xi appears in Atlas }
    * 각 feature의 weight 들은 Yi 레이블에 대한 확률을 조정한다

### Ising Model

* 또 다른 feature-based 모형에 대해 살펴보자
* Ising Model 은 통계 역학과 관련된 모형이고, Pairwise Markov Network에 해당된다
* 각각의 변수는 binary 이지만, {0, 1} 대신 {-1, 1} 로 구성되어 있다
* 모형의 파라미터는 인접한 변수들의 곱으로 구성된다 : `f_{i, j}(Xi, Xj) = Xi * Xj`
* 그리드에서 전자들의 스핀을 모델링하는 경우를 생각해보자
    * 전자들의 회전 방향은 인접한 전자들의 방향에 의존한다
    * 1 * 1 = -1 * -1 = 1 이므로, 두 전자의 스핀 방향이 같은지 다른지만 확인하면 된다
    * 따라서 Feature는 Xi * Xj
* 온도의 형태를 통해서 설명할 수도 있다
    * 온도 T가 높아질수록, Wij / T 이 점점 0에 가까워진다
        * 인접한 원자들 간의 연결이 느슨해진다는 것을 의미한다
    * 온도 T가 낮아질수록, weight가 점점 강해진다. 따라서 원자들의 움직임에 더욱 큰 제약이 가해진다

### Metric MRFs

* 실제로 많이 활용되는 feature로 MRF의 metric feature가 있다
* 모든 확률 변수 Xi가 label space V에서 값을 가지는 상황을 생각해보자
    * 그리고 두 변수 Xi, Xj 는 서로 edge를 통해 연결되어 있다
    * 연결된 두 변수는 비슷한 값을 가졌으면 한다
* "비슷하다" 라는 것을 정의하기 위해 Distance function을 정의한다 `( u : V x V -> R+ )`
    * Distance function 는 다음과 같은 조건을 만족해야 한다
        * Reflexity : 모든 v에 대해서 u(v, v) = 0
        * Symmetry : 모든 v1, v2에 대해서 u(v1, v2) = u(v2, v1)
        * Triangle inequality : 모든 v1,v2,v3에 대해서 u(v1, v2) <= u(v1, v3) + u(v3, v2)
    * Distance가 만약 Reflexity + Symmetry 만 만족할 경우, Semi-Metric 이라고 한다
        * 세 가지 가정 모두 만족한다면 metric이라고 한다

* 위에서 살펴본 distance feature를 MRF에 어떻게 적용할 수 있을까?
    * `Fij(Xi, Xj) = u(Xi, Xj)`
    * 0보다 큰 값인 Wij를 곱한다
        * `exp(-Wij * Fij(Xi, Xj))`
        * 거리가 작아질수록 위 식의 값이 커진다 ( = 확률이 커진다)
    * 거리가 가까워질수록 확률이 높아진다는 것을 의미한다

### Metric MRF Examples

* 간단한 형태의 metric MRF 에 대해 살펴보자
* (1) u(vk, vl) :
    * 0, if vk = vl
    * 1, otherwise
    * => 행렬로 표현해보면, diagonal에는 0이 있고 그 외에는 1이 있는 형태가 된다
* (2) u(vk, vl) = vk - vl
    * |vk - vl|
* (3) u(vk, vl) = vk - vl : ( truncated linear penalty )

### Metric MRF : Segmentation

* Image Segmentation에도 Metric MRF가 사용된다
* u(vk, vl) = 0 if vk = vl, 1 otherwise
* 근저의 superpixel이 같은 클래스를 가지는 경우 페널티를 주지 않고, 다른 경우 1 값을 부여해 페널티를 준다
* 간단하지만 많이 사용되고 있다

### Metric MRF : Denoising

* 이미지에서 노이즈를 줄이는데도 사용된다
    * 변수 X : 노이즈가 포함된 픽셀
    * 변수 Y : 노이즈 없이 깔끔한 픽셀
* X와 Y의 관계를 나타내는 모형을 구성한다
* 인접한 픽셀은 같은 값을 가질 것이라고 가정한다
    * 따라서 멀어질수록 페널티를 부여한다
    * 하지만 거리에 따라 페널티를 부여할 경우 실제로는 굉장히 불안정한 모형이 도출된다
    * 어느 정도 임계점을 넘어갈 경우 페널티를 일정하게 유지할 수 있다
        * 일정 거리 이상 떨어진 픽셀들과는 어차피 연관이 없을 것이다
