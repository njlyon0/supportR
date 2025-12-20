# Identify Probable Format for Ambiguous Date Formats

In a column containing multiple date formats (e.g., MM/DD/YYYY,
"YYYY/MM/DD, etc.) identifies probable format of each date. Provision of
a grouping column improves inference. Any formats that cannot be
determined are flagged as "FORMAT UNCERTAIN" for human double-checking.
This is useful for quickly sorting the bulk of ambiguous dates into
clear categories for later conditional wrangling.

## Usage

``` r
date_format_guess(
  data = NULL,
  date_col = NULL,
  groups = TRUE,
  group_col = NULL,
  return = "dataframe",
  quiet = FALSE
)
```

## Arguments

- data:

  (dataframe) object containing at least one column of ambiguous dates

- date_col:

  (character) name of column containing ambiguous dates

- groups:

  (logical) whether groups exist in the dataframe / should be used
  (defaults to TRUE)

- group_col:

  (character) name of column containing grouping variable

- return:

  (character) either "dataframe" or "vector" depending on whether the
  user wants the date format "guesses" returned as a new column on the
  dataframe or a vector

- quiet:

  (logical) whether certain optional messages should be displayed
  (defaults to FALSE)

## Value

(dataframe or character) object containing date format guesses

## Examples

``` r
# Create dataframe of example ambiguous dates & grouping variable
my_df <- data.frame('data_enterer' = c('person A', 'person B',
                                       'person B', 'person B',
                                       'person C', 'person D',
                                       'person E', 'person F',
                                       'person G'),
                    'bad_dates' = c('2022.13.08', '2021/2/02',
                                    '2021/2/03', '2021/2/04',
                                    '1899/1/15', '10-31-1901',
                                    '26/11/1901', '08.11.2004',
                                    '6/10/02'))

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
