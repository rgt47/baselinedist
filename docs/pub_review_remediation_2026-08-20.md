# Remediation Log: baselinedist

*2026-08-20 13:19 PDT*

Addresses the referee comments in
`docs/pub_review_whitepaper_2026-08-16.md`. Manuscript:
`analysis/report/report.Rmd`.

## 1. Fixed

**Correctness (whitepaper Section 4a)**

- M1 (power sentence contradicts Table 2). Replaced the hard-coded
  "0.56 to approximately 0.88" sentence with inline `r` expressions
  reading directly from `sim_results` (`analysis/report/report.Rmd`,
  Results). The rendered text now reads "0.32 to 0.55" ($n=100$) and
  "0.57 to 0.84" ($n=200$), matching Table 1 (renumbered from the
  referee's "Table 2" after removing the report_cache dependency).
  `[verified]`: confirmed against `report.tex` after a full render.
- M2 (fabricated Reproducibility section). Rewrote the
  Reproducibility and Data availability sections
  (`analysis/report/report.Rmd`) to describe the actual pipeline:
  `run_sim()` in `R/run_sim.R`, driven by
  `analysis/scripts/run_simulation.R`, saving
  `analysis/data/derived_data/sim_results.rds`; removed the false
  `set.seed(20260411)` / per-replicate-seed / `MASS` /
  `analysis/figures` claims. `[verified]`: read the actual code and
  confirmed the prose matches it; confirmed `MASS` is not loaded
  anywhere in the repo.
- M3 (abstract overclaims imbalance as a design factor). Removed
  "covariate-imbalance levels" from the Methods paragraph of the
  Abstract; the simulation varies only $\gamma$ and $n$.
  `[verified]`: rendered PDF text checked.
- M4 (Methods/code HC2-vs-OLS contradiction). Implemented HC2 robust
  standard errors via `sandwich::vcovHC(fit, type = "HC2")` in
  `R/run_sim.R` for the ANCOVA and test-then-adjust strategies, so
  the code now matches the Methods claim instead of the Limitations
  admission of plain OLS SEs. Reran the full simulation
  ($B=5000$, 8 scenarios) in about 115 seconds; results saved to
  `analysis/data/derived_data/sim_results.rds`. `[verified]`: ran
  `analysis/scripts/run_simulation.R` to completion, inspected
  output, confirmed non-`NA`, plausible values, and reran the full
  document render successfully.
- M5 (no MCSE; TTA mischaracterized as "between" the other two
  strategies with "minor" over-coverage attributed to "model
  selection bias"). Added `mcse_bias`, `mcse_coverage`, `mcse_power`
  to `run_sim()`'s output (standard ADEMP formulas); added MCSE
  columns to Table 1; rewrote the Results and Coverage Properties
  prose to state that test-then-adjust's power tracks the
  unadjusted analysis (not "between"), that its coverage is
  systematically above nominal by several Monte Carlo standard
  errors, and to give the correct mechanistic explanation (mixture
  of a data-dependent selection between the ANCOVA and unadjusted
  SEs, with the model SE exceeding the true sampling variability of
  the mixed estimator in mostly-balanced samples).
  `[verified]`: rendered numbers checked against the saved
  `sim_results.rds`.

**Acceptance (whitepaper Section 4b)**

- M6 (weak/unpositioned novelty claim). Rewrote "Present Study" to
  name the existing practitioner-facing sources it overlaps with
  (FDA/EMA guidance, Morris et al. 2022, Kahan et al. 2014, Van
  Lancker et al. 2024) and to state explicitly that the paper's
  contribution is a synthesis/decision-procedure, not a new
  empirical finding or estimator; softened the Conclusions similarly.
  Added `@kahanRisks2014` and `@morrisUsingSimulation2019` bib
  entries (`analysis/report/references.bib`) since they were cited
  but absent. `[verified]`: citations render correctly in
  `report.tex` (checked `\citeproc` output and the bibliography
  entries).
- M5/ADEMP structure. Reported MCSEs and restructured the Methods
  "Simulation Design" paragraph around the ADEMP framework, citing
  Morris, White, and Crowther (2019). `[verified]`.
- M2/M7 (cache-dependent, script-free reproducibility). Extracted
  the simulation into an exported, documented package function
  `run_sim()` (`R/run_sim.R`) and a driver script
  (`analysis/scripts/run_simulation.R`) that saves results to
  `analysis/data/derived_data/sim_results.rds`; the manuscript's
  `simulation` chunk now only reads that file and stops with an
  actionable error if it is missing, so the `report_cache/` cache
  dependency is eliminated entirely (the chunk no longer uses
  `cache=TRUE`). `[verified]`: full render succeeded after deleting
  `report_cache/`.
- Minor 1 (Lord's paradox mis-citation) and minor 11 (criterion 9
  citation pairing). Reassigned the Lord's-paradox citation from
  `@lesaffreNonparametric2003` to `@sennChangeBaseline2006` (already
  the subject of the same sentence); moved `@luLogRank2008` from the
  RMST clause to the log-rank clause in criterion 9, since it is a
  log-rank efficiency paper, not an RMST paper.
  `[verified]`: inspected the cited papers' actual subject matter
  against the manuscript's `references.bib` entries.

**Desirable polish (whitepaper Section 4c)**

- Normalized Abstract spelling to US English (randomised ->
  randomized, synthesise -> synthesize, distils -> distills).
  Left British spelling intact inside verbatim bibliography titles
  (e.g., "randomised" in the Kahan/Morris citation titles), per this
  user's citation-fidelity convention.
- Fixed the ICH E9 section heading from "(1998)" to "(1999)" to
  match the cited Stat Med reprint.
- Replaced hard-coded "Table 2"/"Figure 1"/"Figure 2" references with
  `\@ref(tab:results-table)`, `\@ref(fig:efficiency-plot)`, and
  `\@ref(fig:coverage-plot)`.
- Coverage now uses `qt(0.975, df)` per fitted model instead of a
  fixed 1.96, computed inside `run_sim()`.
- Widened the coverage-plot y-axis to `c(0.93, 0.98)` so the
  test-then-adjust points (now up to 0.971) sit inside the panel.
- Qualified the "gains are independent of sample size" sentence as
  an asymptotic property illustrated by, not empirically established
  from, two sample sizes.
- Removed `rm(list = ls())` from the setup chunk.
- Replaced `analysis/data/README.md` (stale Palmer Penguins template)
  with an accurate description of this project's simulation-only
  data flow.
- Removed `analysis/report/report_cache/` and the duplicated nested
  `analysis/report/report_files/report_files/` from version control
  and added both to `.gitignore`.
- Added real `tinytest` coverage for `run_sim()`
  (`inst/tinytest/test_run_sim.R`: 8 assertions covering row/strategy
  structure, near-zero bias, nominal coverage, MCSE positivity,
  ANCOVA-vs-unadjusted efficiency ordering, exact seed
  reproducibility, and input validation) and replaced the
  `expect_true(TRUE)` stub in `test_basic.R` with an export check.
  `[verified]`: `tinytest::run_test_dir("inst/tinytest")` -> "All ok,
  9 results" (about 8 seconds).

## 2. Deferred

- Whitepaper item 9 (add a binary-outcome standardization scenario
  and/or a misspecified-model scenario to support criteria 8 and
  10). Out of budget: this is a modest-to-moderate implementation
  effort (a second data-generating model plus a g-computation
  estimator), not a bug fix, and the instructions direct budget
  toward the correctness tier first. No code changes were made in
  this direction; Limitations now explicitly discloses that criteria
  8-10 are not empirically illustrated here.
- Whitepaper Section 5 title/framing change (e.g., "When and how to
  adjust for baseline covariates: a practical checklist with worked
  illustration"). The Present Study, Abstract, and Conclusions were
  reframed in prose to disclaim novel methodology and position
  against Kahan (2014), Morris (2022), and Van Lancker (2024), but
  the YAML `title:` was left unchanged. Changing the title affects
  the paper's identity across `share/` staged copies and is an
  editorial/target-journal decision that belongs to the author, not
  a mechanical fix.
- Whitepaper item 14 / minor 13-14 (submission-format variant: drop
  `toc: true`, move `\thanks` out of the YAML author field into a
  title-page block). Not done; these are presentation choices that
  depend on the target journal's submission system, which is not yet
  fixed given the deferred title/framing decision above.
- Minor 7 note on the rendered coverage figure: the y-axis was
  widened programmatically and the render succeeded, but the figure
  was not visually re-inspected pixel-by-pixel after the change.
  `[applied, unverified visually]` (the PDF exists at
  `analysis/report/report.pdf`; a human check of the figure panel is
  recommended).
- The nested `analysis/report/report_files/report_files/` duplicate
  reappeared after this session's render (a pandoc
  `--extract-media` quirk in this rmarkdown/pandoc version, not a
  content bug). It is now gitignored so it will not be committed,
  but the render pipeline itself was not modified to stop producing
  it. If this is worth fixing, it likely requires a change to
  `tools/stamp-render.R`'s pandoc invocation, which is vendored by
  zzcollab and out of scope for this manuscript-focused remediation.

## 3. New issues found while fixing

- With HC2 standard errors correctly implemented (M4), the
  test-then-adjust over-coverage the whitepaper flagged (M5) is
  somewhat larger than the referee's original OLS-based numbers
  (now up to 0.971 at $n=200$, $\gamma=0.7$, versus the referee's
  0.964-0.967 under plain OLS SEs). This does not change the
  qualitative conclusion (test-then-adjust is dominated by
  always-adjust) but strengthens it; the Coverage Properties prose
  and Figure 2 y-axis were both updated to reflect the new range.
- The `run_sim()` seeding scheme documented in Reproducibility
  (`master_seed + scenario_id` set once per scenario) means the
  eight scenarios use eight distinct, non-overlapping seeds
  (20260306-20260313 for `master_seed = 20260305`), not the
  single-seed-for-everything the code previously had informally.
  This is disclosed accurately now but is a substantive change to
  the RNG stream versus the archived `report.pdf` that predates this
  remediation; anyone who diffed old-vs-new Table 1 values against a
  prior PDF should expect small numerical differences for this
  reason, not treat them as evidence of a new bug.
- `DESCRIPTION` had no `Imports:` field and no `RoxygenNote`; this
  session added `Imports: sandwich, stats, tibble` and regenerated
  `NAMESPACE`/`man/run_sim.Rd` via `devtools::document()`. This was
  necessary for `run_sim()` to be a real, testable, exported
  function (whitepaper minor issue 10) but was not itself flagged by
  the whitepaper. `sandwich` was already present in `renv.lock`
  (verified `grep`), so no `renv::snapshot()` should be required, but
  this was verified only against the host R library
  (`renv skipped - use container for reproducibility`), not inside
  the project's Docker/renv container.
