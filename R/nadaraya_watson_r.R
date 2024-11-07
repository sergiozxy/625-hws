#' Nadaraya-Watson Nonparametric Regression Estimator
#'
#' This function implements the Nadaraya-Watson estimator for nonparametric regression using
#' a Gaussian kernel. It optionally supports bootstrapping to calculate confidence intervals.
#'
#' @param x A numeric vector of predictor values (same length as \code{y}).
#' @param y A numeric vector of response values (same length as \code{x}).
#' @param x_eval A numeric vector of points at which to evaluate the regression function.
#' @param bandwidth A positive numeric value specifying the bandwidth for the Gaussian kernel.
#' @param n_boot An integer indicating the number of bootstrap samples to use for
#'        confidence interval estimation. Default is \code{0}, meaning no bootstrapping.
#' @param conf_level A numeric value between \code{0} and \code{1} specifying the
#'        confidence level for the confidence intervals. Default is \code{0.95}.
#'
#' @return A list with the following components:
#' \describe{
#'   \item{y_pred}{A numeric vector of the predicted values at each point in \code{x_eval}.}
#'   \item{lower}{(optional) A numeric vector of the lower bounds of the confidence intervals for each point in \code{x_eval} if \code{n_boot > 0}.}
#'   \item{upper}{(optional) A numeric vector of the upper bounds of the confidence intervals for each point in \code{x_eval} if \code{n_boot > 0}.}
#' }
#'
#' @details
#' The Nadaraya-Watson estimator is a kernel-based nonparametric regression estimator that
#' provides a smoothed estimate of the conditional mean of \code{y} given \code{x}.
#' This implementation uses a Gaussian kernel with fixed bandwidth.
#'
#' @examples
#' set.seed(42)
#' x <- sort(runif(100, 0, 10))
#' y <- sin(x) + rnorm(100, sd = 0.2)
#' x_eval <- seq(0, 10, length.out = 100)
#' bandwidth <- 0.5
#' results <- nadaraya_watson_r(x, y, x_eval, bandwidth, n_boot = 100, conf_level = 0.95)
#' plot(x, y)
#' lines(x_eval, results$y_pred, col = "blue")
#' if (!is.null(results$lower)) {
#'   lines(x_eval, results$lower, col = "blue", lty = 2)
#'   lines(x_eval, results$upper, col = "blue", lty = 2)
#' }
#'
#' @export
nadaraya_watson_r <- function(x, y, x_eval, bandwidth, n_boot = 0, conf_level = 0.95) {
  # Check input validity
  if (length(x) != length(y)) stop("The vectors 'x' and 'y' must be of the same length.")
  if (bandwidth <= 0) stop("Bandwidth must be a positive value.")
  if (conf_level <= 0 || conf_level >= 1) stop("Confidence level must be between 0 and 1.")
  if (length(x_eval) == 0) stop("The evaluation points 'x_eval' cannot be empty.")

  n <- length(x)
  m <- length(x_eval)
  y_pred <- numeric(m)

  # Constant normalization factor for Gaussian kernel
  norm_factor <- 1 / (bandwidth * sqrt(2 * pi))

  # Main loop for Nadaraya-Watson estimation
  for (j in seq_len(m)) {
    sum_weights <- 0
    sum_weighted_y <- 0
    for (i in seq_len(n)) {
      dist <- (x[i] - x_eval[j]) / bandwidth
      weight <- norm_factor * exp(-0.5 * dist^2)
      sum_weights <- sum_weights + weight
      sum_weighted_y <- sum_weighted_y + weight * y[i]
    }
    y_pred[j] <- sum_weighted_y / sum_weights
  }

  # Check if bootstrap is required
  if (n_boot > 0) {
    y_pred_boot <- matrix(0, nrow = n_boot, ncol = m)

    # Bootstrap loop
    for (b in seq_len(n_boot)) {
      indices <- sample(seq_len(n), n, replace = TRUE)
      x_boot <- x[indices]
      y_boot <- y[indices]

      # Calculate predictions for this bootstrap sample
      for (j in seq_len(m)) {
        sum_weights <- 0
        sum_weighted_y <- 0
        for (i in seq_len(n)) {
          dist <- (x_boot[i] - x_eval[j]) / bandwidth
          weight <- norm_factor * exp(-0.5 * dist^2)
          sum_weights <- sum_weights + weight
          sum_weighted_y <- sum_weighted_y + weight * y_boot[i]
        }
        y_pred_boot[b, j] <- sum_weighted_y / sum_weights
      }
    }

    # Calculate confidence intervals
    lower <- numeric(m)
    upper <- numeric(m)
    for (j in seq_len(m)) {
      boot_vals <- sort(y_pred_boot[, j])
      lower_idx <- max(1, floor(n_boot * (1 - conf_level) / 2))
      upper_idx <- min(n_boot, ceiling(n_boot * (1 + conf_level) / 2))
      lower[j] <- boot_vals[lower_idx]
      upper[j] <- boot_vals[upper_idx]
    }

    return(list(y_pred = y_pred, lower = lower, upper = upper))
  }

  # If no bootstrapping, return only point estimates
  list(y_pred = y_pred)
}
