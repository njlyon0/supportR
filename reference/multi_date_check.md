# Check Multiple Columns for Non-Dates

**\[deprecated\]**

This function was deprecated because I realized that it is just a
special case of the
[`date_check()`](https://njlyon0.github.io/supportR/reference/date_check.md)
function.

## Usage

``` r
multi_date_check(data = NULL, col_vec = NULL)
```

## Arguments

- data:

  (dataframe) object containing at least one column of supposed dates

- col_vec:

  (character or numeric) vector of names or column numbers of the
  columns containing putative dates in the data object

## Value

list of same length as `col_vec` with malformed dates from each column
in their respective element

## Examples

``` r
# Make a dataframe to test the function
loc <- c("LTR", "GIL", "PYN", "RIN")
time <- c('2021-01-01', '2021-01-0w', '1990', '2020-10-xx')
time2 <- c('1880-08-08', '2021-01-02', '1992', '2049-11-01')
time3 <- c('2022-10-31', 'tomorrow', '1993', NA)

# Assemble our vectors into a dataframe
sites <- data.frame('site' = loc, 'first_visit' = time, "second" = time2, "third" = time3)

# Use `multi_date_check()` to return only the entries that would be lost
multi_date_check(data = sites, col_vec = c("first_visit", "second", "third"))
#> Warning: `multi_date_check()` was deprecated in supportR 1.2.0.
#> ℹ Please use `date_check()` instead.
#> For 'first_visit', 3 non-dates identified: '2021-01-0w' | '1990' | '2020-10-xx'
#> For 'second', 1 non-dates identified: '1992'
#> For 'third', 2 non-dates identified: 'tomorrow' | '1993'
#> $first_visit
#> [1] "2021-01-0w" "1990"       "2020-10-xx"
#> 
#> $second
#> [1] "1992"
#> 
#> $third
#> [1] "tomorrow" "1993"    
#> 
```
