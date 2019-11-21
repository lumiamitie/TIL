# 3. Sampling the Imaginary

95%의 확률로 뱀파이어 여부를 정확하게 진단하는 테스트가 있다고 생각해보자. (`Pr(Positive | vampire) = 0.95`) 
가끔 실수를 하기도 하는데, 1%의 확률로 일반인은 뱀파이어로 잘못 진단한다. (`Pr(positive | mortal) = 0.01`) 
굉장히 정확한 테스트지만, False Positive 기준으로는 그렇지 않다. 마지막으로 뱀파이어는 전체 인구 중 0.1%를 차지한다. (`Pr(vampire) = 0.001`)

이제 어떤 사람이 테스트에서 양성 판정을 받았다고 가정해보자. 이 사람이 뱀파이어일 확률은 얼마일까?

```
Pr(vampire | positive)
= Pr(positive | vampire) * Pr(vampire) / Pr(positive)

Pr(positive)
= Pr(positive | vampire) * Pr(vampire) 
    + Pr(positive | mortal) * (1 - Pr(vampire))
```

계산해보면 양성 판정일 때 실제로 뱀파이어인 확률은 8.7% 에 해당한다.