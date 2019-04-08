# 베이지안 방식으로 CTR 학습하기

CTR의 credible interval을 구하기 위해 Beta Binomial 분포를 학습시키려고 한다.

이전에 공부하면서 봤던 코드를 계속 복붙하고 있었는데,
좀 더 CTR 학습에 맞는 방식으로 수정해보면 좋겠다.

```r
ll = function(alpha, beta) {
  x = ctr_prior$click_cnt
  total = ctr_prior$imp_cnt
  bb_density = VGAM::dbetabinom.ab(x, total, alpha, beta, log=TRUE)
  return(-sum(bb_density))
}

# MLE
m = stats4::mle(ll, start=list(alpha=1, beta=10), method='L-BFGS-B', lower=c(0.0001, 0.1))
ab = stats4::coef(m)
```
