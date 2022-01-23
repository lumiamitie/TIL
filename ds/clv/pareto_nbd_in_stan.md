# Pareto-NBD Customer Lifetime Value

다음 문서를 간단하게 요약해보자.

<https://www.briancallander.com/posts/customer_lifetime_value/pareto-nbd.html>

# 1. Data Generating Process

고객은 다음과 같은 특성을 따른다고 가정합니다.

1. Lifetime (`tau_c`) : 
    - 첫 구매일부터 시작되는 특정 고객의 생존 기간
    - 우리는 고객의 `T_c` (total observation time) 만 알 수 있고, 실제 `tau_c` 는 관측할 수 없다.
    - 따라서 고객의 lifetime `tau_c` 는 지수분포를 따른다고 가정한다. `tau_c ~ Exp(mu_c)`
2. Purchase Rate (`lambda_c`) : 
    - 생존 기간(Lifetime) 중에는 `lambda_c` 의 확률로 구매한다.
    - Lifetime이 끝나면 고객은 구매하지 않는다.
    - t 기간내의 구매건수 k의 분포는 `k ~ Poisson(t * lambda_c)` 를 따른다.
