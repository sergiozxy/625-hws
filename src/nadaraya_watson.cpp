
#include <Rcpp.h>
#include <cmath>  // for M_PI and exp
#include <algorithm>  // for std::min, std::max
using namespace Rcpp;

//' Nadaraya-Watson Nonparametric Regression Estimator
//'
//' This function implements the Nadaraya-Watson estimator for nonparametric regression using
//' a Gaussian kernel. It optionally supports bootstrapping to calculate confidence intervals.
//'
//' @name nadaraya_watson
//' @param x A numeric vector of predictor values.
//' @param y A numeric vector of response values, must be the same length as \code{x}.
//' @param x_eval A numeric vector of points at which to evaluate the regression function.
//' @param bandwidth A positive numeric value specifying the bandwidth for the Gaussian kernel.
//' @param n_boot An integer indicating the number of bootstrap samples to use for
//'        confidence interval estimation. Default is \code{0}, meaning no bootstrapping.
//' @param conf_level A numeric value between \code{0} and \code{1} specifying the
//'        confidence level for the confidence intervals. Default is \code{0.95}.
//'
//' @return A list with the following components:
//' @return A list with the following components:
//'   \code{y_pred}: A numeric vector of the predicted values at each point in \code{x_eval}.
//'   \code{lower} (optional): A numeric vector of the lower bounds of the confidence intervals for each point in \code{x_eval} if \code{n_boot > 0}.
//'   \code{upper} (optional): A numeric vector of the upper bounds of the confidence intervals for each point in \code{x_eval} if \code{n_boot > 0}.
//'
//' @details
//' The Nadaraya-Watson estimator is a kernel-based nonparametric regression estimator that
//' provides a smoothed estimate of the conditional mean of \code{y} given \code{x}.
//' This implementation uses a Gaussian kernel with fixed bandwidth.
//'
//' @examples
//' set.seed(42)
//' x <- sort(runif(100, 0, 10))
//' y <- sin(x) + rnorm(100, sd = 0.2)
//' x_eval <- seq(0, 10, length.out = 100)
//' bandwidth <- 0.5
//' results <- nadaraya_watson(x, y, x_eval, bandwidth, n_boot = 100, conf_level = 0.95)
//' plot(x, y)
//' lines(x_eval, results$y_pred, col = "blue")
//' if (!is.null(results$lower)) {
//'   lines(x_eval, results$lower, col = "blue", lty = 2)
//'   lines(x_eval, results$upper, col = "blue", lty = 2)
//' }
//'
//' @export
// [[Rcpp::export]]
List nadaraya_watson(NumericVector x, NumericVector y, NumericVector x_eval, double bandwidth, int n_boot = 0, double conf_level = 0.95) {
   // Check input validity
   if (x.size() != y.size()) {
     stop("The vectors 'x' and 'y' must be of the same length.");
   }
   if (bandwidth <= 0) {
     stop("Bandwidth must be a positive value.");
   }
   if (conf_level <= 0 || conf_level >= 1) {
     stop("Confidence level must be between 0 and 1.");
   }
   if (x_eval.size() == 0) {
     stop("The evaluation points 'x_eval' cannot be empty.");
   }

   int n = x.size();
   int m = x_eval.size();
   NumericVector y_pred(m);

   // Constant normalization factor for Gaussian kernel
   double norm_factor = 1.0 / (bandwidth * std::sqrt(2 * M_PI));

   // Main loop for Nadaraya-Watson estimation
   for (int j = 0; j < m; j++) {
     double sum_weights = 0.0;
     double sum_weighted_y = 0.0;
     for (int i = 0; i < n; i++) {
       double dist = (x[i] - x_eval[j]) / bandwidth;
       double weight = norm_factor * std::exp(-0.5 * dist * dist);
       sum_weights += weight;
       sum_weighted_y += weight * y[i];
     }
     y_pred[j] = sum_weighted_y / sum_weights;
   }

   // Check if bootstrap is required
   if (n_boot > 0) {
     NumericMatrix y_pred_boot(n_boot, m);
     // debug
     // Rcout << "Starting Boostraphing" << std::endl;
     // Bootstrap loop
     for (int b = 0; b < n_boot; b++) {
       IntegerVector indices = sample(n, n, true);  // Sample with replacement
       NumericVector x_boot(n), y_boot(n);

      /*
       Rcpp::Rcout << "Bootstrap iteration " << b << ", indices: ";
       for (int i = 0; i < n; i++) {
         Rcpp::Rcout << indices[i] << " ";
        if (indices[i] < 0 || indices[i] >= n) {
          Rcpp::Rcout << "\nError: index " << indices[i] << " out of bounds!" << std::endl;
          return List::create(Named("error") = "Out of bounds in indices");
        }
      }
       */
       // Manually subset x and y using the sampled indices
       for (int i = 0; i < n; i++) {
         x_boot[i] = x[indices[i] - 1];
         y_boot[i] = y[indices[i] - 1];
       }

       // Calculate predictions for this bootstrap sample
       for (int j = 0; j < m; j++) {
         double sum_weights = 0.0;
         double sum_weighted_y = 0.0;
         for (int i = 0; i < n; i++) {
           double dist = (x_boot[i] - x_eval[j]) / bandwidth;
           double weight = norm_factor * std::exp(-0.5 * dist * dist);
           sum_weights += weight;
           sum_weighted_y += weight * y_boot[i];
         }
         y_pred_boot(b, j) = sum_weighted_y / sum_weights;
       }
     }

     // debug
     // Rcout << "Finished Boostraphing" << std::endl;

     // Calculate confidence intervals
     NumericVector lower(m), upper(m);
     for (int j = 0; j < m; j++) {
       NumericVector boot_vals = y_pred_boot(_, j);
       std::sort(boot_vals.begin(), boot_vals.end());

       int lower_idx = static_cast<int>(std::floor(n_boot * (1 - conf_level) / 2.0));
       int upper_idx = static_cast<int>(std::ceil(n_boot * (1 + conf_level) / 2.0)) - 1;

       // Adjust lower and upper indices to be within bounds
       lower_idx = std::max(0, std::min(n_boot - 1, lower_idx));
       upper_idx = std::max(0, std::min(n_boot - 1, upper_idx));

      /* debug
      if (lower_idx < 0 || lower_idx >= n_boot || upper_idx < 0 || upper_idx >= n_boot) {
        Rcpp::Rcout << "Error: Index out of bounds in confidence interval calculation" << std::endl;
        return List::create(Named("error") = "Out of bounds in confidence interval indices");
      }
      */
       lower[j] = boot_vals[lower_idx];
       upper[j] = boot_vals[upper_idx];
     }

     return List::create(Named("y_pred") = y_pred,
                         Named("lower") = lower,
                         Named("upper") = upper);
   }

   // If no bootstrapping, return only point estimates
   return List::create(Named("y_pred") = y_pred);
 }
