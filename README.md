
<!-- README.md is generated from README.Rmd. Please edit that file -->

# helpR

<!-- badges: start -->
<!-- badges: end -->

The goal of `helpR` is to to handle some wrangling and plotting edge
cases that I found myself repeatedly running into that I couldn’t find
pre-built R packages to handle. Hopefully they can help you as well!

## Installation

You can install the development version of `helpR` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("NJLyon-Projects/helpR")
```

## helpR Packages

These are the functions currently in `helpR`:

#### Wrangle Numbers
- `num_chk()` = identify values in a given column that would be coerced to NA if `as.numeric()` is used.
- `multi_num_chk()` = apply `num_chk()` to each column in a vector of column names.

#### Wrangle Dates
- `date_chk()` = identify values in a given column that would be coerced to NA if `as.Date()` is used.
- `multi_date_chk` = apply `date_chk()` to each column in a vector of column names. Note that the `date_...()` functions may throw an 'ambiguous date format' error but this is a problem with `as.Date()` not with my functions.

#### Make Ordinations
- `nms_ord()` = Non-metric Multi-dimensional Scaling ordination of up to 10 groups.
- `pcoa_ord()` = Principal Coordinates Analysis ordination of up to 10 groups. These functions have several aesthetic parameters that can be user-modified including plot title, group colors, and ellipse line types.

#### Export RMarkdowns
- `rmd_export()` = knit an RMarkdown file (either as a .html or .pdf) and export it to a specified Google Drive folder.

## Looking Ahead

More functions are likely to be developed and housed within this package but I find myself using these four perennially for quick wrangling checks and exploratory graphing respectively so it seemed worthwhile to pivot these into a true package.

The iterative process of creating and improving most of these functions can be found in [this GitHub repository](https://github.com/NJLyon-Projects/lyon_custom-fxns) rather than here.
