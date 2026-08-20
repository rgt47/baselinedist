# Data Directory

*2026-08-20 00:00 PDT*

This project uses simulated data only; there is no raw data
source. This directory holds the saved output of the Monte
Carlo simulation that populates the manuscript
(`analysis/report/report.Rmd`).

## Directory Structure

```
data/
├── raw_data/           # Empty. No external data is used.
├── derived_data/       # Saved simulation output (regenerable)
└── README.md           # This file
```

## Raw Data (`raw_data/`)

Empty by design. This project does not analyze external or
observational data; all results derive from a Monte Carlo
simulation with a known data-generating model.

## Derived Data (`derived_data/`)

| File | Source Script | Description |
|------|---------------|-------------|
| `sim_results.rds` | `analysis/scripts/run_simulation.R` | Simulation results (bias, empirical SE, mean model SE, coverage, power, and Monte Carlo standard errors) for all `n` x `gamma` scenarios, plus the master seed and generation timestamp. |

`sim_results.rds` is fully regenerable; it is not a source of
truth. To regenerate it, run from the repository root:

```r
Rscript analysis/scripts/run_simulation.R
```

See `R/run_sim.R` for the simulation function and the
manuscript's Reproducibility section for the seeding scheme.
