
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src = "man/figures/supportR_hex.png" align = "right" width = "15%"/>

# `supportR` - Support Functions for Wrangling and Visualization

<!-- badges: start -->

[![R-CMD-check](https://github.com/njlyon0/supportR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/njlyon0/supportR/actions/workflows/R-CMD-check.yaml)
![GitHub last
commit](https://img.shields.io/github/last-commit/njlyon0/supportR)
![GitHub
issues](https://img.shields.io/github/issues-raw/njlyon0/supportR)
![GitHub pull
requests](https://img.shields.io/github/issues-pr/njlyon0/supportR)
<!-- badges: end -->

`supportR` is an R package where the only unifying theme of the
functions is honestly just that I wrote them. That said, there are some
useful functions for **data wrangling** and **plotting** in particular,
though functions for *other purposes* are also included. I’ll add
functions to this package as I write more orphan scripts that I hope
others might find useful so stay tuned!

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("njlyon0/supportR")
```

### Summarizing

- **`summary_table`**: Calculates summary values (mean, standard
  deviation, sample size, and standard error) of a given response
  variable within supplied groups

### Quality Control (QC)

- **`num_check`**: Checks a column that *should* contain only
  **numeric** values for any entries that would be coerced to NA if
  `as.numeric` is run

  - An extension of this function is **`multi_num_check`** that accepts
    a vector of columns to check at the same time

- **`date_check`**: Checks a column that *should* contain only **date**
  values for any entries that would be coerced to NA if `as.Date` is run

  - An extension of this function is **`multi_date_check`** that accepts
    a vector of columns to check at the same time

- **`date_format_guess`**: Checks a column containing multiple ambiguous
  date formats and identifies its best guess for the format each date is
  in (e.g., ‘dd/mm/yyyy’ versus ‘yyyy/dd/mm’, etc.)

- **`diff_check`**: Compares two vectors and identifies what elements
  are found in the first but not the second (i.e., *lost* components)
  and what elements are found in the second but not the first (i.e.,
  *gained* components)

  - This use-case is more oblique but I find it useful when I’m checking
    which columns are in the data before versus after a significant
    wrangling step to make sure no columns are lost/gained unexpectedly

### Visualization & Graphics

- **`theme_lyon`**: Applies a set of modifications to the non-data
  aspects of a `ggplot2` plot to ensure a consistent “feel” of a set of
  plots

- **`nms_ord`**: Creates a Non-Metric Multi-Dimensional Scaling (NMS)
  ordination with base R. Requires the dissimilarity matrix returned by
  `vegan::metaMDS`

- **`pcoa_ord`**: Creates a Principal Coordinates Analysis (PCoA)
  ordination with base R. Requires the distance matrix returned by
  `ape::pcoa`

### Reshaping Data

- **`crop_tri`**: Removes the specified “triangle” (either upper or
  lower) of a symmetric data object by replacing with NAs. Also allows
  user to specify whether to keep or also drop the diagonal

- **`array_melt`**: “Flattens” an array of dimensions X, Y, and Z into a
  dataframe containing columns `x`, `y`, `z`, and `value` where `value`
  is whatever was stored in the array at those coordinates

### Miscellaneous Other Functions

- **`rmd_export`**: Allows knitting of a specified R Markdown file
  locally and simultaneously to a specified Google Drive folder. *NOTE:*
  you must authorize R to work with Google Drive by using
  `googldrive::drive_auth` for this function to work

## Looking Ahead

More functions are likely to be developed and housed within this package
so stay tuned! Feel free to post ideas for new functions as [an
issue](https://github.com/njlyon0/supportR/issues) on this repository
and I’ll do my best to build them!
