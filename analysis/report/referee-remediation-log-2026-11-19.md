# Referee remediation log: report.Rmd (12-baseline-covariate-dist)
*2026-11-19 00:18 PST*

Source review: `referee-report-2026-11-18.md` (recommendation: reject
for a top-tier methods journal; major revision as a tutorial). Builds
on `voice-revision-log-2026-11-18.md` and
`docs/pub_review_remediation_2026-08-20.md`. Nothing was committed,
staged, or rendered. Pre-edit copies of `report.Rmd`, `references.bib`,
`R/run_sim.R`, and `R/run_sim_binary.R` are in
`/private/tmp/claude-501/rem-12/`.

Evidence labels: [verified] means code was run or a primary source
was read; [inspected] means checked against a secondary source or by
reading; [applied, unverified] means the edit was made but not
confirmed.

Files changed: `analysis/report/report.Rmd`,
`analysis/report/references.bib`, `R/run_sim.R`,
`R/run_sim_binary.R`, `man/run_sim.Rd`, `man/run_sim_binary.Rd`.

## 1. Fixed

### Major comments (section 4)

- **M1 (criterion 11 contradicts FDA; 'fully consistent' false).**
  Criterion 11 now states that EMA excludes interaction terms from
  the primary model and FDA allows them if the primary analysis
  estimates the average treatment effect. It recommends the
  no-interaction model under 1:1 allocation and Lin's interacted
  estimator with a robust SE otherwise. 'Consistency with regulatory
  guidance' was rewritten to list where the agencies agree and the
  two places they differ (interactions; data-adaptive selection).
  [verified against the FDA 2023 final guidance PDF, Section III.B,
  downloaded from fda.gov and converted with `pdftotext`. The EMA
  2015 guideline PDF (ema.europa.eu) was also read: 'The primary
  model should not include treatment by covariate interactions', and
  variable-selection methods 'should be avoided in confirmatory
  clinical trials'.]
- **M2 (test-then-adjust mechanism misstated).** Paragraph rewritten
  around the conditional-variance argument, citing Permutt (1990).
  A new block in the `key-values` chunk computes the truncated-normal
  factor kappa = 0.623, P(accept) = 0.90, conditional SD 0.181
  (n = 100, gamma = 0.7), accepted-stratum coverage 0.970, and the
  implied overall coverage 0.968 (assuming nominal ANCOVA coverage in
  the rejected stratum). These are computed inline, not hard-coded.
  The text now says that 0.177 and 0.195 are both test-then-adjust
  quantities and quotes ANCOVA's empirical SE (0.145) from the table.
  [verified: a 10,000-replicate scratch check
  (`/private/tmp/claude-501/rem-12/tta.R`) gave P(accept) 0.900,
  conditional SD 0.182, accepted-stratum coverage 0.971, and ANCOVA
  coverage 0.949 in the rejected stratum; table values are 0.969 and
  0.971]
- **M3 (standardization justification garbled).** Replaced the
  'identifiable' paragraph with the score-equation argument
  (canonical link, intercept, treatment indicator, ML fit; arm means
  of fitted values equal observed arm means; randomization). It cites
  Freedman (2008, Stat Sci), Rosenblum and van der Laan (2010), and
  Steingrimsson et al. (2017). The theory section now separates
  Rosenblum and van der Laan (2009, tests) from the 2010 paper
  (estimators). [applied; argument inspected, references verified
  via Crossref]
- **M4 (FDA guidance paraphrased inaccurately).** The FDA bullet list
  was replaced with close paraphrases of the guidance: 'an acceptable
  method', nominal SEs acceptable for two-arm 1:1 trials,
  interactions allowed, SEs should account for stratification,
  data-adaptive selection to be discussed (not prohibited), and
  standardization as 'one reliable method'. 'Should', not 'must', is
  used, and the guidance is described as nonbinding. The lineage
  sentence
  naming Benkeser et al. was removed. It is replaced by a list of
  works that do appear in the guidance's reference list. [verified
  against the FDA PDF]
- Wang, Ogburn and Rosenblum (2019) is described from its
  abstract (IDEAS listing): under simple randomization with equal
  allocation, the usual ANCOVA standard error is consistent under
  arbitrary misspecification. Point-estimate consistency is credited
  to Yang and Tsiatis (2001). [inspected: abstract via IDEAS]
- **M5 (Morris et al. 2022 misrepresented).** Now reports the actual
  conclusions: avoid direct adjustment for marginal estimands
  because of convergence; convergence most likely with IPTW; no
  single approach always best. [inspected; relies on the referee's
  verified reading of arXiv 2107.06398]
- **M6 (citations attached to claims the sources do not make).**
  - Criterion 6 no longer cites Assmann et al. (2000). It cites
    Permutt (1990), Raab et al. (2000), and Beach and Meier (1989),
    and notes the FDA's discuss-in-advance position. [applied]
  - Criterion 10 now cites Rosenblum and van der Laan 2009 and 2010
    together, and Tsiatis et al.; the claim was reworded. [applied]
  - Senn (2013) myths are now unnumbered, with a note that they are
    not consecutive in Senn's list. The section was retitled 'Myths
    about randomization that bear on adjustment' (also minor 12).
    [inspected: a search summary of the abstract gives these as
    myths 2, 3, and 5]
  - '14 of 41': the attribution to Kahan and Morris (2012, Stat Med)
    is correct and was kept. The sentence now says the figure comes
    from a review of recent general medical literature. [inspected:
    search summary of the Stat Med abstract]
- **M7 (criteria not operational).** Each criterion now states its
  conditions. Criterion 1 is now 'adjust if, at the design stage, at
  least one covariate is known to be prognostic'. Criterion 2 adds
  that SEs must account for stratified randomization (Bugni et al.
  2018; Ye, Yi and Shao 2022). Criterion 5 gives a break-even rule:
  the expected ANCOVA variance factor is
  (1 - R^2)(n - 3)/(n - k - 3), so adjustment helps when
  R^2 > k/(n - 3). This is labeled as standard normal theory, not
  attributed to Raab et al. Criteria 7 and 10 were reconciled:
  model-based SEs are acceptable for two-arm 1:1 designs, and robust
  SEs or the bootstrap otherwise. [verified: the variance factor was
  derived from the Beta distribution of R^2_{Z|X}. It was checked by
  simulation (`/private/tmp/claude-501/rem-12/kcov.R`, `kcov2.R`,
  20,000 replicates per cell) for k = 2 to 10 and n = 20 to 100,
  with and without prognostic covariates. All cells agree within
  Monte Carlo error.]
- **M8 (simulations too narrow to 'support' criteria 8 and 10).**
  Narrowed rather than extended. 'Supports' and 'illustrate this
  directly' were removed everywhere. The binary scenario is now
  described as illustrating criterion 8 under one mild
  misspecification. The text says explicitly that it does not bear
  on criterion 10, because both standardization arms use HC2 and
  there is no model-based comparator. The Results quote the
  true-RD range (0.130 to 0.124) from the saved output and cite
  Tackney et al. (2023) for richer misspecification. Changed in the
  Methods, binary Results, criteria 8 and 10, Limitations, abstract,
  and `R/run_sim_binary.R` roxygen with `man/run_sim_binary.Rd`.
  [applied; inline values verified by purl+source]

### References (section 6)

- Added 8 entries, each DOI checked with
  `https://api.crossref.org/works/<doi>`: `permuttImbalance1990`,
  `rosenblumGLM2010`, `freedmanLogistic2008`,
  `steingrimssonBinary2017`, `bugniCAR2018`, `yeMinimization2022`,
  `wangANCOVA2019`, `tackneyMisspecification2023`. All are cited.
  [verified]
- Lines 155 and 333: handled under M6 and M4.
- Future research item 4 now names `RobinCar`, `beeca`, `stdReg`,
  and `marginaleffects` alongside `estimatr`. [verified: all on CRAN
  via `available.packages()`; titles checked with
  `tools::CRAN_package_db()`]

### Minor comments (section 5)

- 1: 'Var(Y) = 1 marginally' is now 'within-arm variance 1', with the
  marginal value 1 + tau^2/4 = 1.0225, in the Rmd, `R/run_sim.R`, and
  `man/run_sim.Rd`. [applied]
- 2: 'coincide' replaced; at gamma2 = 0 both models are correct and
  one is over-fitted (Rmd, roxygen, Rd). [applied]
- 3, 4: gain stated as an expectation over randomizations with the
  (X1bar - X0bar)^2 term; unbiasedness stated as conditional under a
  correct linear model. [applied]
- 5: 'typically much more so' replaced with a statement that the
  gain depends on prognostic strength and can be negligible.
  [applied]
- 6: Robinson and Jewell: both the SE increase and the power
  increase are now stated. [applied; not checked against the paper]
- 7: the ICH E9 quotation is now the verbatim section 5.7 text,
  including 'compensate for any lack of balance'. The tension with
  Senn is discussed, and the 'unadjusted analysis as primary when in
  doubt' clause is noted. [verified against the ICH E9 PDF from
  database.ich.org]
- 8: CRASH: '14-day mortality in 9497 participants of the CRASH
  trial, which randomized 10,008 patients'. [inspected: search
  summary of the PMC full text]
- 9: gamma = 0 exception added to the Results with inline values
  (0.1987 vs 0.1974); the abstract no longer says 'dominates'.
  [verified by purl+source]
- 10: The binary n = 200, gamma2 = 0.8 cell now reports that
  correct-model coverage (0.939) is about 2.1 MCSE below 0.95,
  computed inline. It
  notes that all three estimators have mean SE below empirical SE in
  that cell and that a larger B is needed. [verified values]
- 11: Raab formula sentence dropped; replaced by the derived rule
  (M7).
- 12: myths section retitled (M6).
- 14: Pocock 2002 title typo fixed. Thompson 2015 corrected (see New
  issues). The eleven unused entries are left in the bib; pandoc
  renders only cited keys. `kahanReporting2012` remains unused.
- 15: title changed (the 2026-08-20 log deferred this as an
  editorial decision affecting the paper's identity across `share/`
  copies; changed here because 'Objective Criteria' overstates the
  claim) to 'Baseline Covariate Adjustment in Randomized
  Clinical Trials: A Tutorial on When and How to Adjust'. The
  section heading 'Summary of objective criteria' is now 'Summary of
  the criteria', and 'objective criteria' was removed from the
  Introduction. **Author to confirm the title.**
- 17: MCSE(Bias) column added to both results tables. [verified the
  chunks run via purl+source; table layout not rendered]

## 2. Deferred

- Minor 16 (`toc: true`, `\thanks` in the YAML author field): a
  journal-format decision for the author. Unchanged.
- Section 7 suggestions 1 and 2 (a scenario with interaction,
  skewed covariate, and small n; a stratified-randomization
  scenario): not attempted. The claims were narrowed instead (M8).
  These would turn the illustrations into tests of criteria 2, 7,
  10, and 11.
- Section 7 suggestion 4 (criteria as a one-page table) and
  suggestion 5 (MCSE for relative efficiency): not done.
- Not checked against full texts: the Morris et al. (2022) wording
  (relies on the referee's arXiv check), Robinson and Jewell (1991),
  Wang, Ogburn and Rosenblum (2019; scope taken from secondary
  summaries), Beach and Meier (1989), Raab et al. (2000), and the
  Kahan '14 of 41' and Senn myth numbers (search summaries only).
- Render not performed (per instructions). Run
  `bash tools/render.sh analysis/report/report.Rmd` to check the
  wider tables (new MCSE(Bias) column; `scale_down` is set) and the
  new display math.

**Values for author confirmation:**

- Illustrative values chosen here: n = 100, k = 5 in criterion 5,
  giving the R^2 > 5/97 (about 5%) threshold. These are labeled as
  illustrative in the text.
- Author-voice readings added here: the reading of the ICH E9
  'compensate for any lack of balance' clause ('We read the ICH
  clause as ...'), and the 'adds three things' novelty sentence in
  Present Study.
- The new title.
- gamma = 0.7 in the test-then-adjust derivation. It matches an
  existing simulation cell and is not a new choice.

## 3. New issues found while fixing

- **Bibliography DOI errors not flagged by the referee** (Crossref
  sweep of every DOI in `references.bib`):
  - `thompsonCovariate2015`: DOI resolved to an unrelated editorial.
    Corrected to 10.1016/j.jclinepi.2014.11.001, vol 68(9). First
    author is Douglas, not Danielle.
  - `yePractice2023`: DOI 404. Corrected to
    10.1080/01621459.2022.2049278.
  - `schulerPrognostic2022`: DOI pointed to an unrelated IJE paper,
    and the journal was wrong. Corrected to Int J Biostat
    18(2):329-356, 10.1515/ijb-2021-0072; 'John' corrected to 'Jon'.
  - `vanLanckerGroupSequential2025`: DOI typo corrected
    (biom -> biomtc).
  - `freedmanRegression2008`: title did not match the DOI and
    journal. The Ann Appl Stat 2(1):176-196 paper is 'On Regression
    Adjustments in Experiments with Several Treatments'. Title
    corrected; the manuscript's claims about it are generic to
    Freedman's critique.
  - `ichE9Statistical1999`: DOI does not resolve in Crossref. The
    nearest registered record (pages 1903-1942) is Lewis's
    introductory note, with Lewis as author, so it is a different
    record. The broken DOI was removed and pages 1905--1942 were
    kept. The author should choose between citing the Stat Med
    reprint or the ICH document itself (Deferred).
  - `tangenNonparametric1999` (unused): DOI does not resolve; left
    as is.
- The delta-method SE in `standardize_se()` treats the sample
  covariates as fixed. It omits the term for averaging over the
  covariate distribution. For this design that term is plausibly
  negligible (on the order of Var_X(RD(X))/n). Not quantified;
  unverified.

## 4. Abstract voice pass

- Word count (from the Background label through the Conclusions
  text, labels included): 355 -> 298.
- Factual changes:
  1. 'Absence of objective criteria' and 'We develop such criteria'
     were replaced by 'This paper is a tutorial review'. Reason: M7
     and minor 15.
  2. Methods now name both simulations and say that they illustrate
     known results. MCSEs are stated for bias, coverage, and power
     only, matching the tables (the old text implied MCSEs for
     efficiency). Reason: M8 and accuracy.
  3. Results add the derived covariate-number rule. Reason: M7.
  4. Results state that the EMA and FDA differ on interactions and
     data-adaptive selection. Reason: M1 and M4. This replaces
     'aligns with the existing theoretical and regulatory
     consensus'.
  5. 'ANCOVA dominates the unadjusted analysis on efficiency' became
     'With a prognostic covariate, ANCOVA gained efficiency'.
     Reason: minor 9.
  6. Test-then-adjust: added power close to the unadjusted analysis
     and the selection-effect explanation. Reason: M2.
  7. 'Approximately unbiased ... true nonlinear covariate term' was
     kept in substance as 'omitted a quadratic term ... nearly
     unbiased'. Reason: M8.
  8. Removed the 'principle established by Senn (1994)' and ADEMP
     citations; both remain cited in the body.
  9. Conclusions add 'The simulations illustrate the criteria but do
     not test them'. Reason: M8.
- Sentence lengths: maximum 19 words, mean 12.3. None exceed 25.
  'Covariates' and 'efficiency' were kept as terms of art.

## Scratch checks (copied here because `/private/tmp` may be cleared)

`tta.R` (n = 100, gamma = 0.7, 10,000 replicates, seed 11) gave:
P(accept) 0.8999; conditional SD of the unadjusted estimate given
acceptance 0.1822; unadjusted coverage given acceptance 0.9708;
ANCOVA (HC2) coverage given rejection 0.9491 (1001 replicates).
Analytic values: 0.900, 0.1806, 0.9700; implied overall 0.9680.

```r
set.seed(11)
n <- 100; g <- 0.7; tau <- 0.3; B <- 10000
z <- rep(0:1, each = n / 2)
out <- t(replicate(B, {
  x <- rnorm(n); y <- tau * z + g * x + rnorm(n, 0, sqrt(1 - g^2))
  s <- summary(lm(y ~ z))$coefficients
  fa <- lm(y ~ z + x); va <- sandwich::vcovHC(fa, type = 'HC2')
  acc <- t.test(x ~ z)$p.value >= 0.10
  cu <- abs(s[2, 1] - tau) < qt(0.975, n - 2) * s[2, 2]
  ca <- abs(coef(fa)[2] - tau) < qt(0.975, n - 3) * sqrt(va[2, 2])
  c(acc = acc, est_u = s[2, 1], cu = cu, ca = ca)
}))
```

`kcov2.R` (seed 2, 20,000 replicates; within-arm outcome variance 1):
observed variance ratio to 4/n versus (1 - R^2)(n - 3)/(n - k - 3):
n = 20, k = 6, R^2 = 0.2: 1.228 vs 1.236; n = 40, k = 4,
R^2 = 0.1: 0.998 vs 1.009; n = 30, k = 8, R^2 = 0.3: 0.996 vs 0.995.
With pure-noise covariates (`kcov.R`, seed 1): n = 20, k = 2: 1.132
vs 1.133; n = 20, k = 6: 1.567 vs 1.545; n = 40, k = 4: 1.130 vs
1.121; n = 40, k = 10: 1.368 vs 1.370; n = 100, k = 10: 1.108 vs
1.115.

```r
chk <- function(n, k, r2, reps = 20000) {
  z <- rep(0:1, each = n / 2)
  b <- sqrt(r2 / k)
  est <- replicate(reps, {
    x <- matrix(rnorm(n * k), n, k)
    y <- x %*% rep(b, k) + rnorm(n, 0, sqrt(1 - r2))
    coef(lm.fit(cbind(1, z, x), y))[2]
  })
  c(ratio = var(est) / (4 / n), pred = (1 - r2) * (n - 3) / (n - k - 3))
}
```

## Checks

- tinytest: 21 of 21 assertions pass (`test_basic.R` 2,
  `test_run_sim.R` 8, `test_run_sim_binary.R` 11). [verified]
- `knitr::purl()` extracts the code. With
  `options(knitr.purl.inline = TRUE)`, the purled script (including
  every inline expression) was sourced from the repo root without
  error. [verified]
- YAML front matter parses with `yaml::yaml.load()`. [verified]
- Every `@key` in the manuscript exists in `references.bib`; there
  are no duplicate keys. [verified]
- Em dashes: 0 before and 0 after. [verified]
- `tools::checkRd()` is clean on the two edited Rd files. [verified]
