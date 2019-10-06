# Recipes 라이브러리를 이용한 upsampling 예제

- 클래스간 불균형이 심한 경우 전처리 단계에서 upsampling을 수행할 수 있다
- Recipes 라이브러리를 통해 upsampling을 해보자

```r
library(tidyverse)
library(recipes)

# recipes::okc 데이터
data(okc)
```

- okc 데이터를 살펴보면 `diet` 변수의 경우 클래스별로 비율의 불균형이 심하다

```r
# diet 변수의 항목들 개수를 확인해보자
okc %>% count(diet)
# A tibble: 19 x 2
#    diet                    n
#    <chr>               <int>
#  1 anything             6174
#  2 halal                  11
#  3 kosher                 11
#  4 mostly anything     16562
#  5 mostly halal           48
#  6 mostly kosher          86
#  7 mostly other         1004
#  8 mostly vegan          335
#  9 mostly vegetarian    3438
# 10 other                 331
# 11 strictly anything    5107
# 12 strictly halal         18
# 13 strictly kosher        18
# 14 strictly other        450
# 15 strictly vegan        227
# 16 strictly vegetarian   874
# 17 vegan                 136
# 18 vegetarian            665
# 19 NA                  24360
```

- recipes 라이브러리의 `step_upsample()` 함수를 통해 부족한 카테고리의 데이터를 업샘플링할 수 있다

```r
up_rec = recipe( ~ ., data = okc) %>%
  # over_ratio 옵션에는 원하는 `가장 적은 항목 / 가장 많은 항목` 의 비율이 얼마나 되는지를 입력한다
  # - 가장 수치가 적은 항목들이 적어도 200개는 존재하도록 샘플링해보자
  # - 200/16562 is approx 0.0121
  step_upsample(diet, over_ratio = 0.0121) %>%
  prep(training = okc)
```

- `step_upsample()` 함수는 `skip = TRUE` 가 기본 옵션이기 때문에 bake 함수를 사용하면 전처리 결과가 반영되지 않는다
- 따라서 `juice()`를 사용해서 업샘플 결과를 추출한다

```r
upsampled_okc = juice(up_rec)

# 업샘플링 결과를 확인한다
juice(up_rec) %>% count(diet)
# A tibble: 19 x 2
#    diet                    n
#    <fct>               <int>
#  1 anything             6174
#  2 halal                 200
#  3 kosher                200
#  4 mostly anything     16562
#  5 mostly halal          200
#  6 mostly kosher         200
#  7 mostly other         1004
#  8 mostly vegan          335
#  9 mostly vegetarian    3438
# 10 other                 331
# 11 strictly anything    5107
# 12 strictly halal        200
# 13 strictly kosher       200
# 14 strictly other        450
# 15 strictly vegan        227
# 16 strictly vegetarian   874
# 17 vegan                 200
# 18 vegetarian            665
# 19 NA                  24360
```
