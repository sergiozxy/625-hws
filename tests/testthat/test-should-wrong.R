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
