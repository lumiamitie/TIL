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
