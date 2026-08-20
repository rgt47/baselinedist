#' Simulate covariate-adjustment strategies for a two-arm RCT
#'
#' Runs a Monte Carlo simulation comparing three analysis strategies
#' for a randomized two-arm trial with a single continuous baseline
#' covariate: an unadjusted two-sample comparison, an ANCOVA model
#' with heteroskedasticity-consistent (HC2) standard errors, and a
#' test-then-adjust strategy that applies ANCOVA only when a baseline
#' balance test rejects at alpha = 0.10.
#'
#' The data-generating model is
#' \eqn{Y_i = \tau Z_i + \gamma X_i + \epsilon_i}, with
#' \eqn{X_i \sim N(0, 1)}, \eqn{\epsilon_i \sim N(0, 1 - \gamma^2)},
#' and 1:1 randomization of `Z`.
#'
#' @param n integer. Total sample size (randomized 1:1; must be even).
#' @param gamma numeric. Covariate-outcome association; the residual
#'   variance is set to `1 - gamma^2` so that `Var(Y) = 1` marginally.
#' @param tau numeric. True treatment effect. Default 0.3.
#' @param b_reps integer. Number of Monte Carlo replications.
#' @param seed integer or NULL. If not NULL, `set.seed(seed)` is
#'   called once at the start of the function for reproducibility.
#'
#' @return A tibble with one row per analysis strategy (Unadjusted,
#'   ANCOVA, Test-then-adjust), reporting bias, empirical SE, mean
#'   model SE, coverage, and power, along with Monte Carlo standard
#'   errors (MCSE) for bias, coverage, and power, following the ADEMP
#'   framework of Morris, White, and Crowther (2019, Statistics in
#'   Medicine).
#'
#' @export
run_sim <- function(n, gamma, tau = 0.3, b_reps = 5000, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  if (n %% 2 != 0) stop("n must be even for 1:1 randomization")

  results <- matrix(NA_real_, nrow = b_reps, ncol = 12)
  colnames(results) <- c(
    "est_unadj", "se_unadj", "covered_unadj", "reject_unadj",
    "est_ancova", "se_ancova", "covered_ancova", "reject_ancova",
    "est_tta", "se_tta", "covered_tta", "reject_tta"
  )
  sigma <- sqrt(1 - gamma^2)
  df_unadj <- n - 2
  df_ancova <- n - 3
  crit_unadj <- stats::qt(0.975, df = df_unadj)
  crit_ancova <- stats::qt(0.975, df = df_ancova)

  for (b in seq_len(b_reps)) {
    z <- rep(0:1, each = n / 2)
    x <- stats::rnorm(n)
    y <- tau * z + gamma * x + stats::rnorm(n, 0, sigma)

    fit_unadj <- stats::lm(y ~ z)
    su <- summary(fit_unadj)$coefficients
    est_u <- su["z", "Estimate"]
    se_u <- su["z", "Std. Error"]
    p_u <- 2 * stats::pt(abs(est_u / se_u), df_unadj, lower.tail = FALSE)
    results[b, 1:4] <- c(
      est_u, se_u, abs(est_u - tau) < crit_unadj * se_u, p_u < 0.05
    )

    fit_ancova <- stats::lm(y ~ z + x)
    est_a <- stats::coef(fit_ancova)["z"]
    vcov_a <- sandwich::vcovHC(fit_ancova, type = "HC2")
    se_a <- sqrt(vcov_a["z", "z"])
    p_a <- 2 * stats::pt(abs(est_a / se_a), df_ancova, lower.tail = FALSE)
    results[b, 5:8] <- c(
      est_a, se_a, abs(est_a - tau) < crit_ancova * se_a, p_a < 0.05
    )

    p_balance <- stats::t.test(x ~ z)$p.value
    if (p_balance < 0.10) {
      results[b, 9:12] <- results[b, 5:8]
    } else {
      results[b, 9:12] <- results[b, 1:4]
    }
  }

  res <- as.data.frame(results)

  strategy_summary <- function(est, se, covered, rejected) {
    bias <- mean(est) - tau
    emp_se <- stats::sd(est)
    mean_se <- mean(se)
    coverage <- mean(covered)
    power <- mean(rejected)
    list(
      bias = bias, emp_se = emp_se, mean_se = mean_se,
      coverage = coverage, power = power,
      mcse_bias = emp_se / sqrt(b_reps),
      mcse_coverage = sqrt(coverage * (1 - coverage) / b_reps),
      mcse_power = sqrt(power * (1 - power) / b_reps)
    )
  }

  s_unadj <- strategy_summary(
    res$est_unadj, res$se_unadj, res$covered_unadj, res$reject_unadj
  )
  s_ancova <- strategy_summary(
    res$est_ancova, res$se_ancova, res$covered_ancova, res$reject_ancova
  )
  s_tta <- strategy_summary(
    res$est_tta, res$se_tta, res$covered_tta, res$reject_tta
  )

  tibble::tibble(
    n = n, gamma = gamma,
    strategy = c("Unadjusted", "ANCOVA", "Test-then-adjust"),
    bias = c(s_unadj$bias, s_ancova$bias, s_tta$bias),
    emp_se = c(s_unadj$emp_se, s_ancova$emp_se, s_tta$emp_se),
    mean_se = c(s_unadj$mean_se, s_ancova$mean_se, s_tta$mean_se),
    coverage = c(s_unadj$coverage, s_ancova$coverage, s_tta$coverage),
    power = c(s_unadj$power, s_ancova$power, s_tta$power),
    mcse_bias = c(
      s_unadj$mcse_bias, s_ancova$mcse_bias, s_tta$mcse_bias
    ),
    mcse_coverage = c(
      s_unadj$mcse_coverage, s_ancova$mcse_coverage,
      s_tta$mcse_coverage
    ),
    mcse_power = c(
      s_unadj$mcse_power, s_ancova$mcse_power, s_tta$mcse_power
    )
  )
}
