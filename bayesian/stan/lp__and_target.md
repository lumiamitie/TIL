# Stan에서 lp__와 target이 의미하는 것

Stan은 사후확률인 P(theta | Y) 가 큰 곳을 효율적으로 찾고자 한다.
이를 위해 로그 사후확률을 theta에 대해 편미분한 값을 사용한다.

```
log P(theta | Y)
= log [ P(Y | theta) * P(theta) ] + const
= log P(Y | theta) + log P(theta) + const
```

따라서 각 MCMC 스텝 매개변수인 `theta*` 에 대해서 `log P(Y | theta*) + log P(theta*)` 값을 `lp__` (log posterior) 라는 이름으로 내부에 저장한다.

일반적으로 Stan 코드 안에서 likelihood `P(Y | theta)` 는 `Y ~ some_distribution(theta)` 의 형태로 표현한다. 이것은 Y는 *theta를 매개변수로 하는 어떤 분포에서 생성된다* 라는 의미를 가진다. 그리고 내부적으로는 `lp__ += log( P(Y|theta) )` 라는 동작이 발생한다.

```stan
model {
  for (n in 1:N) {
    Y[n] ~ normal(mu, 1);
  }
  mu ~ normal(0, 100);
}
```

위 코드를 `target`을 이용한 코드로 변경하면 다음과 같다.

```stan
model {
  for (n in 1:N) {
    target += normal_lpdf(Y[n] | mu, 1);
  }
  target += normal_lpdf(mu | 0, 100);
}
```

여기서 `normal_lpdf` 는 `log( Normal(Y[n] | mu, 1) )` 을 나타내는 함수다.

보통 `~` 를 사용해서 모델을 표현하지만, target을 사용한 표기 방법이 필요할 때가 종종 있다.
