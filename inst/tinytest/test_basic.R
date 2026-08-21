library(tinytest)

## Package loads and exports run_sim() and run_sim_binary(); real
## behavioral tests are in test_run_sim.R and test_run_sim_binary.R.
expect_true(
  exists("run_sim", mode = "function"),
  info = "run_sim is exported by the package"
)
expect_true(
  exists("run_sim_binary", mode = "function"),
  info = "run_sim_binary is exported by the package"
)
