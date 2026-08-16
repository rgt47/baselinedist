# Publication Review White Paper: baselinedist
*Review date: 2026-08-16 10:10 PDT*

Workspace: `12-baseline-covariate-dist` (inner repository
`baselinedist`). Manuscript under review:
`analysis/report/report.Rmd` ("Baseline Covariate Adjustment in
Randomized Clinical Trials: Objective Criteria for When and How to
Adjust"), with rendered artifacts `report.tex`, `report.pdf`, and a
staged copy in `analysis/report/share/`. No other manuscript exists
outside `archive/`. Epistemic status is marked per claim: verified
(code or arithmetic executed), inspected (source read), inferred, or
unverified.

## 1. Summary of the work under review

The manuscript is a literature synthesis on covariate adjustment in
randomized clinical trials, organized around three questions: when to
adjust, which covariates to include, and how to specify the
adjustment. It reviews the ANCOVA and change-score literature, the
Freedman-Lin exchange, semiparametric efficiency theory, survival
extensions, and the ICH E9/E9(R1), EMA 2015, and FDA 2023 regulatory
guidance, then distills eleven numbered "objective criteria." A small
Monte Carlo simulation (continuous outcome, one covariate, factorial
in n = 100, 200 and gamma = 0, 0.3, 0.5, 0.7, B = 5000) compares
unadjusted analysis, ANCOVA, and a test-then-adjust strategy on bias,
empirical and model SE, coverage, and power, embedded directly in the
Rmd (inspected). The abstract itself concedes that "the criteria are
not new findings but are a consolidation of dispersed guidance,"
which correctly signals that this is a review/tutorial paper, not a
methods paper.

## 2. Major issues

### M1. Headline power claim contradicts the paper's own table

Location: `analysis/report/report.Rmd`, Results, "Efficiency Gains
from ANCOVA" (lines 672-675); rendered `report.tex` lines 738-744.

The prose states that for gamma = 0.7 and n = 100, "ANCOVA increases
power from approximately 0.56 to approximately 0.88." The rendered
Table 2 in the same document reports, for n = 100 and gamma = 0.7,
unadjusted power 0.312 and ANCOVA power 0.553 (inspected). An
analytic check (verified: normal-approximation power computed in R)
gives 0.323 and 0.556 for n = 100, and 0.564 and 0.844 for n = 200.
The quoted sentence therefore misreads the n = 200 row as the n = 100
row and additionally inflates 0.83-0.84 to 0.88. A referee who checks
the table against the prose, as any referee of a simulation paper
will, would treat this as a disqualifying carelessness signal in a
paper whose stated purpose is to give practitioners reliable numbers.
Remediation: replace the sentence with values computed from
`sim_results` inline (never hard-coded), and audit every numeric
claim in the Results and Abstract against chunk output.

### M2. Reproducibility section describes a pipeline that does not exist

Location: `analysis/report/report.Rmd`, "Reproducibility" and "Data
availability statement" sections (lines 921-946).

Multiple claims are false against the repository (verified by
directory listing):

- "The simulation driver sets `set.seed(20260411)` at the top of the
  replicate loop. Per-replicate seeds derive from the master seed by
  `+ rep_idx`." The actual code sets `set.seed(20260305)` once in the
  setup chunk (line 48); there is no per-replicate seeding and no
  seed inside the cached `simulation` chunk (inspected).
- "`MASS` (multivariate normal data generation)" is listed as a
  principal package; the code uses only `rnorm` and never loads
  `MASS` (inspected).
- "Cached results, intermediate LaTeX, and figure outputs are at
  `analysis/data/` and `analysis/figures/`." `analysis/figures/`,
  `analysis/tables/`, and `analysis/scripts/` are empty;
  `analysis/data/` contains only an unrelated template README
  (verified).

A fabricated reproducibility statement is worse than none: it would
fail any journal reproducibility check and undermines trust in the
rest of the paper. Remediation: rewrite the section to describe the
actual mechanism (single seed in setup chunk, simulation embedded in
the Rmd, `cache=TRUE`), or better, refactor the simulation into a
script under `analysis/scripts/` that writes results to
`analysis/data/derived_data/`, and have the Rmd read those results.

### M3. Abstract claims a simulation factor that was never varied

Location: `analysis/report/report.Rmd`, Abstract, Methods paragraph
(lines 62-72).

The abstract states the simulation evidence spans "varying
covariate-outcome correlations, sample sizes, and covariate-imbalance
levels." The simulation varies only gamma and n; baseline imbalance
is never a design factor, and no scenario induces or conditions on
imbalance (inspected). Since a central message of the paper is that
adjustment decisions must not depend on observed imbalance, the
absence of any imbalance-conditional analysis (e.g., performance of
test-then-adjust conditional on the balance test outcome, as in the
Permutt and Senn analyses) is also a substantive gap, not merely a
wording problem. Remediation: either add imbalance-related scenarios
and conditional analyses, or correct the abstract to describe what
was actually done.

### M4. Simulation scope does not support the breadth of the criteria

Location: Methods and Discussion, criteria 8-10 (lines 808-833).

The eleven criteria cover binary outcomes (standardization/
g-computation), time-to-event outcomes (covariate-adjusted log-rank,
RMST), and robust variance estimation, but the simulation exercises
none of these: it is a single continuous outcome, one covariate,
correctly specified linear model, and, despite the Methods text
promising "robust (HC2) standard errors" for ANCOVA (line 501), the
code uses plain `summary(lm())` OLS standard errors (inspected; the
Limitations section even admits OLS SEs were used, directly
contradicting the Methods). A referee will object that (a) the
Methods and code disagree on the variance estimator, and (b) the
empirical section illustrates only the least controversial criterion.
Remediation: fix the Methods/code discrepancy (implement HC2 via
`sandwich`/`estimatr` or remove the claim); ideally add at least one
binary-outcome scenario showing the marginal standardization
estimator, and one misspecified-model scenario, since robustness to
misspecification is invoked repeatedly.

### M5. No Monte Carlo uncertainty, and coverage conclusions overreach

Location: Results, Table 2 and "Coverage Properties" (lines 667-761).

No Monte Carlo standard errors are reported anywhere. With B = 5000,
the MCSE of a coverage estimate near 0.95 is about 0.003, so the
test-then-adjust coverages of 0.964-0.967 (rendered table, inspected)
are genuinely above nominal, yet the prose describes this as "minor
coverage perturbations" and elsewhere claims TTA "may deviate
slightly from the nominal 95%." The actual pattern is systematic
over-coverage with mean model SE exceeding empirical SE (0.194 vs
0.178 at n = 100, gamma = 0.7), i.e., conservatism from using the
unadjusted SE in mostly balanced samples, not "model selection bias"
as the prose asserts. Also, at n = 100, gamma = 0.7, TTA power
(0.322) is essentially the unadjusted power (0.312), so "performs
between the unadjusted and ANCOVA approaches" is misleading.
Remediation: report MCSEs (the ADEMP framework of Morris, White, and
Crowther 2019 is the expected standard and is currently uncited),
correct the mechanistic explanation of TTA's behavior, and temper or
sharpen the dominance language accordingly.

### M6. Novelty claim is weak and unpositioned against existing syntheses

Location: Introduction, "Present Study" (lines 452-459); Abstract.

The stated contribution is that "a concise, unified summary of
objective criteria for covariate adjustment has not ... been widely
available." This is difficult to defend: the FDA 2023 guidance, the
EMA 2015 guideline, Morris et al. (2022, BMC Medicine), Van Lancker
et al. (2024), Ye et al. (2023), and Kahan et al. (2014, "The risks
and rewards of covariate adjustment in randomised trials," Trials,
currently uncited) each provide practitioner-facing recommendations
covering most of the eleven criteria (inspected against the
manuscript's own literature review; assessment of coverage of the
uncited works is from reviewer knowledge, unverified against their
full texts). As written, the paper is a competent narrative review
whose decision rules restate the sources it cites. A methods journal
referee would reject on novelty; the paper needs to be reframed and
targeted as a tutorial/review (see Section 5) and the "not widely
available" claim replaced with an honest positioning statement.

### M7. Reproducibility of the reported numbers depends on a knitr cache

Location: `analysis/report/report.Rmd` chunk `simulation`
(`cache=TRUE`, line 551); `analysis/report/report_cache/`.

The only seed is set in the setup chunk, and the expensive chunk is
cached. If any upstream chunk changes, or the cache is invalidated
after unrelated edits, re-rendering will consume a different RNG
stream state than the archived PDF, and Table 2 will silently change.
There is no standalone script, no saved results object under version
control, and the committed `report_cache/` binary blobs are not a
citable provenance mechanism. Remediation: set an explicit seed
inside the simulation chunk (or per-scenario seeds), move the
simulation to a script with a saved `.rds` under `analysis/data/`,
and drop `report_cache/` from the repo.

## 3. Minor issues

1. Mis-citation for Lord's paradox (line 176-177): the claim that
   ANCOVA's validity "resolves Lord's paradox" is attributed to
   Lesaffre and Senn (2003), a note on non-parametric ANCOVA; the
   Lord's paradox treatment is Senn (2006), already cited in the same
   sentence. Reassign or drop the citation (inspected bib entry).
2. Mixed British/US spelling: the Abstract uses "randomised,"
   "synthesise," "distils," while the body uses US spelling.
   Normalize to US English throughout (inspected).
3. ICH E9 is described as "(1998)" in the section heading but the bib
   entry and citation render as 1999 (the Stat Med reprint). Align
   the heading with the citation or cite the 1998 guideline document
   itself (inspected).
4. Coverage is computed with a fixed 1.96 normal quantile while
   p-values come from t distributions; at n = 100 this is a small but
   avoidable inconsistency. Use `qt(0.975, df)` per fit (inspected).
5. The prose references "Table 2" and "Figure 1"/"Figure 2" with
   hard-coded numbers despite bookdown being loaded; use `\@ref()`
   cross-references so numbering survives restructuring (inspected).
6. `rm(list = ls())` in the setup chunk is an anti-pattern inside a
   knitr session and does nothing useful (inspected).
7. Figure 2 uses `coord_cartesian(ylim = c(0.93, 0.97))` while TTA
   coverage reaches 0.967; points sit on the panel boundary. Widen
   the limits (inspected; rendered figure not visually checked,
   inferred).
8. The claim that relative efficiency "gains are independent of
   sample size" is asymptotically true but stated as an empirical
   observation from two n values; qualify it (inspected).
9. `analysis/data/README.md` is unmodified zzcollab template text
   about the Palmer Penguins dataset, irrelevant to this project and
   referenced indirectly by the data availability statement; replace
   it (verified).
10. The test suite is a stub (`inst/tinytest/test_basic.R` contains
    only `expect_true(TRUE)`); there are no tests of the simulation
    functions, and `R/` is empty, so `run_sim` exists only inside the
    Rmd and is untestable (verified).
11. `lu2008` is cited as "@luLogRank2008" for log-rank efficiency
    augmentation and again for RMST adjustment (criterion 9); the
    RMST attribution belongs to Tian/Diaz lines of work; check that
    the pairing of citations to claims in criterion 9 is correct
    (unverified).
12. Duplicated nested directory
    `report_files/report_files/figure-latex/` suggests a stale render
    artifact; clean before submission (verified path exists).
13. No ORCID/affiliation issues, but the author footnote uses
    `\thanks` inside YAML, which some journals' submission systems
    mishandle; move to a title-page block for submission (inferred).
14. Line numbering is enabled (`lineno`), which is appropriate for
    submission but the TOC (`toc: true`) is not; journals do not want
    a table of contents in a submitted manuscript (inspected).

## 4. What remains to be done

Ordered by importance for submission readiness.

**(a) Required for correctness**

1. Fix the power sentence in Results to match Table 2 (M1); replace
   all hard-coded numbers in prose and Abstract with inline code.
2. Rewrite the Reproducibility and Data availability sections to
   describe the actual pipeline; remove the false seed, MASS, and
   path claims (M2).
3. Correct the Abstract's claim that imbalance levels were varied
   (M3), or add the corresponding scenarios.
4. Resolve the HC2-versus-OLS contradiction between Methods, code,
   and Limitations (M4).
5. Correct the mechanistic explanation of test-then-adjust
   over-coverage and the "performs between" characterization (M5).

**(b) Required for acceptance**

6. Reframe the contribution honestly as a tutorial/review with a
   decision-oriented checklist; cite and position against Kahan et
   al. (2014), Morris, White, and Crowther (2019, ADEMP), and the
   existing practitioner guides (M6).
7. Report Monte Carlo standard errors and describe the simulation
   using ADEMP structure (M5).
8. Extract the simulation into a version-controlled script with an
   internal seed and saved results; have the Rmd read the saved
   results (M2, M7).
9. Add at least one scenario beyond the correctly specified linear
   model: binary outcome with standardization, and/or a misspecified
   working model, to support criteria 8 and 10 (M4).
10. Fix the Lord's paradox citation and audit the remaining
    citation-claim pairings, especially criterion 9 (minor 1, 11).

**(c) Desirable polish**

11. Normalize spelling to US English; fix ICH E9 date; use bookdown
    cross-references; t-quantile CIs; widen Figure 2 limits.
12. Replace the template data README; remove `report_cache/` and the
    duplicated `report_files/report_files/` from version control.
13. Add real tinytest coverage for the simulation function once it
    lives in a package or script.
14. Prepare a submission-format variant (no TOC, title-page
    affiliations outside `\thanks`).

## 5. Recommended framing

Plausible framings for this paper:

- (i) A methods/simulation paper on adjustment strategies. Not
  viable: every simulation result here reproduces textbook facts
  (ANCOVA efficiency proportional to 1/(1 - gamma^2); TTA
  inadmissible), and the paper itself disclaims novelty.
- (ii) A tutorial/review with an operational checklist for applied
  trialists. Viable and closest to the manuscript as written.
- (iii) A practice-audit paper: pair the criteria with a systematic
  survey of recent trial reports quantifying how often each criterion
  is violated post-FDA-2023. Higher effort, higher novelty; the
  Introduction's citations to older audits (Assmann 2000, Pocock
  2002, Kahan 2012) show the template but no new audit exists in the
  repo.

Recommendation: framing (ii), a tutorial/review, optionally upgraded
toward (iii) if the author will invest in even a modest audit of
recent trials. Reasoning: the literature already contains the theory
(Tsiatis, Lin, Rosenblum), the regulatory rules (FDA 2023, EMA 2015),
and practitioner guides (Morris 2022, Van Lancker 2024, Kahan 2014).
What none of these provides in one place is a short, citation-backed
decision procedure written for the investigator and the SAP author,
with a worked illustration. That is a legitimate tutorial
contribution, but only if presented as such.

Implications of framing (ii):

- Title: drop the implication of new methodology; something like
  "When and how to adjust for baseline covariates in randomized
  trials: a practical checklist with worked illustration" signals the
  genre correctly.
- Abstract: remove "Methods/Results" claims of a research synthesis
  producing findings; state that the paper consolidates theory,
  regulation, and evidence into eleven pre-specifiable rules, and
  that the simulation is illustrative.
- Introduction: shorten the literature review (much of it can be
  compressed into a summary table mapping each criterion to its
  primary sources and to the FDA/EMA clauses); state explicitly what
  the paper adds beyond Morris 2022 and the FDA guidance (a compact
  decision procedure plus an illustration of why test-then-adjust
  fails).
- Comparators: the simulation's three strategies are the right
  comparators for a tutorial; adding a binary-outcome
  standardization example would let the checklist's nonlinear
  criteria be illustrated rather than asserted.
- Target journal: a tutorial venue, not JASA/Biometrics. Candidates:
  Statistics in Medicine (Tutorial in Biostatistics), BMJ/Trials
  (methodology), Clinical Trials, or BMC Medical Research
  Methodology. The current CSL (Statistics in Medicine) is
  consistent with the first option.
- Emphasize: the eleven criteria (promoted to a boxed table early in
  the paper), the criterion-to-source mapping, the TTA illustration.
  De-emphasize or move to supplement: the extended Freedman-Lin and
  semiparametric exposition (compress to one paragraph each with
  pointers), the full simulation table (headline figure in text,
  full table supplementary), and the Future Research section (fold
  into Discussion or cut).

## 6. Assessment

Verdict: major revision (as a tutorial/review submission); reject if
submitted to a methods journal in its current framing. The literature
coverage is broad and the criteria themselves are sound and well
sourced, but the manuscript currently contains a Results sentence
contradicted by its own table (M1), a reproducibility section
describing infrastructure that does not exist (M2), an abstract
overclaiming the simulation design (M3), and a Methods/code
discrepancy on variance estimation (M4). These are all fixable, and
none undermines the underlying message, but each would independently
draw a referee's objection, and M1/M2 in combination would likely
cost the paper its credibility with any careful reviewer. After the
correctness fixes, the decisive work is the reframing in Section 5
and the modest simulation extensions; with those, the paper is a
plausible tutorial submission.

## 7. Revision history

- 2026-08-16: Initial referee-grade review. Seven major issues
  identified (prose/table power contradiction; fabricated
  reproducibility claims; abstract overclaim of simulation factors;
  criteria/simulation scope mismatch including HC2/OLS discrepancy;
  missing Monte Carlo uncertainty and mischaracterized TTA behavior;
  weak novelty positioning; cache-dependent reproducibility), 14
  minor issues, and a recommended reframing as a tutorial/review
  targeting Statistics in Medicine or similar.
