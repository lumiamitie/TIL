# Ch10. Hypothesis Testing

다음 문서를 간단히 정리한다. <https://moderndive.com/10-hypothesis-testing.html>

## 1. inference가 필요하지 않은 경우

항상 엄밀한 가설검정이 필요한 것은 아니다.
가설과 테스트에 대해 생각하기 전에 탐색적 자료분석(EDA)을 해보는 것이 큰 도움이 된다.

예를 들어 살펴보자. `nycflights13` 라이브러리에 있는 `flights` 데이터에서, 뉴욕에서 출발하여 보스턴 또는 샌프란시스코로 향하는 비행편 정보를 샘플링해보자.

```r
library(tidyverse)
library(infer)
library(nycflights13)

bos_sfo = flights %>%
  filter_all(all_vars(!is.na(.))) %>%
  filter(dest %in% c('BOS', 'SFO')) %>%
  group_by(dest) %>%
  sample_n(100)
```

샌프란시스코를 갈 때 공중에 머무르는 시간이 보스턴에 갈 때보다 통계적으로 더 길다고 볼 수 있을까?
간단한 EDA를 해보자.

```r
bos_sfo %>%
  group_by(dest) %>%
  summarize(mean_time = mean(air_time),
            sd_time = sd(air_time))
# # A tibble: 2 x 3
#   dest  mean_time sd_time
#   <chr>     <dbl>   <dbl>
# 1 BOS        39.2    5.43
# 2 SFO       347.    17.5
```

결과를 보면 SFO의 `air_time`이 `BOS` 에 비해 현저히 긴 것을 볼 수 있다.
특히 표준편차를 알고 있는 것이 큰 도움이 되었다.
Box Plot을 그려서 살펴보자.

```r
ggplot(bos_sfo, aes(x = dest, y = air_time)) +
  geom_boxplot() +
  theme_minimal(base_family = 'Helvetica Light')
```

![png](fig/moderndive_ch10/output_01.png)

전혀 겹치는 구간이 없기 때문에, 샌프란시스코로 향할 때의 비행시간이 확실히 더 길다는 결론을 내릴 수 있다.
이러한 경우에는 굳이 EDA 이상의 추론을 할 필요가 없다.

## 2. 가설검정의 기초

가설검정에서는 모수에 대한 두 가지 상반되는 가설 중에 하나를 선택하기 위해 데이터를 사용한다.

- 하나는 H0로 표기하는 귀무가설 (Null Hypothesis)
- 또 하나는 H1으로 표기하는 대립가설 (alternative hypothesis 또는 research hypothesis)

두 가지 가설의 역할이 다르기 때문에 서로 교환할 수 없다.

- 대립가설은 보통 연구자/분석가가 증거를 찾고자 하는 가설을 말한다
- 귀무가설은 *효과가 없다* 또는 *둘 사이에 차이가 없다* 는 가설을 말한다
- 귀무가설이 맞다는 것을 가정한 상태에서 현재 샘플 데이터가 얼마나 나오기 어려운 상황인지 계산한다

모든 가설검정은 Allen Downey가 제시한 [다음 프레임워크](http://allendowney.blogspot.com/2016/06/there-is-still-only-one-test.html) 로
표현할 수 있다.

![Hypothesis Testing Framework](https://d33wubrfki0l68.cloudfront.net/c13657f5339f170a007f29a840739e0e10d55b32/a275c/images/ht.png)
