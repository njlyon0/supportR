# Generate Summary Table for Supplied Response and Grouping Variables

Calculates mean, standard deviation, sample size, and standard error of
a given response variable within user-defined grouping variables. This
is meant as a convenience instead of doing
[`dplyr::group_by`](https://dplyr.tidyverse.org/reference/group_by.html)
followed by
[`dplyr::summarize`](https://dplyr.tidyverse.org/reference/summarise.html)
iteratively themselves.

## Usage

``` r
summary_table(
  data = NULL,
  groups = NULL,
  response = NULL,
  drop_na = FALSE,
  round_digits = 2
)
```

## Arguments

- data:

  (dataframe or dataframe-like) object with column names that match the
  values passed to the `groups` and `response` arguments

- groups:

  (character) vector of column names to group by

- response:

  (character) name of the column name to calculate summary statistics
  for (the column must be numeric)

- drop_na:

  (logical) whether to drop NAs in grouping variables. Defaults to FALSE

- round_digits:

  (numeric) number of digits to which mean, standard deviation, and
  standard error should be rounded

## Value

(dataframe) summary table containing the mean, standard deviation,
sample size, and standard error of the supplied response variable
