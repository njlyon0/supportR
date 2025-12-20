# Safely Rename Columns in a Dataframe

Replaces specified column names with user-defined vector of new column
name(s). This operation is done "safely" because it specifically matches
each 'bad' name with its corresponding 'good' name and thus minimizes
the risk of accidentally replacing the wrong column name.

## Usage

``` r
safe_rename(data = NULL, bad_names = NULL, good_names = NULL)
```

## Arguments

- data:

  (dataframe or dataframe-like) object with column names that match the
  values passed to the `bad_names` argument

- bad_names:

  (character) vector of column names to replace in original data object.
  Order does not need to match data column order but *must* match the
  `good_names` vector order

- good_names:

  (character) vector of column names to use as replacements for data
  object. Order does not need to match data column order but *must*
  match the `good_names` vector order

## Value

(dataframe or dataframe-like) with renamed columns

## Examples

``` r
# Make a dataframe to demonstrate
df <- data.frame("first" = 1:3, "middle" = 4:6, "second" = 7:9)

# Invoke the function
supportR::safe_rename(data = df, bad_names = c("second", "middle"),
                      good_names = c("third", "second"))
#>   first second third
#> 1     1      4     7
#> 2     2      5     8
#> 3     3      6     9
```
