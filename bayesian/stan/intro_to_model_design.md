---
title: "Intro to Model Design"
output: html_notebook
---

다음 포스팅을 요약해서 정리한다 

<https://ourcodingclub.github.io/2018/04/06/model-design.html>

# 1. 통계적 모형 (Statistial Model) 이란 무엇인가?

우리가 해결해야 하는 문제를 위해서 데이터 사이의 관계에 대한 통계적인 검정을 필요로 할 때가 있다. 데이터의 구조에 맞게 모형을 구성하고, 해당 모형을 통해 우리의 가설을 테스트해본다. 따라서 모든 데이터 분석에서 가장 먼저 해야하는 것은 문제(질문)를 명확하게 하는 것이다. 

# 2. 해결하려는 문제 (Research Question)

여기서는 [Toolik Lake Field Station](http://arc-lter.ecosystems.mbl.edu/terrestrial-data) 데이터를 사용해서 튜토리얼을 진행할 것이다. 이 데이터는 알래스카 북부의 툰드라 지역의 5군데 장소에 대해서 4년간 식생구성의 변화를 수집한 결과이다. 간단한 질문을 몇 가지 던져보자.

## - 문제 1 : 종풍부도(Species Richness)가 시간에 따라 어떻게 변화하는가?

## - 문제 2 : 연간 평균온도의 변화가 종풍부도에 어떤 영향을 미치는가?

# 3. 데이터에 대해 살펴보자

```r
toolik_url = 'https://raw.githubusercontent.com/ourcodingclub/CC-model-design/master/toolik_plants.csv'
toolik_plants = read_csv(toolik_url)
```
