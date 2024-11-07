# 625-hws

<!-- badges: start -->
[![R-CMD-check](https://github.com/sergiozxy/nadarayaWatson/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/sergiozxy/nadarayaWatson/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/sergiozxy/nadarayaWatson/graph/badge.svg)](https://app.codecov.io/gh/sergiozxy/nadarayaWatson)
<!-- badges: end -->

## Introduction

This package provides an efficient implementation of the Nadaraya-Watson kernel regression estimator, utilizing Rcpp for performance optimization. The Nadaraya-Watson estimator is a nonparametric regression method used to estimate the conditional expectation of a response variable given a predictor. This package includes core functionality for estimating the regression function and bootstrapping-based confidence intervals.

### Key Features

* Efficient C++ Implementation: Leverages Rcpp to achieve faster computation compared to a purely R-based implementation, especially in scenarios requiring nested loops and extensive data manipulation.
* Bootstrap Confidence Intervals: Integrates a bootstrap resampling approach to estimate confidence intervals for the regression function, providing robust inference.
* Comparison to R-only Implementation: Demonstrates significantly improved runtime performance compared to an R-only implementation, which lacks the vectorization optimizations available through C++.

## Model Overview

$$
    \hat{m}(x) = \frac{\sum_{i=1}^n K\left(\frac{x - X_i}{h}\right) Y_i}{\sum_{i=1}^n K\left(\frac{x - X_i}{h}\right)}
$$

The Nadaraya-Watson estimator for a given point $x$ is:

* $K$ is the kernel function, determining the weight of each observation based on its distance from $x$,
* $h$ is the bandwidth parameter, which controls the smoothing level.

## Examples

The package includes an example of applying the Nadaraya-Watson estimator to synthetic data and generating confidence intervals using bootstrapping. It also offers a comparison between the Rcpp implementation and R's np package.

The Rcpp implementation provides a marked performance improvement over the R version, especially with larger datasets and higher bootstrap iterations. Benchmark results indicate that Rcpp implementation executes substantially faster, making it suitable for intensive regression tasks.

### Installation

Install directly from source as follows:

```{r}
devtools::install_github("sergiozxy/nadarayaWatson", build_vignettes = T)
```

## tasks

### Required

- [x] The README.md is clearly written and sufficiently introduces the R package.
- [x] The help pages are clearly written and sufficiently introduce the function(s) in the R package.
- [x] The examples are clearly written and sufficiently demonstrate the function(s) in the R package, and can run smoothly without error or warning.
- [x] The R code is clearly written and well organized. The coding style is neat and consistent. The comments are clearly written and helpful.
- [x] The vignette(s) are clearly written and sufficiently demonstrate the usage of the function(s) in the R package.
- [x] The comparison(s) against the original R function(s) on simulated or real datasets clearly and sufficiently demonstrate both correctness and efficiency of the function(s) implemented in the R package.
- [x] Either sample dataset(s) included in the R package or a wide range of simulated data demonstrate the applications of the function(s) implemented in the R packages (e.g., via examples in help pages or in the vignette(s))
- [x] The amount of R code is non-trivial.

### Additional works

- [x] C++ code is included via Rcpp and improves the efficiency of the function(s) implemented in the package (e.g., via comparison(s) against the original R functions(s)).
- [x] Unit testing cases are included in the R package via testthat and tests the function(s) implemented in the R package.
- [x] Continuous integration is included and integrated on the GitHub project site. All the tests are passed.
- [x] Code coverage test is included and integrated on the GitHub project site. The coverage is 100\%.

## Procedures

1. Document the package ```devtools::document()```
2. build the vignettes ```devtools::build_vignettes()```
3. load all files for testing ```devtools::load_all()```
4. Run tests ```devtools::test()```
5. Build the package (.tar.gz) ```devtools::build()```
6. install the package ```devtools::install(build_vignettes = TRUE)```
7. Run the full check to make sure it satisfies CAEN ```devtools::check()```
8. Complete the continuous integration on github add a GitHub Actions workflow and this is carried out by ```usethis::use_github_action("check-release")```, ```usethis::use_coverage()```, ```usethis::use_github_action("test-coverage")```
9. get the codev id and then upload the token
