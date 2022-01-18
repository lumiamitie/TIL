# Buy-til-you-Die

## 각 모형별 가정 정리

<https://stats.stackexchange.com/questions/251506/is-it-possible-to-understand-pareto-nbd-model-conceptually>

### Pareto/NBD model 의 가정

1. While active, **the number of transactions** made by a customer in a time period of length t is **distributed Poisson with transaction rate λ**.
2. **Heterogeneity in transaction rates across customers** follows a **gamma distribution** with shape parameter r and scale parameter α.
    - ⇒ Customers have different shopping habits.
3. Each customer has an unobserved **“lifetime” of length τ**. This point at which the customer becomes inactive is **distributed exponential with dropout rate µ**.
    - ⇒ You might have already lost some of the customers on the list.
4. **Heterogeneity in dropout rates** across customers follows a **gamma distribution** with shape parameter s and scale parameter β.
    - ⇒ Not all customers are equally committed to your shop.
5. The transaction rate λ and the dropout rate µ vary independently across customers."

### BG/NBD 모형의 가정

1. While active, **the number of transactions** made by a customer follows a **Poisson process with transaction rate λ**. This is equivalent to assuming that the time between transactions is distributed exponential with transaction rate λ
2. **Heterogeneity in λ** follows a **gamma distribution**.
    - ⇒ Customers have different shopping habits.
3. After any transaction, **a customer becomes inactive** with probability p. Therefore the point at which the customer “drops out” is distributed across transactions according to a **(shifted) geometric distribution** with pmf
    - ⇒ You might have already lost some of the customers on the list.
4. **Heterogeneity in p** follows a **beta distribution**
    - ⇒ Not all customers are equally committed to your shop.

## BTYD History

- NBD (Ehrenberg 1959)
    - 고객마다 구매 패턴이 다르다는 것을 가정하지만, 고객 이탈은 고려하지 않는다.
    - 이후 등장한 모형들의 베이스라인으로 등장함.
- Pareto/NBD (Schmittlein, Morrison, and Colombo 1987)
    - heterogeneous dropout process 가 추가되었다.
- BG/NBD (P. Fader, Hardie, and Lee 2005)
    - 계산에 소요되는 시간을 줄이기 위해 가정을 수정했고, 파라미터를 더 robust 하게 추정할 수 있도록 했다.
    - 하지만 이 모형은 반복적으로 구매하지 않은 고객은 이탈하지 않았다고 가정한다.
- MBG/NBD
    - BG/NBD 모형을 개선하여, 활동이 없는 고객은 이탈한 것으로 본다.
- BG/CNBD-k and MBG/CNBD-k
    - 구매 주기를 포함하여 예측 정확도를 향상시켰다. (고객의 구매 주기에 일정한 패턴이 있을 경우, 고객 단위에서 훨씬 정확한 예측이 가능해졌다.)
- Pareto/NBD (HB) Ma and Liu (2007)
    - MCMC 시뮬레이션을 통해 보다 유연하게 가정을 적용할 수 있다.
    - 기존 모형의 가정을 수용하되, hierarchical Bayes 모형을 사용한다.
- MBG/NBD Batislam, Denizel, and Filiztekin (2007), Hoppe and Wagner (2007)
- Pareto/NBD (Abe) Abe (2009)
    - MCMC 시뮬레이션을 통해 보다 유연하게 가정을 적용할 수 있다.
    - covariates 를 포함할 수 있다.
- BG/BB (Fader, Hardie, and Shang 2010)
- Pareto/GGG Platzer and Reutterer (2016)
    - 고객에 따라 달라지는 구매 주기를 반영할 수 있다.
