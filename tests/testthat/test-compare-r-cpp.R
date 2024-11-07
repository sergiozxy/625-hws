library(stats)  # For ks.test
# Define test inputs
set.seed(42)
x <- sort(runif(100, 0, 10))
y <- sin(x) + rnorm(100, sd = 0.2)
x_eval <- seq(0, 10, length.out = 100)
bandwidth <- 0.5
n_boot <- 50
conf_level <- 0.95

# Run the R and C++ implementations
results_r <- nadaraya_watson_r(x, y, x_eval, bandwidth, n_boot, conf_level)
results_cpp <- nadaraya_watson(x, y, x_eval, bandwidth, n_boot, conf_level)

# Unit test
test_that("R and C++ implementations return the same result", {
  # Compare y_pred vectors
  expect_equal(results_r$y_pred, results_cpp$y_pred, tolerance = 1e-6)

  # Check if bootstrapping was requested, and compare confidence intervals
  if (n_boot > 0) {
    # Perform KS tests on lower and upper bounds
    ks_test_lower <- ks.test(results_r$lower, results_cpp$lower)
    ks_test_upper <- ks.test(results_r$upper, results_cpp$upper)
    cat("KS test p-values for lower bounds: ", ks_test_lower$p.value, "\n")
    cat("KS test p-values for upper bounds: ", ks_test_upper$p.value, "\n")

    # Set significance level for KS test
    alpha <- 0.05

    # Check if p-values are greater than alpha, indicating similar distributions
    expect_gt(ks_test_lower$p.value, alpha,
              label = "The distributions of the lower bounds differ significantly between R and C++ implementations")
    expect_gt(ks_test_upper$p.value, alpha,
              label = "The distributions of the upper bounds differ significantly between R and C++ implementations")
  }
})

# Additional unit tests
test_that("R and C++ implementations return consistent results under varied configurations", {

  # Test 1: Different bandwidth values
  cat("\nTest 1: Different Bandwidth Values\n")
  bandwidths <- c(0.1, 1, 1.5)
  for (bw in bandwidths) {
    results_r <- nadaraya_watson_r(x, y, x_eval, bw, n_boot, conf_level)
    results_cpp <- nadaraya_watson(x, y, x_eval, bw, n_boot, conf_level)

    expect_equal(results_r$y_pred, results_cpp$y_pred, tolerance = 1e-6)

    if (n_boot > 0) {
      ks_test_lower <- ks.test(results_r$lower, results_cpp$lower)
      ks_test_upper <- ks.test(results_r$upper, results_cpp$upper)
      # cat("Bandwidth:", bw, "- KS test p-values (lower):", ks_test_lower$p.value,  " (upper):", ks_test_upper$p.value, "\n")
      expect_gt(ks_test_lower$p.value, 0.05)
      expect_gt(ks_test_upper$p.value, 0.05)
    }
  }

  # Test 2: Increased bootstrapping samples
  cat("\nTest 2: Increased Bootstrapping Samples\n")
  results_r <- nadaraya_watson_r(x, y, x_eval, bandwidth, n_boot = 200, conf_level)
  results_cpp <- nadaraya_watson(x, y, x_eval, bandwidth, n_boot = 200, conf_level)

  expect_equal(results_r$y_pred, results_cpp$y_pred, tolerance = 1e-6)

  ks_test_lower <- ks.test(results_r$lower, results_cpp$lower)
  ks_test_upper <- ks.test(results_r$upper, results_cpp$upper)
  # cat("Increased n_boot - KS test p-values (lower):", ks_test_lower$p.value, " (upper):", ks_test_upper$p.value, "\n")
  expect_gt(ks_test_lower$p.value, 0.05)
  expect_gt(ks_test_upper$p.value, 0.05)

  # Test 3: Varying evaluation points
  cat("\nTest 3: Varying Evaluation Points\n")
  x_eval_varied <- seq(0, 10, length.out = 50)  # Fewer evaluation points
  results_r <- nadaraya_watson_r(x, y, x_eval_varied, bandwidth, n_boot, conf_level)
  results_cpp <- nadaraya_watson(x, y, x_eval_varied, bandwidth, n_boot, conf_level)

  expect_equal(results_r$y_pred, results_cpp$y_pred, tolerance = 1e-6)

  if (n_boot > 0) {
    ks_test_lower <- ks.test(results_r$lower, results_cpp$lower)
    ks_test_upper <- ks.test(results_r$upper, results_cpp$upper)
    # cat("Varying x_eval - KS test p-values (lower):", ks_test_lower$p.value,  " (upper):", ks_test_upper$p.value, "\n")
    expect_gt(ks_test_lower$p.value, 0.05)
    expect_gt(ks_test_upper$p.value, 0.05)
  }

  # Test 4: Edge Case - Single evaluation point
  cat("\nTest 4: Single Evaluation Point\n")
  x_eval_single <- mean(x)  # Single point in the middle of the range
  results_r <- nadaraya_watson_r(x, y, x_eval_single, bandwidth, n_boot, conf_level)
  results_cpp <- nadaraya_watson(x, y, x_eval_single, bandwidth, n_boot, conf_level)

  expect_equal(results_r$y_pred, results_cpp$y_pred, tolerance = 1e-6)

  if (n_boot > 0) {
    ks_test_lower <- ks.test(results_r$lower, results_cpp$lower)
    ks_test_upper <- ks.test(results_r$upper, results_cpp$upper)
    # cat("Single x_eval - KS test p-values (lower):", ks_test_lower$p.value,  " (upper):", ks_test_upper$p.value, "\n")
    expect_gt(ks_test_lower$p.value, 0.05)
    expect_gt(ks_test_upper$p.value, 0.05)
  }
})
