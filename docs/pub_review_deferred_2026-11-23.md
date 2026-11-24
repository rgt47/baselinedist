# Deferred-item pass: baselinedist
*2026-11-23 12:45 PST*

Source log: `docs/pub_review_remediation_2026-08-20.md` (Section 2
"Deferred", the "still deferred" list at the end of Section 4, and
one claim in Section 3), answering
`docs/pub_review_whitepaper_2026-08-16.md`. Later work consulted:
commits since 2026-08-19 (`960cef8`, `4894fc4`, `1129dba`,
`d37b264`, `0511e64`, `ef49e36`, `a8146e0`, `2394c09`) and the
uncommitted working tree, which contains a 2026-11-18/19 referee
remediation (`analysis/report/referee-remediation-log-2026-11-19.md`)
and a render staged at
`analysis/report/share/report-2026-11-19-1254-2394c09-wip.pdf`.

Evidence labels: [verified] means I ran code or inspected output;
[inspected] means I read files; [inferred] means a reasoned
conclusion not directly tested.

## 1. Inventory

| # | Source (08-20 log) | Item | Class |
|---|---|---|---|
| 1 | Sec. 2 | Whitepaper item 9: binary-outcome standardization / misspecified-model scenario | RESOLVED-SINCE |
| 2 | Sec. 2, Sec. 4 | Whitepaper Sec. 5 title/framing change (YAML `title:`) | RESOLVED-SINCE (author to confirm wording) |
| 3 | Sec. 2, Sec. 4 | Item 14 / minor 13-14: drop `toc: true`, move `\thanks` out of YAML author | AUTHOR-DECISION |
| 4 | Sec. 2 | Coverage figure not visually re-inspected after y-axis change | DO-NOW (done) |
| 5 | Sec. 2, Sec. 4 | Nested `report_files/report_files/` duplicate produced by render | AUTHOR-DECISION |
| 6 | Sec. 4 | No time-to-event scenario; criterion 9 rests on literature only | AUTHOR-DECISION |
| 7 | Sec. 4 | Binary scenario covers one misspecification form only | AUTHOR-DECISION |
| 8 | Sec. 4 | Follow-up work left uncommitted | RESOLVED-SINCE |
| 9 | Sec. 3 (new issue) | `sandwich` claimed present in `renv.lock`; verified only on host | RESOLVED-SINCE |

Item-by-item evidence:

- 1: implemented in the same-day follow-up (log Section 4) and
  committed in `960cef8` (`R/run_sim_binary.R`,
  `analysis/scripts/run_simulation_binary.R`,
  `sim_results_binary.rds`, `inst/tinytest/test_run_sim_binary.R`).
  The 2026-11-19 referee remediation then narrowed the manuscript's
  claims about it (illustrates criterion 8 only, not criterion 10).
  [inspected]
- 2: the working-tree `report.Rmd` title is now 'Baseline Covariate
  Adjustment in Randomized Clinical Trials: A Tutorial on When and
  How to Adjust' (2026-11-19 remediation, minor 15, uncommitted).
  That log flags the title for author confirmation. [inspected]
- 8: the follow-up files were committed by the auto-backup commit
  `960cef8` (2026-08-20 18:02). [inspected]
- 9: the 08-20 log said `sandwich` was already in `renv.lock`; it was
  in fact added afterwards in `4894fc4` and re-recorded against the
  pinned snapshot in `1129dba` / `d37b264`. The original claim was
  therefore inaccurate, but the defect is now fixed. Container-side
  restore was not tested in this pass. [inspected]

## 2. Done now

- Item 4 (coverage figure). Rasterized
  `analysis/report/report_files/figure-latex/coverage-plot-1.pdf`
  (written by the 2026-11-19 12:54 render, the same render that
  produced the current `report.pdf`) with `pdftoppm` and inspected
  it. All 24 points lie within the `coord_cartesian(ylim =
  c(0.93, 0.98))` panel; the dashed nominal line at 0.95 is visible
  in both facets; the legend is legible. The saved
  `sim_results.rds` coverage range is 0.9454 to 0.9712, inside the
  axis limits, so no clipping is possible. No file changed.
  [verified]
- Verification of the current working tree (no edits made by this
  pass):

  - `pkgload::load_all(); tinytest::run_test_dir('inst/tinytest')`:
    All ok, 21 results (7.1 s). [verified]
  - Working-tree changes to `R/run_sim.R` and `R/run_sim_binary.R`
    are roxygen text only (`git diff R/`), so the saved `.rds`
    results remain consistent with the code. [verified]
  - `report.pdf`/`report.tex` (Nov 19 12:54) postdate the last
    `report.Rmd` edit (Nov 19 00:22); `report.log` shows no undefined
    references or citations, only two benign float-placement
    warnings. The 2026-11-19 log's "render not performed" deferral is
    thus resolved by that later render. [verified]

## 3. Long runs

None. No deferred item requires a simulation rerun. The two
scope-extension items (6, 7) would need new code first; see Section 4.

## 4. Author decisions

- **Item 3, submission format (`toc: true`, `\thanks` in YAML
  author).** Options: (a) keep as is for a tutorial/preprint;
  (b) for journal submission, set `toc: false` and move affiliation
  to a title-page block or the journal template. Evidence: both are
  still present in the current YAML (lines 4 and 9). Recommendation:
  defer until the target journal is chosen; the change is
  mechanical once the venue is known.
- **Item 5, nested `report_files/report_files/`.** Options: (a) leave
  it gitignored (`.gitignore` line 13, confirmed with
  `git check-ignore`); (b) patch the render path. Evidence: the Nov
  19 render again produced byte-identical copies of both figure PDFs
  in the nested directory. `tools/stamp-render.R` calls
  `rmarkdown::render()` with only `pandoc_args` added, so the
  duplication most likely originates in rmarkdown/bookdown media
  handling, not the wrapper [inferred]; the wrapper is vendored by
  zzcollab and shared across workspaces. Recommendation: (a); it has
  no effect on the manuscript, and a fix belongs in zzcollab, not
  here.
- **Item 6, time-to-event scenario for criterion 9.** Options:
  (a) leave criterion 9 literature-supported, as the Limitations
  now state explicitly (`report.Rmd` lines 1384-1385, 1404);
  (b) add a scenario comparing the log-rank test with a
  covariate-adjusted log-rank test or adjusted RMST. Evidence: the
  2026-11-19 remediation chose to narrow claims ("illustrate, not
  test") rather than extend simulations. Recommendation: (a) for a
  tutorial framing; (b) only if the target is a methods journal,
  where the 2026-11-18 referee report recommended rejection.
- **Item 7, richer misspecification.** Options: (a) keep the single
  omitted-quadratic scenario with the existing disclosure and the
  pointer to Tackney et al. (2023) (`report.Rmd` lines 1195,
  1370-1380); (b) add link misspecification, multiple covariates, or
  doubly robust comparators. Recommendation: (a); (b) duplicates
  published work and is beyond a tutorial's needs.

## 5. New issues found

- The 2026-11-19 log noted that `standardize_se()` treats the sample
  covariates as fixed and omits the Var_X term. The saved
  `sim_results_binary.rds` (B = 2000) gives mean-SE / empirical-SE
  ratios of 0.963 to 1.009 for the standardization estimators; the
  unadjusted estimator, which has no such omission, shows the same
  pattern (0.973 in the n = 200, gamma2 = 0.8 cell, versus 0.963 and
  0.977 for the two standardized estimators). With an MCSE for the
  empirical SE of roughly 1.6% at B = 2000, the shortfall in that
  cell is consistent with Monte Carlo noise rather than the
  fixed-covariate omission. [verified ratios; attribution inferred]
- Outstanding items in the 2026-11-19 referee remediation log, which
  is not a `pub_review_remediation_*` file and so is outside this
  pass's inventory, include: confirm the new title; choose between
  citing the ICH E9 Stat Med reprint (DOI removed as nonresolving)
  or the ICH document; confirm the illustrative n = 100, k = 5
  values in criterion 5; and several sources checked only from
  abstracts or summaries (Morris et al. 2022, Robinson and Jewell
  1991, Wang et al. 2019, Beach and Meier 1989, Raab et al. 2000).
  That work, the new staged PDF, and both November logs are
  uncommitted.
