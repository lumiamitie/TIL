# MLE vs MAP

파트 분들이랑 수다떨다가, 면접때 지원자들에게 많이 질문하게 되는 문제들에 대해서 잠깐 이야기하게 되었다.
그 중에 하나로 언급되었던게 바로 MLE와 MAP의 차이에 대한 부분이었다.

MLE와 MAP는 임의의 변수를 확률 분포나 그래프 모형의 형태를 통해 추정하기 위한 방법론이다.
두 방식 모두 전체 분포를 구하는 대신 하나의 예측값을 구할 수 있게 해준다는 점에서는 비슷하다.

그렇다면 MLE와 MAP는 어떤 차이가 있을까?

## MLE (Maximum Likelihood Estimation)

MLE는 주어진 데이터만으로 파라미터를 추정한다.
예를 들어, 데이터가 정규분포를 따른다면 표본 평균과 표준 편차를 구해서 정규분포의 파라미터로 사용한다.
평균과 분산을 파라미터로 하는 가우시안 함수의 도함수를 구하고, 극대화시키는 지점을 찾는다.

MLE는 단순한 방식으로 추정할 수 있지만, 데이터에 따라 값이 민감하게 변할 수 있다.
만약 동전을 던졌는데 10번 연속으로 앞면이 나왔다면 이 동전은 앞면만 나오는 동전이라고 볼 수 있을까?

## MAP (Maximum a Posteriori Estimation)

MAP는 데이터가 주어졌을 때, 가장 높은 확률을 가지는 파라미터를 찾는다.
파라미터에 대한 가정 (어떤 확률분포를 따를 것인지에 대한 가정) 을 사용해 결과를 향상시킨다.
예를 들면, 시험점수가 대부분 40~60점 사이에 몰려있다는 정보를 알고 있다면 이것을 활용할 수 있다.

이러한 사전정보를 Prior 라고 한다.
Prior를 잘 고를 수 있다면 MLE에 비해 높은 성능을 얻을 수 있지만 반대의 경우도 있다.
따라서 Prior를 잘 고르는 것이 중요해진다.

만약 Prior가 Uniform Distribution인 경우 MLE와 MAP가 동일해진다.
따라서 MLE는 MAP의 Special Case라고 볼 수도 있다.

# Reference

- [MLE vs MAP](https://wiseodd.github.io/techblog/2017/01/01/mle-vs-map/)
- [Machine Learning 스터디 (2) Probability Theory](http://sanghyukchun.github.io/58/)
