# Check Columns for Non-Numbers

Identifies any elements in the column(s) that would be changed to NA if
`as.numeric` is used on the column(s). This is useful for quickly
identifying only the "problem" entries of ostensibly numeric column(s)
that is/are read in as a character.

## Usage

``` r
num_check(data = NULL, col = NULL)
```

## Arguments

- data:

  (dataframe) object containing at least one column of supposed numbers

- col:

  (character or numeric) name(s) or column number(s) of the column(s)
  containing putative numbers in the data object

## Value

(list) malformed numbers from each supplied column in separate list
elements

## Examples

``` r
# Create dataframe with a numeric column where some entries would be coerced into NA
spp <- c("salmon", "bass", "halibut", "eel", "sardine")
ct <- c(1, "14x", "_23", 12, "")
ct2 <- c("a", "2", "4", "0", "0")
ct3 <- c(NA, "Y", "typo", "2", "x")
fish <- data.frame("species" = spp, "count" = ct, "num_col2" = ct2, "third_count" = ct3)

# Use `num_check()` to return only the entries that would be lost
supportR::num_check(data = fish, col = c("count", "num_col2", "third_count"))
#> For 'count', 2 non-numbers identified: '14x' | '_23'
#> For 'num_col2', 1 non-numbers identified: 'a'
#> For 'third_count', 3 non-numbers identified: 'Y' | 'typo' | 'x'
#> $count
#> [1] "14x" "_23"
#> 
#> $num_col2
#> [1] "a"
#> 
#> $third_count
#> [1] "Y"    "typo" "x"   
#> 
```
