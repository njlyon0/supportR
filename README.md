
<!-- README.md is generated from README.Rmd. Please edit that file -->

# helpR

<!-- badges: start -->
<!-- badges: end -->

The goal of `helpR` is to to handle some wrangling and plotting edge
cases that I found myself repeatedly running into that I couldn’t find
pre-built R packages to handle. Hopefully they can help you as well!

## Installation

You can install the development version of helpeR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("NJLyon-Projects/helpR")
```

## helpR Packages

There are currently four functions in `helpR`:

1.  `num_chk`
2.  `date_chk`
3.  `nms_ord`
4.  `pcoa_ord`

The two `..._chk` functions check a column in a dataframe to see what
values would be coerced into NA if `as.numeric()` or `as.Date()` were
called (see the prefix of these functions for which is which).

Similarly, the two `..._ord` functions create publication quality NMS or
PCoA ordinations in R’s base `graphics::plot()` function. These
functions have several aesthetic parameters that can be user-modified
including plot title, group colors, and ellipse line types.

More functions are likely to be developed and housed within this package
but I find myself using these four perennially for quick wrangling
checks and exploratory graphing respectively so it seemed worthwhile to
pivot these into a true package.

The iterative process of creating and improving these functions can be
found in [this GitHub
repository](https://github.com/NJLyon-Projects/lyon_custom-fxns) rather
than here.
