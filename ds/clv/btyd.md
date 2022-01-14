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
