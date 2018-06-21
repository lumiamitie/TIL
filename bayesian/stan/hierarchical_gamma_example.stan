data {
  int<lower=1> N; // total number of rows
  int<lower=1> G; // number of groups
  int idx[N];     // index of Group
  vector[N] y;
}
parameters {
  vector<lower=0>[G] alpha;
  vector<lower=0>[G] beta;
}
model {
  alpha ~ cauchy(0, 5); // weakly informative priors
  beta ~ cauchy(0, 5);  // weakly informative priors

  y ~ gamma(alpha[idx], beta[idx]);
}
