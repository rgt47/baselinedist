library(tinytest)

## Small-B smoke tests for run_sim(); the manuscript's full-scale
## simulation uses b_reps = 5000, but the correctness properties
## checked here hold at any b_reps.

out_null <- run_sim(n = 100, gamma = 0, b_reps = 800, seed = 1)

expect_equal(
  nrow(out_null), 3,
  info = "run_sim returns one row per analysis strategy"
)
expect_equal(
  sort(out_null$strategy),
  sort(c("Unadjusted", "ANCOVA", "Test-then-adjust")),
  info = "run_sim reports the three expected strategies"
)
expect_true(
  all(abs(out_null$bias) < 0.05),
  info = "bias is small (near zero) when tau is estimated without confounding"
)
expect_true(
  all(out_null$coverage > 0.90 & out_null$coverage <= 1),
  info = "nominal 95% CIs cover the true effect close to the target rate"
)
expect_true(
  all(out_null$mcse_coverage > 0 & out_null$mcse_coverage < 0.02),
  info = "Monte Carlo SE of coverage is positive and small at b_reps = 800"
)

## ANCOVA should be at least as precise as the unadjusted analysis
## when gamma > 0, per the theory summarized in the manuscript
## (variance reduction proportional to gamma^2).
out_prog <- run_sim(n = 200, gamma = 0.7, b_reps = 800, seed = 2)
emp_se_unadj <- out_prog$emp_se[out_prog$strategy == "Unadjusted"]
emp_se_ancova <- out_prog$emp_se[out_prog$strategy == "ANCOVA"]

expect_true(
  emp_se_ancova < emp_se_unadj,
  info = "ANCOVA empirical SE is smaller than unadjusted when gamma = 0.7"
)

## Reproducibility: same seed gives identical results.
rep_a <- run_sim(n = 100, gamma = 0.3, b_reps = 200, seed = 99)
rep_b <- run_sim(n = 100, gamma = 0.3, b_reps = 200, seed = 99)
expect_equal(
  rep_a, rep_b,
  info = "run_sim is fully reproducible given the same seed"
)

## n must be even for 1:1 randomization.
expect_error(
  run_sim(n = 101, gamma = 0.3, b_reps = 10, seed = 1),
  info = "run_sim rejects an odd n that cannot be split 1:1"
)
