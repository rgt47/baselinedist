# Referee report: 'Baseline Covariate Adjustment in Randomized Clinical Trials: Objective Criteria for When and How to Adjust'
*2026-11-18 16:24 PST*

Manuscript: `analysis/report/report.Rmd` (source at git HEAD `2394c09`).
Line numbers and quoted wording below refer to HEAD, before the
voice revision made the same day (see
`voice-revision-log-2026-11-18.md`). That revision changed prose only
and made the file 18 lines longer, so later line numbers drift and
some quoted sentences are now split or reworded. Evidence labels:
'verified' means re-derived, executed, or checked against a primary
source; 'inspected' means read and judged; 'suspected' means plausible
but not confirmed.

## 1. Summary of the manuscript

The manuscript is a self-described tutorial and review. It surveys the
theory, empirical evidence, and regulatory guidance on adjustment for
baseline covariates in randomized clinical trials. It distills this
material into eleven 'objective criteria' grouped under when to adjust,
which covariates to adjust for, and how to adjust. Two small Monte
Carlo studies, reported under the ADEMP framework, illustrate the
criteria. The first compares unadjusted analysis, ANCOVA with HC2
standard errors, and a test-then-adjust rule for a continuous outcome
($n \in \{100, 200\}$, $\gamma \in \{0, 0.3, 0.5, 0.7\}$, $B = 5000$).
The second compares an unadjusted risk difference with marginal
standardization from a correctly specified and a misspecified logistic
working model ($\gamma_2 \in \{0, 0.4, 0.8\}$, $B = 2000$). The paper
explicitly disclaims novel methodology; its stated contribution is a
citation-backed decision procedure and a worked illustration of why
test-then-adjust fails.

## 2. Overall assessment and recommendation

Recommendation: **reject** for a top-tier methods journal (JASA,
JRSS-B, Biometrika); **major revision** if retargeted as a tutorial
(for example, Statistics in Medicine 'Tutorial in Biostatistics',
Trials, Clinical Trials, or Pharmaceutical Statistics). The paper
contains no new theory or method, and it says so. Its simulations
reproduce results that are textbook (the $1/(1-\gamma^2)$ efficiency
gain) or already published (the behavior of the preliminary balance
test). As a tutorial it is competent and readable, and the
reproducibility pipeline is in good order. However, the central
deliverable, the criteria list, contains a criterion (11) that
contradicts the FDA guidance the paper says it is 'fully consistent'
with. Several citations are used for claims their sources do not make.
The mechanistic explanation of the paper's one non-trivial simulation
finding (test-then-adjust over-coverage) is misstated. A tutorial whose
purpose is to consolidate guidance must get the guidance right; these
problems are fixable but are not cosmetic.

## 3. Significance and novelty

What is new: a synthesis, not a method. The closest existing
practitioner-facing syntheses are already cited in 'Present Study':
the FDA guidance (2023), EMA guideline (2015), Morris, Walker,
Williamson and White (Trials 2022), Kahan et al. (Trials 2014), and
Van Lancker et al. (Clinical Trials 2024). The manuscript does not
state what its eleven criteria add beyond these, item by item.

The test-then-adjust result is not new. Permutt (Stat Med 1990;
9:1455-1462) studied the operating characteristics of the preliminary
balance test under a parametric model, Senn (1989, 1994) argued the
same point, and Beach and Meier (1989) studied data-driven covariate
choice. Zhao and Ding (2023, arXiv:2307.08203) extend the analysis
nonparametrically. The misspecification scenario overlaps Tackney et
al. (Trials 2023; 24:14), which compares G-computation, IPTW, AIPTW,
TMLE, and ANCOVA under misspecification in small trials, with a much
richer design than the present one omitted-quadratic case.

Contemporariness: the review stops short of several developments a
current referee would expect. These include model-robust inference
under covariate-adaptive randomization (Bugni, Canay and Shaikh, JASA
2018; Ye, Shao, Yi and Zhao, JASA 2023, which is cited but not used),
which bears directly on criterion 2. They also include Wang, Ogburn and
Rosenblum (Biometrics 2019) on ANCOVA without model assumptions, and
existing software (`RobinCar`, `beeca`, `marginaleffects`, `stdReg`),
which makes Future Research item 4 out of date.

## 4. Major comments

Correctness first.

**M1. Criterion 11 contradicts the FDA guidance, and 'fully
consistent' (lines 1098-1112) is false.** Verified against the FDA
final guidance text (May 2023, Section III.B): 'The linear model may
include treatment by covariate interaction terms. However, when using
this approach, the primary analysis can still be based on an estimate
from the model of the average treatment effect (Tsiatis et al. 2008;
Ye et al. 2021).' Criterion 11 instead forbids interaction terms in
the primary analysis, citing only EMA. The manuscript's own theory
section (lines 195-227) says Lin's fully interacted estimator 'cannot
hurt asymptotic precision' and that ANCOVA II is most efficient (Yang
and Tsiatis 2001). The criteria therefore contradict both the cited
theory and one of the two regulators. Remedy: state that EMA and FDA
differ on this point. Recommend either the no-interaction model
(adequate under 1:1 allocation) or Lin's interacted estimator with a
robust SE, and replace 'fully consistent' with an accurate account of
where the agencies agree and differ.

**M2. The explanation of test-then-adjust over-coverage misstates the
comparison (lines 818-834).** Verified by analytic derivation and a
20,000-replicate check ($n = 100$, $\gamma = 0.7$; script in the
reviewer's scratch directory). Conditional on passing the balance test
($p \ge 0.10$, probability about 0.90), the mean difference in $X$ is
truncated, so the conditional sampling SD of the unadjusted estimator
is about 0.181. Its model SE still estimates the unconditional value,
about 0.200. Coverage in that stratum is therefore about 0.971. The
remaining 10% use ANCOVA; a second 20,000-replicate run gave ANCOVA
coverage of 0.951 in the rejected stratum. The weighted result,
$0.90 \times 0.971 + 0.10 \times 0.951 \approx 0.969$, reproduces the
table. The text instead says the unadjusted SE is conservative
'relative to the empirical variability that would obtain if ANCOVA
were always used', then quotes two numbers that are both
test-then-adjust quantities (empirical SE 0.177 and mean model SE
0.195). ANCOVA's empirical SE in that cell is 0.145. The conclusion
(test-then-adjust is dominated) is right; the stated mechanism is
wrong. It is also a selection effect, namely conditioning on an
ancillary statistic. So 'not model selection bias in the usual sense'
needs care: the point estimate is unbiased, but the inference is
conditional on the selection event. Remedy: rewrite the paragraph
around the conditional-variance argument and cite Permutt (1990).

**M3. The theoretical justification for standardization under
misspecification is garbled (lines 662-672).** Inspected. The text says
the target 'should remain identifiable' and that averaging predictions
'over the observed, rather than a covariate-adjusted, distribution'
removes dependence on correct specification. Identifiability is not
the issue; consistency of the estimator is. The standard argument is
that for a canonical-link GLM with an intercept and a treatment
indicator, fitted by maximum likelihood, the score equations make the
arm-specific means of the fitted values equal the observed arm means.
Randomization then makes the whole-sample average of the
counterfactual predictions consistent for each arm's marginal mean.
The canonical references are Rosenblum and van der Laan (Int J
Biostat 2010), Freedman (Stat Sci 2008, 'Randomization does not
justify logistic regression'), and Steingrimsson et al. (Contemp Clin
Trials 2017). The FDA guidance cites the last two for exactly this
estimator. Rosenblum and van der Laan (2009), as cited, concern
hypothesis tests, not estimators. Remedy: state the argument
correctly and cite these sources.

**M4. Regulatory guidance is paraphrased inaccurately (lines
312-333, 1103-1112).** Inspected against the FDA text.

- 'Use of ANCOVA for continuous outcomes': the guidance does not use
  the term; it says linear-model adjustment is 'an acceptable method'.
- 'Avoidance of data-driven covariate selection': the guidance asks
  sponsors to 'discuss proposals for ... data-adaptive covariate
  selection' with the review division. That is not a prohibition.
- 'The FDA guidance specifically recommends standardization for
  nonlinear models': the guidance gives standardization as 'one
  reliable method' and also permits conditional effects.
- 'Informed directly by ... @benkeserCovid2021': Benkeser et al. is
  not among the guidance's references (Tsiatis 2008 and Colantuoni and
  Rosenblum 2015 are). The claim about what informed the agency is not
  supportable from the document.
- The guidance recommends that SEs account for stratified
  randomization (Bugni et al. 2018; Ye et al. 2021). This is directly
  relevant to criterion 2 and is omitted.

Remedy: quote or closely paraphrase the guidance, and drop claims
about its intellectual lineage.

**M5. Morris et al. (2022) is misrepresented (lines 432-441).**
Verified against the arXiv abstract (2107.06398). The paper says
direct adjustment should be avoided for marginal estimands because of
convergence issues, that 'convergence is most likely with IPTW', and
that 'no single approach is always best'. The manuscript says Morris et
al. 'concluded that standardization should be preferred ... because it
avoids convergence problems'. Remedy: report the actual conclusion.

**M6. Citations attached to claims the sources do not make.**
Inspected; confirmation would need full texts.

- Criterion 6 (line 1065): @assmannSubgroupAnalysis2000 is a survey of
  reporting practice. It does not show that data-driven covariate
  selection produces biased inference. Permutt (1990) or Beach and
  Meier (1989) fit better.
- Criterion 10 (lines 1088-1091) cites @rosenblumRegression2009 for
  robust SEs in estimation; the paper concerns hypothesis tests.
- Lines 371-380: the three myths are labeled 1-3. In Senn (2013) the
  corresponding myths appear to be numbered differently. 'Balance is
  necessary' and 'covariates may be ignored' are myths 2 and 3, and
  'randomization is inefficient' is myth 5 (suspected; based on the
  2011 conference version, not the 2013 full text). Present them
  unnumbered or with Senn's numbering.
- Line 155: '14 of 41 eligible studies' is attributed to
  @kahanImproper2012. The figure may come from the review in that
  paper or from the companion BMJ review (@kahanReporting2012, in the
  bib but uncited) (suspected). Check and cite the correct paper.

**M7. The criteria are presented as 'objective' but several are not
operational.** Inspected. Criterion 1 ('always, if prognostic
covariates are available and pre-specified') is circular, because
pre-specification is the decision at issue. Criterion 5 ('small
relative to sample size') gives no threshold, though the text says
Raab et al. supply a formula; give it. Criteria 7 and 10 conflict:
7 says OLS or robust SEs are both acceptable in balanced designs, and
10 says use robust SEs. The FDA text supports criterion 7 for 1:1
two-arm trials, so 10 should be qualified. Remedy: give each criterion
a decision rule, a threshold where one exists, and the conditions
under which it applies.

**M8. The simulations illustrate known results and are too narrow to
'support' criteria 8 and 10.** Inspected. The continuous scenario's
efficiency curve is the textbook $1/(1-\gamma^2)$. The binary scenario
varies one mild misspecification; the true risk difference moves only
from 0.130 to 0.124 across $\gamma_2$, and the misspecified model loses
little efficiency. The Limitations section discloses most of this.
For a tutorial this is acceptable if the text calls the simulations
illustrations, not support. Lines 1004-1008 and 1092-1097 say the
results 'support the theoretical claim' and 'illustrate this
directly'. Remedy: either soften to 'illustrate', or add a scenario
where misspecification matters (treatment-covariate interaction,
skewed covariate, small $n$), as in Tackney et al. (2023).

## 5. Minor comments

1. Line 525: '$\sigma^2 = 1 - \gamma^2$ so that $\text{Var}(Y) = 1$
   marginally'. Verified: the marginal variance includes the treatment
   term, $1 + \tau^2/4 = 1.0225$. Say 'within-arm variance 1'. The same
   wording appears in `R/run_sim.R`.
2. Lines 1020-1022 and `R/run_sim_binary.R`: at $\gamma_2 = 0$ the two
   working models do not 'coincide'. The 'correct' model still fits
   the $X^2$ term. Both are correctly specified; one is over-fitted.
3. Line 175: 'It is clear that this result holds regardless of whether
   randomization produced balanced or imbalanced groups'. Conditional
   on the realized allocation, the ANCOVA variance includes a term in
   $(\bar X_1 - \bar X_0)^2$, so the gain is an expectation, not a
   per-trial guarantee. (After the voice revision the sentence reads
   'It is clear that this result holds whether randomization produced
   balanced or imbalanced groups'; the substance is unchanged.)
4. Lines 182-186: 'ANCOVA does not require baseline balance, even in
   expectation, to provide unbiased treatment effect estimates'. This
   holds conditionally under a correct linear model; state the
   condition.
5. Lines 236-237: 'typically much more so' overstates Tsiatis et al.
   The gain depends on prognostic strength and can be negligible.
6. Lines 260-266: Robinson and Jewell show the conditional OR's SE
   increases while power also increases, because the estimand moves
   away from the null. State both halves.
7. Lines 287-292: the ICH E9 'quotation' appears to be a paraphrase.
   Section 5.7 reads, approximately, 'consider how to account for these
   in the analysis in order to improve precision and to compensate for
   any lack of balance' (suspected; not checked against the PDF). The
   'compensate for any lack of balance' clause sits in tension with
   Senn and should be discussed, not dropped.
8. Line 400: CRASH '$n = 9497$' should be checked against Turner et
   al. (2012); CRASH randomized 10,008 patients (not verified).
9. Abstract and line 84: 'ANCOVA dominates the unadjusted analysis on
   efficiency' does not hold at $\gamma = 0$, where ANCOVA's empirical
   SE is marginally larger (0.1987 vs 0.1974 at $n = 100$). This is
   expected (one lost degree of freedom) but 'dominates' should be
   qualified.
10. Binary results, $n = 200$, $\gamma_2 = 0.8$: coverage of both
    standardization estimators is about 0.94 (MCSE 0.005). The mean
    model SE is below the empirical SE, but the unadjusted row shows a
    similar gap, so this is likely shared Monte Carlo noise. 'Consistent
    with nominal 95%' is fair, but report the MCSE comparison.
11. Lines 1056-1059: give the Raab et al. formula or drop the sentence.
12. Section 'Seven Myths' (line 365) lists three; retitle or explain.
13. Criterion 4 uses a double hyphen (' -- '); replace. (Already
    fixed by the same-day voice revision.)
14. Bibliography hygiene: `thompsonCovariate2015` lists volume 67;
    J Clin Epidemiol 2015 is volume 68 (suspected). Eleven entries are
    unused (`thompsonCovariate2015`, `kahanReporting2012`,
    `lesaffreNonparametric2003`, `jiangRobust2019`, `wangSubgroup2007`,
    `steyerbergBaseline2000`, `pocockStatistics2015`,
    `hernandezSubgroup2005`, `ciolinoImbalance2013`,
    `geWeightedRisk2011`, `tangenNonparametric1999`). Pocock 2002 title
    has a typo ('Practiceand').
15. Title still promises 'Objective Criteria'; the body concedes the
    paper is a tutorial. Consider a title that says so.
16. `toc: true` and `\thanks` in the YAML author field are unusual
    for journal submission.
17. Table 1 reports MCSE for coverage and power but not bias, although
    `run_sim()` returns `mcse_bias`.

## 6. Missing and questionable references

| Claim location | Issue | Suggested source |
|---|---|---|
| Lines 806-834 (test-then-adjust) | Prior analysis of the preliminary balance test not cited | Permutt T. Testing for imbalance of covariates in controlled experiments. Stat Med. 1990;9(12):1455-1462. |
| Lines 662-672 (standardization under misspecification) | Correct justification and canonical citations missing | Rosenblum M, van der Laan MJ. Simple, efficient estimators of treatment effects in randomized trials using generalized linear models to leverage baseline variables. Int J Biostat. 2010;6(1):Article 13. Freedman DA. Randomization does not justify logistic regression. Stat Sci. 2008;23(2):237-249. |
| Criterion 8 | FDA's own cited source for the g-computation estimator | Steingrimsson JA, Hanley DF, Rosenblum M. Improving precision by adjusting for prognostic baseline variables in randomized trials with binary outcomes, without regression model assumptions. Contemp Clin Trials. 2017;54:18-24. |
| Criterion 2 | Inference under stratified/covariate-adaptive randomization | Bugni FA, Canay IA, Shaikh AM. Inference under covariate-adaptive randomization. J Am Stat Assoc. 2018;113(524):1784-1796. |
| Criterion 7, Theory | Assumption-lean ANCOVA | Wang B, Ogburn EL, Rosenblum M. Analysis of covariance in randomized trials: more precision and valid confidence intervals, without model assumptions. Biometrics. 2019;75(4):1391-1400. |
| Binary scenario, Limitations | Overlapping, richer misspecification simulation | Tackney MS, Morris T, White I, Leyrat C, Diaz-Ordaz K, Williamson E. A comparison of covariate adjustment approaches under model misspecification in individually randomized trials. Trials. 2023;24:14. |
| Line 1065 (criterion 6) | Assmann 2000 does not show biased inference from data-driven selection | Permutt (1990) above; Beach and Meier (1989), already in bib. |
| Line 333 | Benkeser 2021 not cited by FDA | Remove the lineage claim, or cite FDA's actual references. |
| Line 155 | Source of '14 of 41' | Kahan BC, Morris TP. Reporting and analysis of trials using stratified randomisation in leading medical journals. BMJ. 2012;345:e5840 (already in bib), if that is the source. |
| Future Research item 4 | Existing software ignored | `RobinCar` (Ye, Bannick et al.); `beeca` (Przybylski et al., 2024, CRAN). |

## 7. Suggestions for strengthening the paper

1. Add a scenario where misspecification matters: a
   treatment-by-covariate interaction with a skewed covariate at small
   $n$, comparing ANCOVA, Lin's interacted estimator, and
   standardization. This would test criteria 7, 10, and 11 rather than
   illustrate them.
2. Add a stratified-randomization scenario that shows the conservative
   SE when stratification factors are omitted (criterion 2), using
   `RobinCar` or a simple stratified ANCOVA.
3. Replace the test-then-adjust prose with a short derivation of the
   conditional variance; it is two lines and makes the point exactly.
4. Present the criteria as a one-page table with columns for rule,
   condition, threshold, and primary source, and mark where EMA and
   FDA differ.
5. Report MCSE for bias and for relative efficiency (delta method) in
   the tables and figure.
6. Retarget to a tutorial venue and retitle accordingly.

## 8. Scope of this review

Verified:

- Test-then-adjust coverage mechanism re-derived analytically and
  checked with two 20,000-replicate simulations (accepted and
  rejected strata, about one minute each).
- Relative efficiency against $1/(1-\gamma^2)$ (1.93 and 1.95 observed
  vs 1.96 theoretical at $\gamma = 0.7$).
- Marginal variance algebra (minor comment 1).
- FDA 2023 guidance text (PDF from fda.gov) for interaction terms,
  standardization, data-adaptive selection, SE recommendations, and
  reference list.
- Morris et al. (2022) abstract (arXiv 2107.06398).
- Hernández et al. (2004) '3% to 46%' (abstract, via search).
- Colantuoni and Rosenblum (2015) '22-30%' (via search of PMC text).

Inspected: the saved simulation outputs (`sim_results.rds`,
`sim_results_binary.rds`) were printed and compared with the values
the Results prose cites; the inline R expressions were read, not
evaluated by rendering. Also inspected: all code in `R/run_sim.R`,
`R/run_sim_binary.R`, both
driver scripts, and every code chunk in the manuscript. The code
implements what the Methods describe (seeds, $B$, parameter values,
HC2, delta-method SE). The bibliography was read for hygiene.

Not checked:

- The simulations were not rerun at full scale.
- The test suite was not run.
- The document was not rendered.
- Direct quotations from Senn (1994), ICH E9, Lin (2013, 'two wrongs
  make a right'), and Harrell (2024) were not checked against the
  originals.
- Senn (2013) myth numbering and the Kahan '14 of 41' figure rest on
  secondary search summaries (suspected).
- The CRASH sample size, Beach and Meier's findings, Raab et al.'s
  formula, and Schuler et al.'s efficiency-bound conditions were not
  checked.

Literature searches run (web): Senn 2013 seven myths; FDA 2023
covariate guidance on interactions and unconditional effects;
Hernández 2004 sample-size reduction; Morris et al. 2022 convergence
and IPTW; Kahan and Morris 2012 review figures; Colantuoni and
Rosenblum 2015 sample-size reduction; Permutt 1990 preliminary balance
test; Tackney et al. 2023 misspecification comparison.
