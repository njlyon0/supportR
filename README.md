
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src = "man/figures/supportR_hex.png" align = "right" width = "15%"/>

# `supportR` - Support Functions for Wrangling and Visualization

<!-- badges: start -->

[![R-CMD-check](https://github.com/njlyon0/supportR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/njlyon0/supportR/actions/workflows/R-CMD-check.yaml)
[![](https://cranlogs.r-pkg.org/badges/supportR)](https://cran.r-project.org/package=supportR)
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

### Data Wrangling

- **`summary_table`**: Calculates summary values (mean, standard
  deviation, sample size, and standard error) of a given response
  variable within supplied groups

- **`safe_rename`**: Renames columns in a given dataframe by matching
  ‘bad’ names with ‘good’ names

- **`name_vec`**: Creates a named vector of specified contents and
  names. Useful when creating named vectors that are too long to create
  manually or when creating the vector and then naming it is cumbersome

- **`crop_tri`**: Removes the specified “triangle” (either upper or
  lower) of a symmetric data object by replacing with NAs. Also allows
  user to specify whether to keep or also drop the diagonal

- **`array_melt`**: “Flattens” an array of dimensions X, Y, and Z into a
  dataframe containing columns `x`, `y`, `z`, and `value` where `value`
  is whatever was stored in the array at those coordinates

### Quality Control (QC)

- **`diff_check`**: Compares two vectors and identifies what elements
  are found in the first but not the second (i.e., *lost* components)
  and what elements are found in the second but not the first (i.e.,
  *gained* components). Extremely useful prior to `join`ing two
  dataframes to compare index column contents or to ensure no columns
  are unexpectedly lost during complex wrangling operations

- **`num_check`**: Checks column(s) that *should* contain only
  **numeric** values for any entries that would be coerced to NA if
  `as.numeric` is run

- **`count`**: Counts instances of each unique element in a provided
  vector

- **`date_check`**: Checks column(s) that *should* contain only **date**
  values for any entries that would be coerced to NA if `as.Date` is run

- **`date_format_guess`**: Checks a column containing multiple ambiguous
  date formats and identifies its best guess for the format each date is
  in (e.g., ‘dd/mm/yyyy’ versus ‘yyyy/dd/mm’, etc.)

### Visualization & Graphics

- **`theme_lyon`**: Applies a set of modifications to the non-data
  aspects of a `ggplot2` plot to ensure a consistent “feel” of a set of
  plots

- **`ordination`**: Creates an ordination for either the nonmetric
  multidimensional scaling (NMS) dissimilarity matrix created by
  `vegan::metaMDS` or for the principal coordinates analysis (PCoA)
  distance matrix returned by `ape::pcoa`

### Operations Outside of R

- **`github_ls`**: Lists contents of a GitHub repository from its URL
  and returns a simple dataframe containing the name, type, and file
  path of identified objects. Supports recursive listing (i.e., listing
  of contents of subfolders identified in first list of contents)

- **`github_tree`**: Creates a file tree diagram of a GitHub repository
  from its URL

- **`tabularize_md`**: Converts a markdown file into a table that
  retains the nested structure of any headings in the file. Accepts
  either the file name/path locally or a URL connection to a markdown
  file hosted online (e.g., a GitHub repository README.md, etc.)

- **`rmd_export`**: Allows knitting of a specified R Markdown file
  locally and simultaneously to a specified Google Drive folder.
  **NOTE:** you must authorize R to work with Google Drive by using
  `googldrive::drive_auth()` for this function to work

## Looking Ahead

More functions are likely to be developed and housed within this package
so stay tuned! Feel free to post ideas for new functions as [an
issue](https://github.com/njlyon0/supportR/issues) on this repository
and I’ll do my best to build them!
