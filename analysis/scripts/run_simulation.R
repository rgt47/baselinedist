## Simulation driver for report.Rmd (Baseline Covariate Adjustment).
##
## Runs run_sim() (R/run_sim.R) over the full factorial design
## (n in {100, 200}, gamma in {0, 0.3, 0.5, 0.7}, b_reps = 5000) and
## saves the combined results to
## analysis/data/derived_data/sim_results.rds. report.Rmd reads this
## file directly; it does not rerun the simulation at render time.
##
## Usage (from the repository root):
##   Rscript analysis/scripts/run_simulation.R
##
## Runtime: approximately 30-60 seconds on a laptop for the full
## b_reps = 5000 design.

pkgload::load_all(here::here(), quiet = TRUE)
library(purrr)

master_seed <- 20260305

gammas <- c(0, 0.3, 0.5, 0.7)
ns <- c(100, 200)
scenarios <- expand.grid(n = ns, gamma = gammas)
scenarios$scenario_id <- seq_len(nrow(scenarios))

sim_results <- purrr::pmap_dfr(
  scenarios,
  function(n, gamma, scenario_id) {
    run_sim(
      n = n, gamma = gamma, b_reps = 5000,
      seed = master_seed + scenario_id
    )
  }
)

out_dir <- here::here("analysis", "data", "derived_data")
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

saveRDS(
  list(
    sim_results = sim_results,
    master_seed = master_seed,
    scenarios = scenarios,
    b_reps = 5000,
    generated_at = Sys.time(),
    r_version = R.version.string
  ),
  file.path(out_dir, "sim_results.rds")
)

message("Saved simulation results to ", file.path(
  out_dir, "sim_results.rds"
))
