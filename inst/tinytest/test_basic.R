library(tinytest)

## Package loads and exports run_sim(); real behavioral tests of
## run_sim() are in test_run_sim.R.
expect_true(
  exists("run_sim", mode = "function"),
  info = "run_sim is exported by the package"
)
