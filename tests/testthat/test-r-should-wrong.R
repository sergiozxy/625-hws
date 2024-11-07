# Load necessary package
library(testthat)

# Define example input data
set.seed(42)
x <- sort(runif(100, 0, 10))
y <- sin(x) + rnorm(100, sd = 0.2)
x_eval <- seq(0, 10, length.out = 100)
bandwidth <- 0.5

test_that("nadaraya_watson_r returns only point estimates without bootstrapping", {
  # Case where n_boot = 0, so only point estimates should be returned
  results <- nadaraya_watson_r(x, y, x_eval, bandwidth, n_boot = 0)

  expect_type(results, "list")
  expect_true("y_pred" %in% names(results))
  expect_false("lower" %in% names(results))
  expect_false("upper" %in% names(results))
})

test_that("nadaraya_watson_r throws error when x and y lengths differ", {
  # Case where x and y have different lengths
  y_different <- y[1:50]  # shorter y vector
  expect_error(
    nadaraya_watson_r(x, y_different, x_eval, bandwidth),
    "The vectors 'x' and 'y' must be of the same length."
  )
})

test_that("nadaraya_watson_r throws error for non-positive bandwidth", {
  # Case where bandwidth is zero
  expect_error(
    nadaraya_watson_r(x, y, x_eval, bandwidth = 0),
    "Bandwidth must be a positive value."
  )

  # Case where bandwidth is negative
  expect_error(
    nadaraya_watson_r(x, y, x_eval, bandwidth = -1),
    "Bandwidth must be a positive value."
  )
})

test_that("nadaraya_watson_r throws error for invalid conf_level", {
  # Case where conf_level is out of bounds (<= 0 or >= 1)
  expect_error(
    nadaraya_watson_r(x, y, x_eval, bandwidth, n_boot = 100, conf_level = -0.1),
    "Confidence level must be between 0 and 1."
  )
  expect_error(
    nadaraya_watson_r(x, y, x_eval, bandwidth, n_boot = 100, conf_level = 1.5),
    "Confidence level must be between 0 and 1."
  )
})

test_that("nadaraya_watson_r throws error when x_eval is empty", {
  # Case where x_eval is empty
  expect_error(
    nadaraya_watson_r(x, y, numeric(0), bandwidth, n_boot = 100, conf_level = 0.95),
    "The evaluation points 'x_eval' cannot be empty."
  )
})
