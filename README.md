# 625-hws

<!-- badges: start -->
[![R-CMD-check](https://github.com/sergiozxy/nadarayaWatson/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/sergiozxy/nadarayaWatson/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/sergiozxy/nadarayaWatson/graph/badge.svg)](https://app.codecov.io/gh/sergiozxy/nadarayaWatson)
<!-- badges: end -->

Tasks need to do here: adding the R implementation of the package and compare the R package and the Cpp package.
Writing more vignette.


## tasks

### Required

- [x] The README.md is clearly written and sufficiently introduces the R package.
- [x] The help pages are clearly written and sufficiently introduce the function(s) in the R package.
- [ ] The examples are clearly written and sufficiently demonstrate the function(s) in the R package, and can run smoothly without error or warning.
- [x] The R code is clearly written and well organized. The coding style is neat and consistent. The comments are clearly written and helpful.
- [x] The vignette(s) are clearly written and sufficiently demonstrate the usage of the function(s) in the R package.
- [ ] The comparison(s) against the original R function(s) on simulated or real datasets clearly and sufficiently demonstrate both correctness and efficiency of the function(s) implemented in the R package.
- [x] Either sample dataset(s) included in the R package or a wide range of simulated data demonstrate the applications of the function(s) implemented in the R packages (e.g., via examples in help pages or in the vignette(s))
- [x] The amount of R code is non-trivial.

### Additional works

- [x] C++ code is included via Rcpp and improves the efficiency of the function(s) implemented in the package (e.g., via comparison(s) against the original R functions(s)).
- [ ] Unit testing cases are included in the R package via testthat and tests the function(s) implemented in the R package.
- [ ] Continuous integration is included and integrated on the GitHub project site. All the tests are passed.
- [ ] Code coverage test is included and integrated on the GitHub project site. The coverage is 100\%.

## Introduction

## Procedures

1. Document the package ```devtools::document()```
2. build the vignettes ```devtools::build_vignettes()```
3. load all files for testing ```devtools::load_all()```
4. Run tests ```devtools::test()```
5. Build the package (.tar.gz) ```devtools::build()```
6. install the package ```devtools::install(build_vignettes = TRUE)```
7. Run the full check to make sure it satisfies CAEN ```devtools::check()```
8. Complete the continuous integration on github add a GitHub Actions workflow

