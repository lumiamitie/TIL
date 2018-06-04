# 샘플링 방법별 특징

## Metropolis-Hastings 알고리즘 (RWMH)

- 특징
  - Random Walk와 Markov Chain을 사용하여 Target Distribution에 맞는 stationary distribution을 찾아낸다
- 장점
  - discrete / continuous 여부와 상관없이 사용할 수 있다
- 단점
  - poor convergence rate => 확률 분포가 수렴하는데 시간이 많이 걸림
  - Random Walk의 특성상 특정한 샘플이나 구간에 끼어(stuck)버리는 경우가 발생할 수 있다


## HMC

- 특징
  - Random Walk 성질을 최대한 배제한다 ( -> 수렴 속도가 빨라지는데 기여함)
  - 모멘텀을 적용하여 동일한 방향으로 계속 나아가려는 성질을 가진다 (Metropolis-Hastings에 비해서)
  - (NUTS와 비교하면) 동일한 보폭으로 움직인다
- 장점
  - Metropolis-Hastings 알고리즘보다 훨씬 빠르게 수렴한다
- 단점
  - 파라미터를 어떻게 설정하느냐에 따라 성능에 미치는 영향이 크다
  - continuous variable에만 사용 가능


## NUTS (No-U-Turn Sampler)

- 특징
  - HMC에서 trajectory length는 자동으로 처리 (stepsize만 파라미터로 사용한다)
    - 나아가는 step 수가 1, 2, 4, 8 , .... 과 같이 2배씩 증가한다 (Doubling Procedure)
    - 시작점으로부터 최대한 멀리 나아가려는 성질을 가진다
  - U-turn이 발생하면 trajectory를 종료한다
- 장점
  - HMC보다 적은 파라미터로 잘 튜닝된 HMC 만큼의 성능을 낼 수 있다
- 단점
  - continuous variable에만 사용 가능
  - Posterior 분포의 higher derivatives가 급격하게 변하는 경우, stepsize가 0에 가까워져서 수렴시간이 Infinite에 가까워질 수 있다


# 참고자료

- [Introduction to Markov Chains](http://khalibartan.github.io/Introduction-to-Markov-Chains/)
- [Markov Chain Monte Carlo: Metropolis-Hastings Algorithm](http://khalibartan.github.io/MCMC-Metropolis-Hastings-Algorithm/)
- [MCMC: Hamiltonian Monte Carlo and No-U-Turn Sampler](http://khalibartan.github.io/MCMC-Hamiltonian-Monte-Carlo-and-No-U-Turn-Sampler/)
- [Heuristics for the advantages of NUTS/HMC/Stan vs RWMH](http://discourse.mc-stan.org/t/heuristics-for-the-advantages-of-nuts-hmc-stan-vs-rwmh/1673/2)
- [MCMC Using Hamiltonian Dynamics](http://www.mcmchandbook.net/HandbookChapter5.pdf)
