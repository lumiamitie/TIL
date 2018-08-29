Datacamp **Bayesian Modeling with RJAGS** 중 일부를 정리

# Define, compile, and simulate

```r
# 모형을 구성한다
vote_model <- "model{
    # Likelihood model for X
    X ~ dbin(p, n)
    
    # Prior model for p
    p ~ dbeta(a, b)
}"

# 작성한 모형을 컴파일한다
vote_jags <- jags.model(textConnection(vote_model), 
    data = list(a = 45, b = 55, X = 6, n = 10),
    inits = list(.RNG.name = "base::Wichmann-Hill", .RNG.seed = 100))

# 시뮬레이션을 통해 posterior를 구한다
vote_sim <- coda.samples(
    model = vote_jags, 
    variable.names = c("p"), 
    n.iter = 10000
)

# posterior 분포를 그래프로 확인한다
plot(vote_sim, trace = FALSE)
```