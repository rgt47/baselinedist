library(tinytest)

## Small-B smoke tests for run_sim_binary(); the manuscript's
## full-scale simulation uses b_reps = 2000, but the correctness
## properties checked here hold at any b_reps.

out_null <- run_sim_binary(n = 200, gamma2 = 0, b_reps = 500, seed = 1)

expect_equal(
  nrow(out_null), 3,
  info = "run_sim_binary returns one row per analysis strategy"
)
expect_equal(
  sort(out_null$strategy),
  sort(c(
    "Unadjusted", "Standardized (correct)",
    "Standardized (misspecified)"
  )),
  info = "run_sim_binary reports the three expected strategies"
)
expect_true(
  all(abs(out_null$bias) < 0.03),
  info = paste(
    "bias is small (near zero) for all strategies, including the",
    "misspecified standardization estimator, targeting the marginal",
    "risk difference"
  )
)
expect_true(
  all(out_null$coverage > 0.88 & out_null$coverage <= 1),
  info = "nominal 95% CIs cover the true marginal RD close to target"
)
expect_true(
  all(out_null$mcse_coverage > 0 & out_null$mcse_coverage < 0.03),
  info = "Monte Carlo SE of coverage is positive and small at b_reps = 500"
)

## Even under a truly misspecified working model (omitted quadratic
## term), the standardized estimator should remain approximately
## unbiased for the marginal risk difference, per Rosenblum and van
## der Laan (2009) and Moore and van der Laan (2009): standardization
## from a possibly misspecified outcome model, averaged over the
## empirical covariate distribution, is consistent for the marginal
## treatment effect in a randomized trial.
out_mis <- run_sim_binary(n = 200, gamma2 = 0.8, b_reps = 500, seed = 2)
bias_mis <- out_mis$bias[
  out_mis$strategy == "Standardized (misspecified)"
]
expect_true(
  abs(bias_mis) < 0.03,
  info = paste(
    "standardization from the misspecified working model remains",
    "approximately unbiased for the true marginal risk difference"
  )
)

## The correctly specified standardization estimator should be at
## least as precise as the misspecified one, which in turn should be
## at least as precise as the unadjusted difference in proportions,
## when the covariate is prognostic (gamma2 = 0.8, gamma = 0.8).
emp_se_unadj <- out_mis$emp_se[out_mis$strategy == "Unadjusted"]
emp_se_correct <- out_mis$emp_se[
  out_mis$strategy == "Standardized (correct)"
]
emp_se_mis <- out_mis$emp_se[
  out_mis$strategy == "Standardized (misspecified)"
]
expect_true(
  emp_se_correct <= emp_se_mis,
  info = "correctly specified standardization is at least as efficient"
)
expect_true(
  emp_se_mis < emp_se_unadj,
  info = paste(
    "misspecified standardization is still more efficient than the",
    "unadjusted estimator"
  )
)

## true_rd should not depend on the simulated data or the seed, only
## on the model parameters.
out_a <- run_sim_binary(n = 100, gamma2 = 0.4, b_reps = 50, seed = 10)
out_b <- run_sim_binary(n = 100, gamma2 = 0.4, b_reps = 50, seed = 20)
expect_equal(
  unique(out_a$true_rd), unique(out_b$true_rd),
  info = "true marginal RD is a fixed function of the DGM parameters"
)

## Reproducibility: same seed gives identical results.
rep_a <- run_sim_binary(n = 100, gamma2 = 0.4, b_reps = 100, seed = 99)
rep_b <- run_sim_binary(n = 100, gamma2 = 0.4, b_reps = 100, seed = 99)
expect_equal(
  rep_a, rep_b,
  info = "run_sim_binary is fully reproducible given the same seed"
)

## n must be even for 1:1 randomization.
expect_error(
  run_sim_binary(n = 101, gamma2 = 0.4, b_reps = 10, seed = 1),
  info = "run_sim_binary rejects an odd n that cannot be split 1:1"
)
