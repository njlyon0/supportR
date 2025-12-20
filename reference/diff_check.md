# Compare Difference Between Two Vectors

Reflexively compares two vectors and identifies (1) elements that are
found in the first but not the second (i.e., "lost" components) and (2)
elements that are found in the second but not the first (i.e., "gained"
components). This is particularly helpful when manipulating a dataframe
and comparing what columns are lost or gained between wrangling steps.
Alternately it can compare the contents of two columns to see how two
dataframes differ.

## Usage

``` r
diff_check(old = NULL, new = NULL, sort = TRUE, return = FALSE)
```

## Arguments

- old:

  (vector) starting / original object

- new:

  (vector) ending / modified object

- sort:

  (logical) whether to sort the difference between the two vectors

- return:

  (logical) whether to return the two vectors as a 2-element list

## Value

No return value (unless `return = TRUE`), called for side effects. If
`return = TRUE`, returns a two-element list

## Examples

``` r
# Make two vectors
vec1 <- c("x", "a", "b")
vec2 <- c("y", "z", "a")

# Compare them!
supportR::diff_check(old = vec1, new = vec2, return = FALSE)
#> Following element(s) found in old object but not new: 
#> [1] "b" "x"
#> Following element(s) found in new object but not old: 
#> [1] "y" "z"

# Return the difference for later use
diff_out <- supportR::diff_check(old = vec1, new = vec2, return = TRUE)
#> Following element(s) found in old object but not new: 
#> [1] "b" "x"
#> Following element(s) found in new object but not old: 
#> [1] "y" "z"
diff_out
#> $lost
#> [1] "b" "x"
#> 
#> $gained
#> [1] "y" "z"
#> 
```
