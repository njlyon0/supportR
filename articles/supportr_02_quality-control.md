# Quality Control

## Overview

The `supportR` package is an amalgam of distinct functions I’ve written
to accomplish small data wrangling, quality control, or visualization
tasks. These functions tend to be short and narrowly-defined. An
additional consequence of the motivation for creating them is that they
tend to not be inter-related or united by a common theme. If this
vignette feels somewhat scattered because of that, I hope it doesn’t
negatively affect how informative it is or your willingness to adopt
`supportR` into your scripts!

This vignette describes the main functions of `supportR` using the
examples included in each function.

``` r
#install.packages("supportR")
library(supportR)
```

### Identify Differences Between Two Vectors

In terms of quality control functions, `diff_check` compares two vectors
and reports back what is in the first but not the second (i.e., what is
“lost”) and what is in the second but not the first (i.e., what is
“gained”). I find this most useful (A) when comparing the index columns
of two data objects I intend to join together and (B) to ensure no
columns are unintentionally removed during lengthy `tidyverse`-style
pipes (`%>%`).

`diff_check` also includes optional logical arguments `sort` and
`return` that will respectively either sort the difference in both
vectors and return a two-element if set to `TRUE`.

``` r
# Make two vectors
vec1 <- c("x", "a", "b")
vec2 <- c("y", "z", "a")

# Compare them!
supportR::diff_check(old = vec1, new = vec2, sort = TRUE, return = TRUE)
#> Following element(s) found in old object but not new:
#> [1] "b" "x"
#> Following element(s) found in new object but not old:
#> [1] "y" "z"
#> $lost
#> [1] "b" "x"
#> 
#> $gained
#> [1] "y" "z"
```

### Identify Non-Numbers

This package also includes the function `num_check` that identifies all
values of a column that would be coerced to `NA` if `as.numeric` was run
on the column. Once these non-numbers are identified you can handle that
in whatever way you feel is most appropriate. `num_check` is intended
only to flag these for your attention, *not* to attempt a fix using a
method you may or may not support.

``` r
# Make a dataframe with non-numbers in a number column
fish <- data.frame("species" = c("salmon", "bass", "halibut", "eel"),
                   "count" = c(1, "14x", "_23", 12))

# Use `num_check` to identify non-numbers
supportR::num_check(data = fish, col = "count")
#> For 'count', 2 non-numbers identified: '14x' | '_23'
#> $count
#> [1] "14x" "_23"
```

### Identify Malformed Dates

`date_check` does a similar operation but is checking a column for
entries that would be coerced to `NA` by `as.Date` instead. Note that if
a date is sufficiently badly formatted `as.Date` will throw an error
instead of coercing to `NA` so `date_check` will do the same thing.

``` r
# Make a dataframe including malformed dates
sites <- data.frame("site" = c("LTR", "GIL", "PYN", "RIN"),
                    "visit" = c("2021-01-01", "2021-01-0w", "1990", "2020-10-xx"))

# Now we can use our function to identify bad dates
supportR::date_check(data = sites, col = "visit")
#> For 'visit', 3 non-dates identified: '2021-01-0w' | '1990' | '2020-10-xx'
#> $visit
#> [1] "2021-01-0w" "1990"       "2020-10-xx"
```

Both `num_check` and `date_check` can accept multiple column names to
the `col` argument (as of version 1.1.1) and all columns are checked
separately.

### Deduce Date Formats from Ambiguous Dates

Another date column quality control function is `date_format_guess`.
This This function checks a column of dates (stored as characters!) and
tries to guess the format of the date (i.e., month/day/year,
day/month/year, etc.).

It can make a more informed guess if there is a grouping column because
it can use the frequency of the “date” entries within those groups to
guess whether a given number is the day or the month. This is based on
the assumption that sampling occurs more often within months than across
them so the number that occurs in more rows within the grouping values
is most likely month.

Recognizing that assumption may be uncomfortable for some users, the
`groups` argument can be set to `FALSE` and it will do the clearer
judgment calls (i.e., if a number is \>12 it is day, etc.). Note that
dates that cannot be guessed by my function will return “FORMAT
UNCERTAIN” so that you can handle them using your knowledge of the
system (or by returning to your raw data if need be).

``` r
# Make a dataframe with dates in various formats and a grouping column
my_df <- data.frame("data_enterer" = c("person A", "person B",
                                       "person B", "person B",
                                       "person C", "person D",
                                       "person E", "person F",
                                       "person G"),
                    "bad_dates" = c("2022.13.08", "2021/2/02",
                                    "2021/2/03", "2021/2/04",
                                    "1899/1/15", "10-31-1901",
                                    "26/11/1901", "08.11.2004",
                                    "6/10/02"))

# Now we can invoke the function!
supportR::date_format_guess(data = my_df, date_col = "bad_dates",
                            group_col = "data_enterer", return = "dataframe")
#> Returning dataframe of data format guesses
#>   data_enterer  bad_dates     format_guess
#> 1     person A 2022.13.08   year/day/month
#> 2     person B  2021/2/02   year/month/day
#> 3     person B  2021/2/03   year/month/day
#> 4     person B  2021/2/04   year/month/day
#> 5     person C  1899/1/15   year/month/day
#> 6     person D 10-31-1901   month/day/year
#> 7     person E 26/11/1901   day/month/year
#> 8     person F 08.11.2004 FORMAT UNCERTAIN
#> 9     person G    6/10/02 FORMAT UNCERTAIN

# If preferred, do it without groups and return a vector
supportR::date_format_guess(data = my_df, date_col = "bad_dates",
                            groups = FALSE, return = "vector")
#> Defining 'groups' is strongly recommended! If none exist, consider adding a single artificial group shared by all rows then re-run this function
#> Returning vector of data format guesses
#> [1] "year/day/month"   "FORMAT UNCERTAIN" "FORMAT UNCERTAIN" "FORMAT UNCERTAIN"
#> [5] "year/month/day"   "month/day/year"   "day/month/year"   "FORMAT UNCERTAIN"
#> [9] "FORMAT UNCERTAIN"
```
