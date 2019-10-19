- 다음 포스팅을 요약해서 정리해보자

["X affects Y". What does that even mean?](https://iyarlin.github.io/2019/03/13/x-affects-y-what-does-that-even-mean/)

---

# Analyzing the effect of X on Y

Causal inference 분야는 X 변수가 Y 변수에 어떻게 영향을 미치는지에 대해 다룬다. 우선은 머신러닝이 보통 이 문제를 어떻게 다루는지 살펴보자.

## Partial Dependence Plots

고전적인 머신러닝 문제는 관측 가능한 변수 {X, Z} 집합이 있을 때 결과 변수 Y의 기대값을 예측하고자 한다.

```
E(Y | X=x, Z=z)

- 여기서 X는 Y에 어떻게 영향을 미치는지 알고 싶은 특별한 변수다
- Z는 나머지 모든 측정 가능한 변수를 말한다
```

관측치 `{y_i, x_i, z_i}` 가 있다면, 예측함수 `f(x, z)` 를 구성할 수 있다.

```
f(x, z) = E_hat(Y | X=x, Z=z)
```

X의 Y에 대한 marginal effect를 구하고자 할 때, 머신러닝에서 일반적으로 사용하는 방식은 Partial dependece plot을 사용하는 것이다. 
Partial dependence 함수는 다음과 같이 정의할 수 있다.

```
PD(x) = E(Y | X=x) = E_z(f(x, Z))

- Z의 모든 값에 대해서 marginalize 하고 있다
```

`PD(x)` 는 보통 다음과 같이 예측한다.

```
PD_hat(x) = 1/n * SUM( f(x, z_i) )
```

Partial Dependence Plot은 다양한 X값과 각각에 대응하는 PD 값을 그래프로 표현한다.

흔한 오해 중 하나는 PDP가 다양한 X의 값이 Y에 어떻게 영향을 미치는지를 보여준다고 생각하는 것이다. 왜 이것이 오해라는 것일까? 간단한 예제 모형을 살펴보자.

마케팅 비용이 매출에 얼마나 영향을 미치고 있는지 파악해야 한다고 생각해보자. 다음과 같은 정보를 가지고 있다.

- mkt : 마케팅 비용 사용 기록
- visits : 웹사이트 방문 수
- sales : 판매건수
- comp : competition index

몇 가지 식을 통해 간단한 시뮬레이션을 수행해보자 (구조 방정식 이라고도 한다)

```
SALES  = beta1 * VISITS + beta2 * COMP + error1
VISITS = beta3 * MKT   + error2
MKT    = beta4 * COMP  + error3
COMP   = error4

{beta1, beta2, beta3, beta4} = {0.3, -0.9, 0.5, 0.6} 
error_i ~ N(0,1)
```

우리는 위 공식을 시뮬레이션을 통해 생성한 데이터셋의 데이터 생성 프로세스(DGP: Data Generating Process)라고 이해할 수 있다. 이것을 바탕으로 1만건의 샘플을 생성하고, 처음 8000건에 대해서 다음과 같이 선형 회귀 모형을 구성했다. 

```
SALES = r0 + r1*MKT + r2*VISITS + r3*COMP + error
```

mkt와 sales 사이의 PDP는 다음과 같다.
