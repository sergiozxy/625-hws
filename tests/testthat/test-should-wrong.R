test_that("nadaraya_watson returns expected output for edge cases", {
  # Edge case: bandwidth = 0 should throw an error
  expect_error(nadaraya_watson(
    nadaraya_data$x,
    nadaraya_data$y,
    nadaraya_data$x_eval,
    bandwidth = 0
  ),
  "Bandwidth must be a positive value.")

  # Edge case: x and y of different lengths
  expect_error(nadaraya_watson(
    nadaraya_data$x,
    nadaraya_data$y[1:50],
    nadaraya_data$x_eval,
    bandwidth = 0.5
  ),
  "The vectors 'x' and 'y' must be of the same length.")
})

test_that("nadaraya_watson returns expected error for incorrect argument types", {
    expect_error(
      nadaraya_watson(
        nadaraya_data$x,
        nadaraya_data$y,
        nadaraya_data$x_eval,
        nadaraya_data$x_eval
      ),
      regexp = "Expecting a single value: \\[extent=100\\]"
    )
  })


test_that("nadaraya_watson throws error for invalid conf_level", {
  # Case where conf_level is out of bounds (<= 0 or >= 1)
  expect_error(
    nadaraya_watson(nadaraya_data$x,
                     nadaraya_data$y,
                     nadaraya_data$x_eval,
                     bandwidth = 0.5, n_boot = 100, conf_level = -0.1),
    "Confidence level must be between 0 and 1."
  )
  expect_error(
    nadaraya_watson(nadaraya_data$x,
                    nadaraya_data$y,
                    nadaraya_data$x_eval,
                    bandwidth = 0.5, n_boot = 100, conf_level = 1.5),
    "Confidence level must be between 0 and 1."
  )
})

test_that("nadaraya_watson throws error when x_eval is empty", {
  # Case where x_eval is empty
  expect_error(
    nadaraya_watson(nadaraya_data$x,
                    nadaraya_data$y, numeric(0), bandwidth = 0.5, n_boot = 100, conf_level = 0.95),
    "The evaluation points 'x_eval' cannot be empty."
  )
})


