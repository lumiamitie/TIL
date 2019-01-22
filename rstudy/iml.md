# iml 라이브러리

[iml 공식 vignettes](https://cran.r-project.org/web/packages/iml/vignettes/intro.html) 참고

## (0) 라이브러리 및 데이터 준비

```r
library('iml')
library('randomForest')

# library('ranger')
# iml 0.8.1 기준으로, ranger 구현체를 쓰면 다음과 같은 에러가 발생한다
# Error in as.data.frame.default(x[[i]], optional = TRUE, stringsAsFactors = stringsAsFactors) :
# cannot coerce class ‘"ranger.prediction"’ to a data.frame

# MASS 라이브러리로부터 Boston 데이터를 불러온다
data('Boston', package  = 'MASS')
```

## (1) 머신러닝 모형을 학습시킨다

```r
# 재현을 위한 랜덤 시드 설정
set.seed(42)

# Random Forest
rf = randomForest::randomForest(medv ~ ., data = Boston, ntrees = 50)

# ranger는 뒤에서 에러가 발생해서 제외
# rf = ranger::ranger(medv ~ ., data = Boston, num.trees = 50)
```

## (2) iml의 Predictor 인스턴스를 생성한다

```r
# iml 은 R6 클래스를 사용하기 때문에 $new 메서드로 인스턴스를 생성한다
X = Boston[which(names(Boston) != 'medv')]
predictor = Predictor$new(rf, data = X, y = Boston$medv)
```

## (3) 다양한 지표를 추출한다

### (3.1) Feature Importance

```r
imp = FeatureImp$new(predictor, loss = 'mae')

imp$plot()

imp$results
#    feature importance.05 importance importance.95 permutation.error
# 1    lstat     3.6727671  4.4047424      5.099096         4.1477453
# 2       rm     3.0261366  3.5530818      4.650470         3.3457753
# 3      nox     1.6521610  1.8165921      1.921976         1.7106020
# 4     crim     1.6081713  1.7104871      1.891621         1.6106877
# 5  ptratio     1.6524484  1.6948785      1.833829         1.5959899
# 6      dis     1.5655934  1.6062834      1.793672         1.5125639
# 7    indus     1.3884620  1.5351155      1.592541         1.4455483
# 8      age     1.3100150  1.4546658      1.554037         1.3697925
# 9      tax     1.3131318  1.3708348      1.501439         1.2908526
# 10   black     1.1635020  1.2187526      1.370854         1.1476438
# 11     rad     1.0530832  1.1551064      1.164970         1.0877111
# 12      zn     1.0158591  1.0523612      1.084563         0.9909606
# 13    chas     0.9270741  0.9955328      1.066411         0.9374479

# ranger::ranger로 학습시킬 경우 다음과 같은 에러가 발생한다
# Error in as.data.frame.default(x[[i]], optional = TRUE, stringsAsFactors = stringsAsFactors) :
#   cannot coerce class ‘"ranger.prediction"’ to a data.frame
```

### (3.3) Measure Interactions

피쳐들이 서로 얼마나 상호관계를 가지는지 측정할 수 있다.
전체 분산 중에서 상호관계를 통해 설명되는 부분이 얼마나 되는지에 따라 0(상호작용 없음) 부터 1(상호작용으로 모든 분산 설명 가능) 사이의 값으로 나타낸다.

```r
interact = Interaction$new(predictor)
plot(interact)
```

특정한 피쳐를 선택해서 다른 피쳐들과의 상호관계를 살펴볼 수 있다.

```r
interact_crim = Interaction$new(predictor, feature = 'crim')
plot(interact_crim)
```

## (4) Surrogate Model

모형을 해석하기 쉽게 만드는 또 한 가지 방법은 블랙박스 모형을 Decision Tree 같은 더 간단한 모형으로 대신하는 것이다.
원본 feature를 가지고 Decision Tree를 통해 블랙박스 모형의 예측을 학습시킨다.

```r
tree = TreeSurrogate$new(predictor, maxdepth = 2)
plot(tree)

# 학습한 트리를 통해 예측해 볼 수 있다
head(tree$predict(Boston))
#     .y.hat
# 1 25.30993
# 2 25.30993
# 3 38.01278
# 4 38.01278
# 5 38.01278
# 6 25.30993
#
# Warning message:
#   In self$predictor$data$match_cols(data.frame(newdata)) :
#   Dropping additional columns: medv
```

## (5) Explain single predictions

### (5.1) Local Model

Global surrogate model을 통해 전체 모형이 어떤 방식으로 동작하는지 확인할 수 있었다.
각각의 예측값을 이해하기 위해 모형을 국지적으로(locally) 학습할 수 있다.
`LocalModel` 클래스는 선형 회귀 모형을 통해 학습하며, 예측하려는 데이터와 가까이 존재할 수록 높은 가중치를 부여한다.

```r
# install.packages('gower')
lime_explain = LocalModel$new(predictor, x.interest = X[1,])
plot(lime_explain)
lime_explain$results
#               beta x.recoded    effect x.original feature feature.value
# rm       4.3866273     6.575 28.842074      6.575      rm      rm=6.575
# ptratio -0.5497762    15.300 -8.411576       15.3 ptratio  ptratio=15.3
# lstat   -0.4385939     4.980 -2.184197       4.98   lstat    lstat=4.98

# 다른 값을 예측해보자
lime_explain$explain(X[2,])
plot(lime_explain)
```

### (5.2) Game theory : Shapley Value

개별 예측값을 설명하는 또 다른 방법은 게임 이론에서 가져온 Shapley value 이다.
하나의 데이터 포인트에 대해 각각의 피쳐들이 게임을 해서 예측에 기여한 값을 구한다.

```r
shapley = Shapley$new(predictor, x.interest = X[1,])
shapley$plot()

# 인스턴스를 재활용해서 다른 데이터 포인트를 설명할 수 있다
shapley$explain(x.interest = X[2,])
shapley$plot()
```
