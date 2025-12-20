# Check Multiple Columns for Non-Numbers

**\[deprecated\]**

This function was deprecated because I realized that it is just a
special case of the
[`num_check()`](https://njlyon0.github.io/supportR/reference/num_check.md)
function.

## Usage

``` r
multi_num_check(data = NULL, col_vec = NULL)
```

## Arguments

- data:

  (dataframe) object containing at least one column of supposed numbers

- col_vec:

  (character or numeric) vector of names or column numbers of the
  columns containing putative numbers in the data object

## Value

list of same length as `col_vec` with malformed numbers from each column
in their respective element

## Examples

``` r
# Create dataframe with a numeric column where some entries would be coerced into NA
spp <- c('salmon', 'bass', 'halibut', 'eel')
ct <- c(1, '14x', '_23', 12)
ct2 <- c('a', '2', '4', '0')
ct3 <- c(NA, 'Y', 'typo', '2')
fish <- data.frame('species' = spp, 'count' = ct, 'num_col2' = ct2, 'third_count' = ct3)

# Use `multi_num_check()` to return only the entries that would be lost
multi_num_check(data = fish, col_vec = c("count", "num_col2", "third_count"))
#> Warning: `multi_num_check()` was deprecated in supportR 1.2.0.
#> ℹ Please use `num_check()` instead.
#> For 'count', 2 non-numbers identified: '14x' | '_23'
#> For 'num_col2', 1 non-numbers identified: 'a'
#> For 'third_count', 2 non-numbers identified: 'Y' | 'typo'
#> $count
#> [1] "14x" "_23"
#> 
#> $num_col2
#> [1] "a"
#> 
#> $third_count
#> [1] "Y"    "typo"
#> 
```
