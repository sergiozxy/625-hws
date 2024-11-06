# you need to ensure this package is installed
library(np)

bandwidth <- 0.5
test_that("nadaraya_watson works with simple input", {
  # Use the data from nadaraya_data
  results <- nadaraya_watson(
    nadaraya_data$x,
    nadaraya_data$y,
    nadaraya_data$x_eval,
    bandwidth,
    n_boot = 500,
    conf_level = 0.95
  )

  expect_type(results, "list")
  expect_true(all(names(results) %in% c("y_pred", "lower", "upper")))
})


test_that("nadaraya_watson returns similar output as R implementation", {
  # Compare against a reference implementation (e.g., from np package)
  library(np)
  np_model <- npreg(bws = bandwidth,
                    xdat = nadaraya_data$x,
                    ydat = nadaraya_data$y,
                    exdat = nadaraya_data$x_eval)
  y_pred_np <- predict(np_model)

  results <- nadaraya_watson(
    nadaraya_data$x,
    nadaraya_data$y,
    nadaraya_data$x_eval,
    bandwidth
  )

  # Check similarity
  expect_equal(results$y_pred, y_pred_np, tolerance = 1e-3)
})
