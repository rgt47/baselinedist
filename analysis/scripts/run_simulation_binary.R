## Simulation driver for report.Rmd (binary-outcome / misspecified-
## model scenario).
##
## Runs run_sim_binary() (R/run_sim_binary.R) over a factorial design
## (n in {100, 200}, gamma2 in {0, 0.4, 0.8}, b_reps = 2000) and saves
## the combined results to
## analysis/data/derived_data/sim_results_binary.rds. report.Rmd reads
## this file directly; it does not rerun the simulation at render
## time.
##
## gamma2 is the true quadratic log-odds effect of the baseline
## covariate; it is also the magnitude by which the "misspecified"
## working model (which omits the quadratic term) is wrong.
## gamma2 = 0 collapses both standardization working models to the
## same, correctly specified, linear-logit form.
##
## Usage (from the repository root):
##   Rscript analysis/scripts/run_simulation_binary.R
##
## Runtime: approximately 4-6 minutes on a laptop for the full
## b_reps = 2000 design (logistic regression is substantially more
## expensive per replicate than the continuous-outcome scenario's
## lm() fits).

pkgload::load_all(here::here(), quiet = TRUE)
library(purrr)

master_seed <- 20260819

gamma2s <- c(0, 0.4, 0.8)
ns <- c(100, 200)
scenarios <- expand.grid(n = ns, gamma2 = gamma2s)
scenarios$scenario_id <- seq_len(nrow(scenarios))

sim_results_binary <- purrr::pmap_dfr(
  scenarios,
  function(n, gamma2, scenario_id) {
    run_sim_binary(
      n = n, gamma2 = gamma2, b_reps = 2000,
      seed = master_seed + scenario_id
    )
  }
)

out_dir <- here::here("analysis", "data", "derived_data")
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

saveRDS(
  list(
    sim_results_binary = sim_results_binary,
    master_seed = master_seed,
    scenarios = scenarios,
    b_reps = 2000,
    generated_at = Sys.time(),
    r_version = R.version.string
  ),
  file.path(out_dir, "sim_results_binary.rds")
)

message("Saved simulation results to ", file.path(
  out_dir, "sim_results_binary.rds"
))
