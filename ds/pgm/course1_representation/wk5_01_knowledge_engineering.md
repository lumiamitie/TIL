# Knowledge Engineering & Conclusion

## Knowledge Engineering

### Important Distinctions

* 모형의 디자인 방향을 결정하는데 있어서 적어도 세 가지 이상의 선택이 필요하다. 
    * (1) Template-based vs Specific (정해진 개수의 확률변수)
    * (2) Directed vs Undirected
    * (3) Generative vs Discriminative
* Hybrids are also common
    * 뚜렷한 경계가 있는 것은 아니라는 점을 명심해야 한다


### Template-based VS Specific

* Template-based
    * Image-Segmentation
    * 보통 적은 종류의 변수 타입을 사용한다
        * Image-Segmentation 의 경우 한 가지 변수 타입만을 사용 
        * 어떤 feature가 예측에 도움이 되는지 찾아내는데 집중하게 된다
* Specific
    * 예제 - 의학적인 진단 : 제한적인 증상들의 집합을 모형에 반영한다
    * 많은 수의 unique 변수를 사용하는 경우가 많다
        * 각 변수들의 의존관계나 파라미터 등을 고려한다 
* 두 방향의 중간쯤 되는 모형도 존재한다
    * fault-diagnosis


### Generative VS Discriminative

* Generative
    * (1) 사전에 정해진 목표가 없어서 작업이 변경될 수 있는 경우
        * 환자들을 진단하는 경우, 모든 환자에 대해 알고 있는 정보가 각기 다르다
        * 입력 변수와 결과 변수가 환자마다 다를 수 있다
        * 따라서 유연하게 대응할 수 있다
    * (2) 특정 분야에서는 generative model이 더 학습시키기 좋다
        * 모든 데이터에 레이블이 달려있지 않은 경우
* Discriminative
    * 예측해야하는 목표가 존재하는 경우
    * 뚜렷한 특징을 가지고 있는 다양한 변수를 다룬다
    * 상관관계를 다루는 것은 최대한 피한다
    * 따라서 높은 성능을 낼 수 있다

### Variable Types

그래피컬 모형을 구성하기 위해서 중요한 것은 무엇일까? 우선 어떤 변수들을 포함시킬지가 중요할 것이다. 

* Target
    * 변하든, 변하지 않는 것이든 우리가 목표로 하는 변수
    * 의학 진단 문제라면 어떤 병인지 나타내는 변수가 가장 중요할 것이다
* Observed
    * 다양한 feature를 포함한다
    * 증상 또는 검사결과 같은 것들이 해당된다
    * 항상 관측값을 얻을 수 있는 것은 아니기 때문에, 예측에 꼭 필요한 요소는 아니다
* Latent
    * 숨겨진 (hidden) 변수
    * latent 변수를 포함시키면 모형이 단순해지는 경우가 종종 있다
        * GMT (그리니치 표준시) -> W1, GMT -> W1, ... GMT -> Wk 로 구성된 모형이 있다
        * GMT 의 존재를 배제할 경우, W1, ... , Wk 사이에 복잡한 관계로 모형을 구성해야 함


### Structure

* Causal vs Non-Causal
* X -> Y 로 이어지는 연결이 인과관계를 의미하는가?
    * No : X -> Y 대신 Y -> X 로 바꾸어도 동일한 경우가 있다
* Causal
    * 보통 더 sparse 한 모형이 된다
    * 파라미터를 구성하기가 더 쉽고, 더 많은 정보를 제공한다


### Structure : Extending the Conversation

* 목표로 하는 변수에 대해 추론하기 위해 필요한 변수들로 확장해나간다


### Parameters: Values

* 문제가 되는 것들
    * 0 : 모형에서 확률이 0으로 계산되었다고 하더라도 실제로는 그렇지 않을 수 있다
        * 확률이 0 이라는 가정은 굉장히 조심해서 사용해야 한다
    * Orders of magnitude (자릿수) : 1/10 vs 1/100
    * 상대적인 값 : 절대값이 아니라 상대값을 비교해야 한다
* Structured CPDs
    * 대부분의 경우, 작은 규모의 CPD 보다는 구조화된 CPD나 다양한 형태의 CPD를 사용하게 될 것이다

### Parameters: Local Structure

| | Context-specific | Aggregating |
|-|------------------|-------------|
| Discrete   | Tree CPDs | Sigmoid<br />Noisy OR |
| Continuous | Regression Tree (thresholds)<br />Conditional Linear Gaussian (CLG) | Linear Gaussian |

### Iterative Refinement

모형이 한 번에 완성되는 일은 거의 없다. 코드를 작성하는 것과 마찬가지로, 모형도 계속 테스트하고 개선하는 작업을 반복해야 한다

* (1) Model Testing
    * 일단 모형을 완성하면 테스트해야 한다
* (2) 파라미터에 대한 Sensitivity Analysis
    * 결과에 크게 영향을 미치는 파라미터가 무엇일까?
    * 그러한 파라미터가 있다면 세부적인 조정을 통해 최상의 결과를 얻을 수 있어야 한다
* (3) Error Analysis
    * 문제를 발견하면 모형을 수정해가면서 문제를 해결해야 한다
    * feature를 추가한다거나, depedency를 추가하는 것이 방법이 될 수 있다
