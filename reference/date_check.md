# Check Columns for Non-Dates

Identifies any elements in the column(s) that would be changed to NA if
`as.Date` is used on the column(s). This is useful for quickly
identifying only the "problem" entries of ostensibly date column(s) that
is/are read in as a character.

## Usage

``` r
date_check(data = NULL, col = NULL)
```

## Arguments

- data:

  (dataframe) object containing at least one column of supposed dates

- col:

  (character or numeric) name(s) or column number(s) of the column(s)
  containing putative dates in the data object

## Value

(list) malformed dates from each supplied column in separate list
elements

## Examples

``` r
# Make a dataframe to test the function
loc <- c("LTR", "GIL", "PYN", "RIN")
time <- c("2021-01-01", "2021-01-0w", "1990", "2020-10-xx")
time2 <- c("1880-08-08", "2021-01-02", "1992", "2049-11-01")
time3 <- c("2022-10-31", "tomorrow", "1993", NA)

# Assemble our vectors into a dataframe
sites <- data.frame("site" = loc, "first_visit" = time, "second" = time2, "third" = time3)

# Use `date_check()` to return only the entries that would be lost
supportR::date_check(data = sites, col = c("first_visit", "second", "third"))
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
