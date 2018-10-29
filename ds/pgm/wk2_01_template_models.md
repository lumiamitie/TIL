
# Template Models

## Overview of template models

* 그래피컬 모형을 여러 케이스에 적용할 수 있도록 확장해보자
    * 특정한 케이스에 맞는 모형이 아니라 다양한 문제를 다룰 수 있도록 일반화시키고자 한다
* Genetic Inheritance 예제
    * input : pedigree => 특정한 trait에 대해 추론하고자 한다
    * 가계도를 바탕으로 베이지안 네트워크를 구성할 경우, 대상자를 추가하거나 다른 가계도에 대해 비슷한 것들을 적용할 수 있다
        * 이런 경우에 동일한 아이디어를 재사용할 수 있으면 좋지 않을까?
        * "Sharing between models"
    * 모형 내에서도 공유할 수 있는 것들이 있다 (Sharing within model)
        * Genotype -> Bloodtype 으로 영향을 미치는 프로세스는 모든 사람에게 동일하게 발생한다
        * 어떤 사람의 genotype은 부모의 genotype에서 영향을 받는다
    * 거대한 모형을 비교적 적은 파라미터를 통해 표현할 수 있을까?
* NLP Sequence Models
    * Sequence model을 이용한 named entity 인식 문제
    * 각 단어마다 어떤 종류의 단어인지에 대한 latent variable이 존재한다
    * parameter를 재사용하는 것이 도움이 될 수 있다
* Image Segmentation
    * Sharing across superpixels or pixels
        * 각 superpixel이 무엇을 의미하는가
        * Edge potential
        * Pairs of adjacent superpixels
    * Sharing between models
* The University Example
    * 어떤 학생이 수업을 듣고 학점을 받는다. 학점은 수업 난이도의 영향을 받는다
    * 특정 학생이 아니라 대학 전체를 대상으로 모형을 구축한다면??
        * 다양한 난이도, 수업, 학생 등 변수가 존재한다
        * 각 학점 변수는 연관된 수업, 학생 등의 변수에서 영향을 받는다
        * Dependency structure와 CPD는 각 모형이 동일하다
* Robot Localization
    * Time Series 문제
        * 로봇은 시간이 지남에 따라 이리저리 움직인다
        * 로봇이 움직이는 방식 자체는 고정되어 있음 (We expected the dynamics of the robot are fixed)

* Template Variables
    * Template variable X(U_1 , ... , U_k) is instantiated (duplicated) multiple times
    * 모형 내에서 사용되기도 하고, 모형간에 사용되기도 한다
* Template Models
    * 변수 (Ground variables) 들이 템플릿으로부터 의존 관계를 어떻게 상속받는지 표현한다
    * Dynamic Bayesian Networks
        * temporal process
    * Object-relational models
        * Directed
            * Plate models
        * Undirected


## Temporal Models - DBNs

Template 모형 중에서 자주 쓰이는 것 중 하나는 시간에 따른 변화를 표현하는 Temporal Models 이다

### Distributions over Trajectories

연속적인 시간의 변화에 따른 분포를 표현할 때 가장 먼저 해야하는 것은 시간이 연속적이라는 생각을 버리는 것이다. 왜냐면 연속적인 값은 훨씬 다루기가 어렵기 때문이다. 따라서 우리는 시간을 discretize 시켜서 잘게 쪼갠 delta 값을 사용한다.

* delta : time granularity
* 센서 등을 통해 수집한 데이터라면 수집한 단위로 사용한다
* `X(t)` : Variable X at time t delta
* `X(t:t') = {X(t) , ... , X(t')} (t <= t')`
    * set of variables between t and t'
* Our goal
    * Want to represent `P(X(t:t')) for any t, t'`
    * 보통 특정 시점을 0으로 두고 시작한다
* 그렇다면 어느 정도의 시간을 표현할 수 있을까??

### Markov Assumption

시간에 대한 길이 제한이 없다면 무한한 시간에 대한 분포를 표현해야 할 지도 모른다. 어떻게 하면 더 간결하게 표현할 수 있을까??

* **Markov Assumption** 은 조건부 독립 가정의 일종이다
* `( X(t+1) ㅗ X(0 : t-1) | X(t) )`
    * 현재(x=t)의 값이 주어졌을 때, 다음 시점(t+1)의 값은 이전의 값들(0 : t-1)과 독립이다
* 현재 시점의 값을 알면 과거의 값에 대해서는 생각할 필요가 없다 (Forgetting assumption)
* 상당히 강한 가정이다
    * 움직이는 로봇의 다음 위치를 현재 위치만 보고 파악할 수 있을까? No
    * 속도 (방향성을 포함) 가 중요하기 때문에 과거의 위치가 영향을 미칠 수 밖에 없다
    * 따라서 보다 정확하게 추정하기 위해서는 더 많은 변수를 사용해야 한다
        * ex. V(t) : Velocity over time
* 또 다른 전략으로는 일부 과거 시점에 대한 의존성을 모형에 포함시키는 방법도 있다
    * 이전 위치를 모형에 일부 포함시키는 것
    * Semi-Markov model

### Time Invariance

* 모형을 단순화시키기 위한 또 다른 가정은 바로 시간 불변성 (Time Invariance) 이다
    * 로봇의 위치는 시간에 따라 변하지만, 로봇이 움직이는 역학 자체는 변하지 않는다
    * 특정한 상황에서만 보장될 수 있는 가정이라는 것을 명심해야 한다
    * ex. 도로의 교통상황은 시간에 따라 달라진다
* 이 경우에도 모형을 구성하는 변수를 추가하는 방식으로 보완할 수 있다
    * 시간대, 요일, 부근의 행사 등등

### Template Transition Model

* 변수 설명
    * **W**eather, **V**elocity, **L**ocation, **F**ailure (센서 오작동 여부), **O**bs (센서정보)
* `P(W', V', L', F', O' | W, V, L, F)`
    * `= P(W' | W) P(V' | W, V) P(L' | L, V) P(F' | F, W) P(O' | L', F')`
    * O는 다음 시점의 state에 영향을 주지 않기 때문에 조건에 포함되지 않는다
    * 전체 네트워크가 아니라 Time 단위의 네트워크 조각과 조각간의 관계로 표현할 수 있다
    * 여전히 Chain Rule을 적용할 수 있다
* 몇 가지 중요한 점이 있다
    * 특정 시점 뿐만 아니라 시점 간에도 의존성이 존재한다
        * ex. `P(O' | L', F')` : 시점 내 의존성
        * ex. `P(F' | F, W)` : 시점 간 의존성
    * 시점 내 의존성 => Intra-time-slice edges
    * 시점 간 의존성 => Inter-time-slice edges
    * Persistence edges
        * Inter-time-slice edges의 일종
        * t에서 t+1로 향하는 변수
    * t+1 시점의 CPD를 t와 t+1 시점 사이의 네트워크 관계를 통해 표현한다

### Initial State Distribution

* 전체 시스템에 대한 확률 분포를 알려면 초기값에 대한 확률 분포 또한 알아야 한다
* t=0 시점에 대한 확률분포를 일반적인 베이지안 네트워크를 이용해 표현한다

### Ground Bayesian Network

* 이제 위 두가지를 합치면 임의의 시점에 대한 확률 분포를 구할 수 있다
	* Template Transition Model
	* Initial State Distribution

### 2-time-slice Bayesian Network

위 표현을 조금 더 형식적으로 하기 위해서 2-time-slice Bayesian Network 이라는 것을 정의한다. (2TBN이라고도 부른다)

* 템플릿 변수 X1, ... , Xn에 대한 2TBN은 다음과 같은 BN 조각으로 표현될 수 있다:
    * t+1 시점의 변수 `X'1, ... , X'n` 와 t 시점의 변수 `X1, ... , Xn`의 subset
    * 노드 `X'1, ... , X'n` 만이 부모 노드와 CPD를 가진다
* 2TBN은 chain rule을 사용해서 conditional distribution을 정의한다

### Dynamic Bayesian Network (DBN)

변수 X1, ... , Xn 에 대한 DBN은 다음 항목들을 통해 정의할 수 있다.

1. X1, ... , Xn에 대한 2TBN BN
2. t=0 시점에 대한 베이지안 네트워크

### Summary

* DBN은 임의의 시점의 확률분포를 간결하게 표현하는 방법이다
* Markov Assumption, Time Invariance 등의 가정을 바탕으로 한다
    * 현실을 더 잘 반영하기 위해 추가적인 변수를 반영해야 할 수 있다


## Temporal Models - HMMs

### Hidden Markov Models

* Hidden Markov Models을 가장 단순한 형태로 표현해보면 다음과 같은 구조를 가진다
    * 두 가지 변수가 존재한다
        * A state variable S
        * An observation variable O
    * Transition Model
        * S에서 S' 으로 transition이 발생한다
    * Observation Model
        * State가 주어졌을 때 우리가 어떻게 관측하게 될지 나타낸다
* 내부 구조가 매우 다양하다
    * 보통은 transition 과정에서 그러한 구조가 발생하지만, observation에서 발생하기도 한다
    * State가 어떻게 transition 되는지 CPD를 통해 표현할 수도 있다 ( `P(S' | S )` )
    * 단순하게 동일한 구조가 반복될 수도 있다
* 다양한 분야에서 활용되고 있다
    * Robot localization
    * Speech recognition
    * Biological sequence analysis
    * Text annotation


### Robot Localization

* 로봇의 위치를 파악하는 HMM 모형을 살펴보자
* 변수
    * State Variable S
        * 시간에 따른 로봇의 위치와 방향을 나타낸다 (position and orientation)
    * External control signal U
        * 로봇에 행한 명령 (왼쪽으로 이동, 오른쪽으로 이동 등등)
        * 우리가 직접 관찰할 수 있고, 외부에서 주입되기 때문에 확률 변수 (stochastic random variable)가 아니다
        * 그냥 시스템에 주어지는 input
    * Observation variable O
        * 관측된 로봇의 위치
        * 로봇의 위치뿐만 아니라 지도상의 위치에도 영향을 받는다
    * Map은 변하지 않기 때문에 하나의 노드로만 표현한다
* 기본적으로는 State와 Observation으로 이루어진 구조에 일부 다른 변수가 추가된 구조이다


### Speech Recognition

* 음성 인식 분야에서는 HMM이 성공적으로 많이 활용되었다
* 음성으로 된 문장이 주어졌을 때 노이즈를 제거하고 가장 가능성이 높은 형태의 문장으로 반환한다
* 어떻게 동작할까?
    * 주파수를 푸리에 변환하여 음절단위로 쪼갠다
    * 쪼개진 단어들을 순서대로 모아서 어떤 단어에 해당하는지 추론한다
    * 각각의 발음에 대응하는 알파벳 문자를 연결한다 ( Phonetic Alphabet )
    * Word HMM
        * 단어를 음소 단위로 쪼개는 HMM 모형
        * self transition loop도 존재한다
    * Phone HMM
        * 음소에 대한 HMM 모델링
        * 특정한 발음에 대해서 처음, 중간, 끝의 state가 존재한다
    * Recognition HMM

### Summary

* HMM은 DBN의 일종으로 볼 수 있다
* HMM은 확률 변수들만 보면 특정한 구조를 가지지 않는 것 처럼 보인다
* HMM 구조는 transition 행렬에서 sparsity나 변수가 반복되는 등의 구조를 주로 보인다
* sequence를 모델링하는데 HMM이 많이 사용된다
