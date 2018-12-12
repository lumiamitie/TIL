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
