
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


## Plate Models

동일한 타입의 오브젝트가 여러 개 존재할 경우 반복적인 구조가 나타날 때가 많다. 이러한 경우를 다루는 가장 일반적인 모형 중 하나가 바로 **Plate Model** 이다

### Modeling Repetition

* 동일한 동전을 반복해서 던지는 경우를 생각해보자
* t번째 던지는 동전의 결과를 나타내는 Outcome 변수가 있다고 해보자
    * 이것을 plate라고 한다
        * 여러 개의 판을 겹쳐서 쌓아놓은 것에 착안해서 plate라고 한다
    * Plate라고 하는 박스 안에 Outcome 변수가 들어 있다
        * Outcome 변수에 인덱스가 부여되어 있는 형태가 된다 ( Outcome(t) )
        * 각 동전을 던지는 것을 {t1, ..., tk} 라고 한다면, 그에 대한 Outcome 변수인 Outcome(tk) 가 존재한다
* 이제 CPD의 파라미터 값을 모형 바깥에서 주입한다
    * 여기서 주입하는 확률 변수 theta가 바로 CPD의 실제 파라미터 값이다
    * theta는 plate 바깥에 존재한다
        * = t값에 대해 인덱스 되어있지 않다
        * = t값과 상관없이 항상 동일하다
        * theta -> Outcome(t1) , .... , theta -> Outcome(tk)

* University Example
    * 각 학생 s에 대해서 Intelligence -> Grade 의 Plate를 구성한다
        * Intelligence와 연결되는 파라미터 `theta_i`, Grade 변수와 연결되는 `theta_g`가 존재한다
        * Plate를 복사하더라도 동일한 theta 값이 적용된다
    * 파라미터값이 전체 plate 바깥에서 주입될 경우 모형에서 명시하지 않는다

### Nested Plates

* 모형에 몇 가지 종류가 필요한 상황을 생각해보자
    * 수업을 나타내는 변수 c, 학생을 나타내는 변수 s가 존재한다
    * Difficulty 변수는 수업의 속성이기 때문에 Plate 안쪽에 존재한다
    * 이제 학생들과 관련된 변수는 어떻게 배치해야 할까??
* 한 가지 방법은 plate를 중첩시키는 것이다
    * course plate 내부에 student plate가 있다
    * 중첩된 student plate는 이제 s, c 값으로 인덱스가 부여된다
* 이러한 모형에서는 학생의 Intelligence 가 Course 의 영향을 받는다
    * 어떤 수업을 듣는지에 따라 Intelligence 값이 달라진다
    * 수학, 미술 등 과목에 따라 학생의 Intelligence 값이 달라진다
    * 하지만 비슷한 과목만 수강하고 있다면 이렇게 모형을 복잡하게 하지 않고 같은 Intelligence 값을 사용할 수 있지 않을까?

### Overlapping Plates

* 위와 같은 문제를 해결하기 위해 다른 표현 방법을 사용할 수 있다
    * 이제 각각의 plate는 중첩되는 것이 아니라 서로 겹쳐있도록 모형을 구성해보자
    * 이제 모형에서 Intelligence는 student 변수에만 영향을 받는다
        * Nested 모형에서는 student, course 양쪽의 영향을 받았다
* Nested와 Overlapping 중에서 어느 모형이 맞고 틀리다고 할 수는 없다
    * 주어진 상황에 맞는 모델링을 하면 된다

### Explicit Parameter Sharing

* 여기서도 각 plate 간에 파라미터를 공유할 수 있다
* 파라미터 공유를 명시적으로 표현할 수 있다

### Collective Inference

* 왜 이러한 Plate 모형이 유용한걸까? 여러 가지 변수가 존재하는 상황을 가정해서 살펴보자
* 신입생 A가 학교에 입학했다
    * 학생들 중에서 80% 정도는 똑똑하다는 사전의 믿음이 있었다
    * A는 두 개의 수업을 수강한다
        * Geo101에서는 A를 받았다 => A의 Intelligence에 대한 확률이 올라간다
        * CS101에서는 C를 받았다 => A의 Intelligence에 대한 확률이 조금 내려간다
    * CS101에서 C를 받더라도 확률이 크게 떨어지지는 않는다. 처음에 80% 정도는 똑똑할 것이라고 확률을 설정했기 때문이다
    * 수업이 어려워서 모두가 낮은 학점을 받았을 수도 있다. 현재까지 가지고 있는 정보만으로는 자세하게 추정하는데 한계가 있다
* Collective Inference
    * 쉬운 수업, 어려운 수업 / 똑똑한 학생, 그렇지 않은 학생들이 이리저리 연결되어 있는 상황을 생각해보자
    * CS101을 보니 다른 학생들은 A를 많이 받았다는 것을 알 수 있다.
        * 따라서 이러한 관점에서 보면 CS101은 쉬운 수업이라고 할 수 있다
        * 그리고 쉬운 수업에서 C를 받았다면 A가 똑똑할 확률은 더 크게 떨어질 것이다

### Plate Dependency Model

* Template Variable 에 대한 dependency 모형은 다양한 형태의 오브젝트에 인덱스를 부여한 형태로 정의할 수 있다
    * 템플릿 변수 A(U1, ... , Uk)
        * 앞선 예제의 템플릿 변수 G(s, c) 에서 G가 A에 해당되고, s와 c가 인덱스 U1, U2에 해당된다
        * I(s) -> G(s, c) , D(c) -> G(s, c)
    * 부모 노드는 자식 노드에 없는 인덱스를 가질 수 없다
        * 그렇게 되면 CPD가 구성되지 않기 때문이다
        * 위와 같은 제약조건이 없다면 부모노드가 될 수 있는 노드의 종류에 제한이 없다
        * 전통적인 형태의 모형에서는 유한하고 고정된 수의 부모 노드를 가지고 template의 CPD를 구성한다

### Ground Network

* 템플릿 변수 A(U1, ... , Uk) 와 그에 연결되는 부모노드 B1(U1) , ... , Bm(Um) 이 존재한다
* 특정한 학생이 특정한 수업을 들었을 때의 학점은 수업의 난이도와 학생의 지능에 의존한다
    * D(c) -> G(s, c)
    * I(s) -> G(s, c)

* 다시 Plate Dependency Model에 대한 이전의 정의로 돌아와서, 부모노드는 자식노드에 없는 인덱스를 가질 수 없다는 내용을 추가한다

### Summary

* 템플릿 모형을 통해 무한대의 베이지안 네트워크를 표현할 수 있다
    * 각각의 네트워크는 서로 다른 종류의 변수들로 구성된다
* 파라미터와 구조는 BN 내에서, 또는 서로 다른 BN 간에 재사용될 수 있다
* 모형을 통해 여러 객체들 사이의 상관관계를 표현할 수 있다
    * 따라서 collective inference가 가능해진다
* plate 모형은 템플릿 모형 중에서 가장 간단한 형태의 모형이다
    * 하지만 단순하기 때문에 모든 경우에 대해 동작하지는 않는다
    * 예를 들면 temporal model에는 적용할 수가 없다.
        * X(t-1)은 X(t) 에 의해 instantiated 되지 않기 때문
        * 따라서 plate 모형에서는 X(t-1)을 부모 노드로 가질 수 없다
* 제한적인 모형이고 다른 방식으로 접근하는 방법론들도 많다
    * 하지만 각각의 접근법에는 장단점이 있다
