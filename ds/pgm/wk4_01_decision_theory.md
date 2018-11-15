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

