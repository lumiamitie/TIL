# Decision Theory

## Maximum Expected Utility

그동안의 강의를 통해 확률론적 그래피컬 모형을 통해 다양한 추론 문제를 해결할 수 있다는 것을 알 수 있었다. 하지만 가끔은 확률 분포를 통해 의사 결정을 내리고자 할 때가 있다. 예를 들면, 의사가 환자를 진단할 때 어떤 질병인지 파악하는 것 만으로는 충분하지 않다. 궁극적으로 필요한 것은 어떤 처방을 내려야 할지 결정하는 것이다. 확률론적 그래피컬 모형을 통해 의사결정을 내리기 위해서는 어떻게 해야 할까?

확률론적 그래피컬 모형이 등장하기 이전 부터 의사결정을 위한 방법론이 연구되고 있었다. 이것을 Maximum Expected Utility 라고 한다. 여기서 정의하는 문제를 알아보고 MEU 의 원칙들을 정의해보자


### Simple Decision Making

* 의사 결정이 필요한 상황을 구성해보자 ( 상황 D에서 내릴 수 있는 의사결정 )
    * 액션 A : `Val(A) = {a^1, ... , a^k}`
        * a^i 는 각각의 선택을 의미한다
    * 상태 X : `Val(X) = {x^1, ... , x^N}`
        * 특정한 액션을 통해 변화시킬 수 있는 상태가 있다. 변화시킬 수 없는 상태도 있다
    * 각각의 상태는 액션의 영향을 받는다 (Distribution) : `P(X | A)`
    * 액션을 통해 얻을 수 있는 효용이 있다 (Utility Function) : `U(X, A)`


### Expected Utility

* Expected Utility for a decision (problem) D, given an action A
    * `EU(D(a)) = SUM_x( P(x | a) * U(x, a) )`
    * 확률분포를 utility function과 곱하고, x에 대해서 모두 더한 값
* 우리는 기대 효용을 극대화시키는 액션 a 를 선택하고자 한다


### Simple Influence Diagram

이번에는 의사결정 상황을 그래피컬 모형의 방식으로 풀어보자

* Entrepreneur Example
    * 베이지안 네트워크 형태로 구성했다. 기존의 BN과 비교하면 두 가지 요소가 추가되었다.
    * Node
        * (Market) : 확률변수 (State Variable)
            * poor / moderate / great
        * [Found] : Action Variable
            * do not found / found
        * <U> : Utility
    * Edge
        * Market -> U
        * Found -> U
* Utility Function 의 값은 <시장 상황>과 <액션>의 영향을 받는다
    * Market, Found 모두 Utility 변수의 부모 노드이다
    * = Utility 변수는 Market, Found 변수에 의존한다 ( u(F, M) )
* Expected Utility를 계산해보자
    * do not found company : EU(f0) = 0
    * found company : EU(f1) = (0.5 * -7) + (0.3 * 5) + (0.2 * 20) = 2
    * 따라서 이 경우에 최적의 액션은 회사를 설립하는 것이다

### More Complex Influence Diagram

이번에는 더 많은 확률변수가 포함된 복잡한 모형을 가지고 살펴보자. 기존에 예시로 다루었던 Student 모형에 몇 가지 변수를 추가했다. 

* Student Example
    * 확률 변수 : Difficulty, Intelligence, Grade, Letter, Job
    * 액션 : Study (한다 / 안한다)
        * Study -> Grade : 공부 여부가 Grade 변수의 분포에 영향을 미친다
    * 효용 : Vg, Vq, Vs
        * Vg : 학점 자체로 얻는 행복감
            * 학점이 잘나오면 기분이 좋을 것이다
        * Vs : 커리어에 도움이 됨으로써 얻는 효용
        * Vq : 공부가 삶의 질에 미치는 영향
            * 공부를 안하면 다른 여가생활을 즐길 수 있으니 효용이 올라갈 것이다
        * 총 효용은 위 세 변수의 합으로 구성된다 :
            * Decomposed Utility Function = Vg + Vq + Vs
* 전체 효용을 나타내는 하나의 utility function 이 아니라 세 개로 나눈 이유는 무엇일까?
    * 서로 다른 factor 로부터 영향을 받기 때문이다
    * 단일 utility function을 구성할 경우 총 4개의 파라미터로 구성된 노드가 된다
    * 이렇게 되면 가능한 경우의 수가 너무 많아지기 때문에 오히려 모형이 더 복잡해진다

## Utility Functions

앞서 살펴본 influence diagram에서는 의사결정을 위한 utility function을 포함하고 있었다. 그리고 utility function은 다른 여러 가지 상태들을 고려한 "선호도" 를 나타냈다. 도대체 utility function이란 무엇이고, 어디에서 온 걸까?

### Utilities and Preferences

* Utility Function은 복잡한 불확실성이나 리스크를 포함한 시나리오들을 비교하기 위해 필요하다
    * 두 가지 복권이 있다고 해보자
        * 하나는 0.2의 확률로 $4mil, 0.8의 확률로 $0
        * 다른 하나는 0.25의 확률로 $3mil, 0.75의 확률로 $0
    * 둘 중 하나만 골라야 한다면 어떤 복권을 선택해야 할까?
    * 두 가지 시나리오를 utility 수치로 나타내고 MEU 원칙을 적용한다면, 의사결정을 보다 엄밀하게 수행할 수 있다
        * `0.2 * u(4mil) + 0.8 * u(0)` VS `0.25 * u(3mil) + 0 * u(0)`

### Utility = Payoff?

* utility는 우리가 얻게 될 금액과 선형적으로 비례할 것이라고 생각하는게 자연스러울 것이다
    * 따라서 $5는 $10에 비해서 절반 정도의 선호도를 가질 것이라고 생각할 수 있다
    * 하지만 이런 가정이 항상 맞는 것은 아니다
* 한 가지 예시를 살펴보자
    * 두 가지 복권이 있다
        * (1) 0.8의 확률로 $4mil, 0.2의 확률로 $0
        * (2) 1의 확률로 $3mil, 0의 확률로 $0
    * 사람들은 2번 복권을 선호하는 경향이 있다
    * 하지만 기대값을 계산해보면 3.2mil vs 3mil로 1번 복권이 더 높다

### St. Petersburg Paradox

* 이러한 종류의 선호도가 나타나는 현상을 St. Petersburg Paradox 라고 한다
* St. Petersburg Paradox
    * Fair coin을 앞면이 나올 때 까지 반복해서 던진다
    * n번 던져서 앞면이 나왔다고 하면, 2^n 만큼의 달러를 가져간다
    * 여기서 기대수익은 얼마나 될까?
        * 1/2 * 2 + 1/4 * 4 + 1/8 * 8 + ...
        * 따라서 기대수익은 양의 무한대가 된다
    * 기대수익이 무한대기 때문에 사람들이 많은 돈을 지불하더라도 게임을 시도하지 않을까?
        * 하지만 대부분의 경우 약 2달러 정도만 내려고 한다

* Utility 곡선을 통해 확인해보자
    * X축은 우리가 얻게되는 보상(달러)을 의미한다
    * Y축은 기대하는 Utility를 의미한다
* 몇 가지 시나리오를 비교해보자
    * $500을 받을 때의 utility를 보자 : U($500)
    * 리스크를 수반하는 상황이 존재할 수 있다
        * p의 확률로 $1000, 1-p의 확률로 $0 를 수령하는 경우 Utility Curve는 직선이 된다
        * p = 0.5 일 때의 Utility를 Ud 라고 해보자
        * Ud 는 U($500) 보다 작다
        * 따라서 이러한 경우에는 리스크를 걸고 50%의 확률로 $1000를 받기보단 확실하게 $500을 받는 것을 선호한다
    * Utility Curve 에서 Ud와 동일한 Utility를 갖는 지점이 $400 이라고 해보자
        * 이 지점을 Certainty Equivalent 라고 한다
        * 위와같이 0.5의 확률로 $1000, 0.5의 확률로 $0 를 수령하는 복권이 있다면 $400의 가격에서는 사람들이 구입할 수 있다
    * 기대수익과 Certainty Equivalent 의 차이 (여기서는 500 - 400) 을 Insurance/Risk Premium 이라고 한다
        * 이렇게 부르는 이유는 보험회사들이 돈을 버는 방식이기 때문이다
        * 리스크가 있는 상황에서는 사람들이 돈을 덜 가져가더라도 불확실성을 줄이고자 한다
* 이렇게 concave한 곡선 형태를 가지는 경우 (직선에 비해 위쪽으로 볼록)  "Risk averse" 라고 한다
    * 여기서는 사람들이 리스크를 피하고자 한다
* Utility가 직선인 경우 "Risk Neutral"
* Utility가 convex function인 경우 (아래로 볼록) "Risk Seeking" 이라고 한다
    * 도박사들의 경우 기대수익이 작더라도 크게 베팅하는 경향이 있다

### Typical Utility Curve

* 일반적으로 Utility 곡선은 다음과 같은 형태로 되어 있다
    * X축은 우리가 받기를 기대하는 금액을 나타낸다
    * 현재 상태에서는 x=0 위치에 존재한다
* 사람들이 돈을 버는 상황에서는 돈을 벌수록 이익이 적어지는 (diminishing returns) 형태를 보인다
    * "Risk averse" Behavior
    * 따라서 concave한 Utility Curve가 된다
    * 기대값보다는 확실한 수익을 원한다
* 반대로 손실에 대해서는 리스크를 추구한다
    * "Risk Seeking" Behavior
    * 낮은 확률의 큰 손실 > 높은 확률의 작은 손실
* 현재 상태 근처에서는 (x=0 부근) 보통 Risk Neutral 한 행동이 나타난다
    *  손실을 해도 조금 잃고, 돈을 벌어도 조금 번다
    * 불확실성에 대해 크게 고민하지 않는다
    * expected pay-off가 Utility와 매우 비슷해진다 (= Utility Curve가 직선에 가까워진다)

### Multi-Attribute Utilities

* Utility가 단순히 돈을 얻는 것이 아닌 다른 복잡한 요소의 조합일 수도 있다
* 이러한 경우에는 모든 요소들에 대한 선호도가 합쳐져서 하나의 Utility Function으로 구성되어야 한다
    * 돈, 시간, 행복 등등
    * 비행기 유지보수 여부를 결정하는 의사결정에서 돈만 고려한다면 유지보수를 최대한 하지 않는 선택을 할 수도 있다
    * 하지만 안전 등 다른 요소를 함께 고려했기 때문에 유지보수를 하는 선택을 내리게 된다
* 사람들에 삶에도 이러한 요소들이 적용된다
    * Micromorts
        * 1 micromort는 사망할 확률이 1/1000000 이라는 것을 의미한다
        * 1980년대에 1 micromort 가 $20 의 가치가 있다는 연구결과를 발표했다
        * 사람들이 위험을 감수하는 것 대비 얼마나 효용을 얻는지 평가할 수 있다
    * QALY (Quality-adjusted life year)
        * 의학적인 의사결정을 내리는 경우 사용한다

### Example : Prenatal Diagnosis

* 태아 검진 (Prenatal Diagnosis) 사례를 가지고 살펴보자
    * 아기가 어떤 유전적인 질병을 겪게 될지에 따라 다양한 변수들을 설정해두었다
        * 그 중에서도 다운 증후군에 주목했다 (Down's Syndrome)
    * 하지만 동시에, 다른 관점에서의 효용에 대해서도 고려한다
        * 예를 들면 다운 증후군을 검사하기 위해 겪어야 하는 고통도 포함한다 (Testing)
        * 앞으로 어떻게 될지 등 관련된 지식에 대해 얼마나 편안하게 느끼는지 (Knowledge)
    * 유산할 가능성에 대해서도 고려한다 (Loss of fetus)
    * 미래에 임신 가능한지 여부도 고려해야 한다 (Future Pregnancy)
* 위 다섯가지 요소를 모두 고려할 경우 파라미터 개수가 매우 많아진다 (2^5 = 32)
    * 하지만 많은 사람들이 Utility Function 내에 많은 구조를 가지고 있는 것으로 알려져있다
    * influence diagram을 기반으로 하는 몇 가지 sub utility의 합으로 표현할 수 있다
        * U1(T) + U2(K) + U3(D, L) + U4(L, F)
    * 위와 같은 구조를 통해 12개의 파라미터로 표현할 수 있게 된다

### Summary

* Utility Function은 불확실한 상황에서 우리가 어떤 선택을 선호하는지 결정한다
* 일반적으로 Utility는 다양한 factor 들에 의존한다
    * 돈, 시간, 사망률 등등
* 보통 비선형 관계를 보인다
    * Utility Curve의 모양은 리스크에 대한 태도를 결정한다
* Multi-attribute Utility는 고차원의 함수를 더 다루기 쉬운 조각들로 나누는데 도움을 준다
