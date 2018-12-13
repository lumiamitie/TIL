# Multidimensional EFA

DataCamp **Factor Analysis in R** 강의에서 Chapter2 듣고 정리

## 2.1 Determining Dimensionality

### How many dimensions does your data have?

Factor Analysis도 차원 축소 기법이라고 볼 수 있을까?

새로운 Measure를 개발하는 관점에서, EFA를 적용하는 것은 관찰할 수 없는 factor가 몇 개 존재하는지 찾아내는 과정으로 이해할 수 있다.
데이터를 탐색하는 과정에서는 몇 개의 요인이 존재하는지, 서로 얼마나 관련되어 있는지 알 수 없다.

여기서는 `bfi` 데이터를 통해 Factor의 개수를 정하는 과정을 살펴보려고 한다

### bfi dataset

- Big Five Inventory
- 25개 주제에 대해 응답한 2800명의 답변 데이터
  - 각 문항을 통해 Big5 성격 특성을 측정한다
  - `1 = Very Inaccurate` ...  `6 = Very Accurate`
- Data collected from the Synthetic Aperture Personality Assessment (SAPA)

### Process

#### 1) Setup: Split your dataset

- EFA, CFA 모두 데이터를 분할하여 분석한다 (50:50)
  - 모든 데이터를 사용할 경우 오버피팅의 위험이 존재한다

#### 2) An empirical approach to dimensionality

- bfi 데이터셋에는 이론적으로 정리된 factor 들이 존재한다
- 하지만 항상 이상적인 factor 가 존재하는 것은 아니다
- 따라서 dimensionality를 측정하기 위해 **empirical approach**를 사용한다
  - correlation matrix에서 unique factor를 측정하기 위해 **eigenvalue**를 구한다

**2-1) Calculate the correlation matrix**

- (1) correlation matrix를 계산한다
  - `cor(data, use = 'pairwise.complete.obs')`
- (2) eigenvalue 를 구한다
  - `eigen(matrix)`
  - 몇 가지 정보를 담고 있는 리스트를 반환한다
    - eigenvalue를 추출하기 위해서는 `eigen(matrix)$values`
- (3) 일반적으로는 **eigenvalue > 1** 인 경우 유의미한 factor라고 본다
- 이 과정을 간편하게 하기 위해 **Scree Plot**을 그릴 수 있다

**2-2) Scree Plots**

- `scree(correlation_matrix, factors = FALSE)`
- 그래프를 살펴보면 `eigenvalue = 1` 에 해당하는 가로줄이 그어져 있다
- 그 위에 존재하는 factor 개수를 세어보면 된다!

## 2.2 Understanding Multidimensional data

Multidimensionality 라는 것은 무엇을 의미하는 것일까?

### Factors = Constructs

- Construct 란 우리가 관심을 갖고 있는 특성을 말한다 (직접적으로 관측할 수는 없기 때문에 가설로 세운 특성)
- 예를 들면, Self-determination, Reasoning ability, Political affiliation, Extraversion
- 일반적으로는 특정한 constructs를 측정할 수 있도록 measure를 구성한다
- Construct가 이론적인 개념이라면, Factor는 그에 연결되는 수학적 개념이다

### Interpreting Confirmatory Analyses

- Confirmatory Analysis를 수행할 때는 가설이 얼마만큼 설득력있는지 측정하게 된다
- **Model fit** 통계량 : 가설이 데이터와 factor에 잘 들어맞는지에 대한 정보를 제공한다
- **Factor Loadings** : 데이터 항목과 construct의 관계를 나타낸다

### Interpreting Exploratory Analyses

- 이론적 배경이 없을 경우, eigenvalue와 같은 수학적 기법을 바탕으로 분석을 진행하게 된다
- multidimensional EFA를 통해 factor 들이 어떻게 서로 연관되어 있는지 확인한다

### Running a multidimensional EFA

- multidimensional EFA 를 수행하는 과정은 unidimensional EFA와 비슷하다
- `EFA_model = fa(bfi_EFA, nfactors = 6)`
  - 스크리 플랏을 통해 알아낸 factor 개수를 `nfactors` 파라미터에 넣는다
- **Factor Loadings**
  - `EFA_model$loadings`
  - 6개의 factor가 6개의 열로 표현되고 있다
  - 각 factor에는 임의의 이름이 부여되어 있는데, 순서가 정렬되어 있지 않다는 것을 알 수 있다
    - EFA를 적용하는 과정에서 rotation이 발생하여 생긴 결과이다
  - 어떤 item/factor는 값을 가지고 있지 않은 것을 볼 수 있다
    - 해석을 쉽게 하기 위해 무시할 수 있는 값들은 제거하고 보여준다
  - CFA와는 다르게 이러한 factor들에는 특정한 의미가 부여되어 있지 않다
- **Factor Scores**
  - 사람마다 6개에 factor에 대한 score가 계산되어 있다
  - Missing data가 있을 경우 score가 계산되지 않고 NA값으로 처리된다
  - 가설이 검증되기 전까지는 factor score를 해석하려고 하지 말아야 한다
