#' Simulate covariate-adjustment strategies for a binary outcome under
#' a misspecified working model
#'
#' Runs a Monte Carlo simulation comparing three analysis strategies
#' for a randomized two-arm trial with a binary outcome and a single
#' continuous baseline covariate: an unadjusted difference in
#' proportions, and two marginal standardization (g-computation)
#' estimators built from logistic working models, one correctly
#' specified and one that omits a true quadratic covariate term. Both
#' standardization estimators target the same marginal risk
#' difference; the scenario illustrates that standardization from a
#' misspecified conditional model remains consistent for the marginal
#' treatment effect in a randomized trial, at some cost in efficiency
#' (criteria 8 and 10 of the Discussion).
#'
#' The data-generating model is
#' \eqn{\text{logit}\{P(Y_i = 1)\} = \beta_0 + \tau Z_i + \gamma X_i +
#' \gamma_2 X_i^2}, with \eqn{X_i \sim N(0, 1)} and 1:1 randomization
#' of `Z`. The "misspecified" working model omits the \eqn{X_i^2}
#' term; `gamma2` therefore controls the degree of misspecification
#' (`gamma2 = 0` reduces the working models to the same, correctly
#' specified, linear-logit form).
#'
#' The true marginal risk difference,
#' \eqn{E[Y(1)] - E[Y(0)] = E_X[\text{expit}(\beta_0 + \tau + \gamma X
#' + \gamma_2 X^2)] - E_X[\text{expit}(\beta_0 + \gamma X + \gamma_2
#' X^2)]}, is computed once by numerical integration over the known
#' \eqn{X} density and used as the estimand for bias and coverage;
#' it does not depend on the simulated data.
#'
#' Each standardization estimator fits a logistic working model by
#' maximum likelihood, then averages the fitted probabilities under
#' the counterfactual \eqn{Z = 1} and \eqn{Z = 0} for every subject
#' in the sample and differences the two averages. Its standard error
#' is obtained by the delta method: a numerical (central
#' finite-difference) gradient of the standardized contrast with
#' respect to the model coefficients, combined with an HC2 sandwich
#' covariance matrix for those coefficients
#' (`sandwich::vcovHC(fit, type = "HC2")`).
#'
#' @param n integer. Total sample size (randomized 1:1; must be even).
#' @param gamma2 numeric. True quadratic covariate effect on the
#'   log-odds scale; also the degree to which the "misspecified"
#'   working model (which omits this term) is wrong.
#' @param tau numeric. True treatment log-odds effect. Default 0.6.
#' @param gamma numeric. True linear covariate log-odds effect.
#'   Default 0.8.
#' @param beta0 numeric. Intercept on the log-odds scale. Default
#'   -0.5.
#' @param b_reps integer. Number of Monte Carlo replications.
#' @param seed integer or NULL. If not NULL, `set.seed(seed)` is
#'   called once at the start of the function for reproducibility.
#'
#' @return A tibble with one row per analysis strategy (Unadjusted,
#'   Standardized (correct), Standardized (misspecified)), reporting
#'   the true marginal risk difference, bias, empirical SE, mean
#'   model SE, coverage, and power, along with Monte Carlo standard
#'   errors (MCSE) for bias, coverage, and power, following the ADEMP
#'   framework of Morris, White, and Crowther (2019, Statistics in
#'   Medicine).
#'
#' @export
run_sim_binary <- function(n, gamma2, tau = 0.6, gamma = 0.8,
                            beta0 = -0.5, b_reps = 5000, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  if (n %% 2 != 0) stop("n must be even for 1:1 randomization")

  true_rd <- true_marginal_rd(tau, gamma, gamma2, beta0)
  crit <- stats::qnorm(0.975)

  results <- matrix(NA_real_, nrow = b_reps, ncol = 12)
  colnames(results) <- c(
    "est_unadj", "se_unadj", "covered_unadj", "reject_unadj",
    "est_correct", "se_correct", "covered_correct", "reject_correct",
    "est_mis", "se_mis", "covered_mis", "reject_mis"
  )

  for (b in seq_len(b_reps)) {
    z <- rep(0:1, each = n / 2)
    x <- stats::rnorm(n)
    eta <- beta0 + tau * z + gamma * x + gamma2 * x^2
    p <- stats::plogis(eta)
    y <- stats::rbinom(n, 1, p)

    n_half <- n / 2
    p1 <- mean(y[z == 1])
    p0 <- mean(y[z == 0])
    est_u <- p1 - p0
    se_u <- sqrt(p1 * (1 - p1) / n_half + p0 * (1 - p0) / n_half)
    results[b, 1:4] <- c(
      est_u, se_u,
      abs(est_u - true_rd) < crit * se_u,
      abs(est_u / se_u) > crit
    )

    fit_c <- stats::glm(y ~ z + x + I(x^2), family = stats::binomial())
    vc_c <- sandwich::vcovHC(fit_c, type = "HC2")
    est_c <- standardize_rd(fit_c, x)
    se_c <- standardize_se(fit_c, x, vc_c)
    results[b, 5:8] <- c(
      est_c, se_c,
      abs(est_c - true_rd) < crit * se_c,
      abs(est_c / se_c) > crit
    )

    fit_m <- stats::glm(y ~ z + x, family = stats::binomial())
    vc_m <- sandwich::vcovHC(fit_m, type = "HC2")
    est_m <- standardize_rd(fit_m, x)
    se_m <- standardize_se(fit_m, x, vc_m)
    results[b, 9:12] <- c(
      est_m, se_m,
      abs(est_m - true_rd) < crit * se_m,
      abs(est_m / se_m) > crit
    )
  }

  res <- as.data.frame(results)

  strategy_summary <- function(est, se, covered, rejected) {
    bias <- mean(est) - true_rd
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
  s_correct <- strategy_summary(
    res$est_correct, res$se_correct, res$covered_correct,
    res$reject_correct
  )
  s_mis <- strategy_summary(
    res$est_mis, res$se_mis, res$covered_mis, res$reject_mis
  )

  tibble::tibble(
    n = n, gamma2 = gamma2, true_rd = true_rd,
    strategy = c(
      "Unadjusted", "Standardized (correct)",
      "Standardized (misspecified)"
    ),
    bias = c(s_unadj$bias, s_correct$bias, s_mis$bias),
    emp_se = c(s_unadj$emp_se, s_correct$emp_se, s_mis$emp_se),
    mean_se = c(s_unadj$mean_se, s_correct$mean_se, s_mis$mean_se),
    coverage = c(s_unadj$coverage, s_correct$coverage, s_mis$coverage),
    power = c(s_unadj$power, s_correct$power, s_mis$power),
    mcse_bias = c(
      s_unadj$mcse_bias, s_correct$mcse_bias, s_mis$mcse_bias
    ),
    mcse_coverage = c(
      s_unadj$mcse_coverage, s_correct$mcse_coverage,
      s_mis$mcse_coverage
    ),
    mcse_power = c(
      s_unadj$mcse_power, s_correct$mcse_power, s_mis$mcse_power
    )
  )
}

#' True marginal risk difference for the binary-outcome data-generating
#' model
#'
#' Computes \eqn{E[Y(1)] - E[Y(0)]} for the quadratic-logit
#' data-generating model used by [run_sim_binary()], by numerical
#' integration over the \eqn{X \sim N(0, 1)} density.
#'
#' @inheritParams run_sim_binary
#' @return A single numeric value, the true marginal risk difference.
#' @keywords internal
true_marginal_rd <- function(tau, gamma, gamma2, beta0) {
  integrand1 <- function(x) {
    stats::plogis(beta0 + tau + gamma * x + gamma2 * x^2) *
      stats::dnorm(x)
  }
  integrand0 <- function(x) {
    stats::plogis(beta0 + gamma * x + gamma2 * x^2) * stats::dnorm(x)
  }
  e1 <- stats::integrate(integrand1, -Inf, Inf)$value
  e0 <- stats::integrate(integrand0, -Inf, Inf)$value
  e1 - e0
}

#' Standardized (g-computed) marginal risk difference from a fitted
#' logistic working model
#'
#' Averages the fitted probabilities under the counterfactual
#' \eqn{Z = 1} and \eqn{Z = 0} for every subject in the sample and
#' differences the two averages. Supports working models with and
#' without a quadratic covariate term, identified by the number of
#' fitted coefficients.
#'
#' @param fit A `glm` object fit as `y ~ z + x` or
#'   `y ~ z + x + I(x^2)`, with coefficients in that order.
#' @param x numeric vector of covariate values (the same `x` used to
#'   fit `fit`).
#' @return A single numeric value, the standardized risk difference.
#' @keywords internal
standardize_rd <- function(fit, x) {
  b <- stats::coef(fit)
  has_quad <- length(b) == 4
  if (has_quad) {
    eta1 <- b[1] + b[2] + b[3] * x + b[4] * x^2
    eta0 <- b[1] + b[3] * x + b[4] * x^2
  } else {
    eta1 <- b[1] + b[2] + b[3] * x
    eta0 <- b[1] + b[3] * x
  }
  mean(stats::plogis(eta1) - stats::plogis(eta0))
}

#' Delta-method standard error of the standardized risk difference
#'
#' Computes a central finite-difference gradient of
#' [standardize_rd()] with respect to the fitted model coefficients,
#' then combines it with `vcov_mat` (typically an HC2 sandwich
#' covariance matrix) via the delta method.
#'
#' @inheritParams standardize_rd
#' @param vcov_mat A covariance matrix for `stats::coef(fit)`, with
#'   matching row/column order.
#' @param eps numeric. Finite-difference step size. Default `1e-6`.
#' @return A single numeric value, the delta-method standard error.
#' @keywords internal
standardize_se <- function(fit, x, vcov_mat, eps = 1e-6) {
  b <- stats::coef(fit)
  k <- length(b)
  g <- numeric(k)
  for (j in seq_len(k)) {
    b_plus <- b
    b_plus[j] <- b_plus[j] + eps
    b_minus <- b
    b_minus[j] <- b_minus[j] - eps
    g[j] <- (
      standardize_rd_at(b_plus, x) - standardize_rd_at(b_minus, x)
    ) / (2 * eps)
  }
  sqrt(as.numeric(t(g) %*% vcov_mat %*% g))
}

#' Standardized risk difference evaluated at an arbitrary coefficient
#' vector
#'
#' Helper for [standardize_se()]'s finite-difference gradient; same
#' computation as [standardize_rd()] but takes a raw coefficient
#' vector rather than a fitted model object.
#'
#' @param b numeric coefficient vector, length 3 (`z + x`) or 4
#'   (`z + x + I(x^2)`).
#' @param x numeric vector of covariate values.
#' @return A single numeric value, the standardized risk difference.
#' @keywords internal
standardize_rd_at <- function(b, x) {
  has_quad <- length(b) == 4
  if (has_quad) {
    eta1 <- b[1] + b[2] + b[3] * x + b[4] * x^2
    eta0 <- b[1] + b[3] * x + b[4] * x^2
  } else {
    eta1 <- b[1] + b[2] + b[3] * x
    eta0 <- b[1] + b[3] * x
  }
  mean(stats::plogis(eta1) - stats::plogis(eta0))
}
