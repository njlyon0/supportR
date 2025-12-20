# Count Occurrences of Unique Vector Elements

Counts the number of occurrences of each element in the provided vector.
Counting of NAs in addition to non-NA values is supported.

## Usage

``` r
count(vec = NULL)
```

## Arguments

- vec:

  (vector) vector containing elements to count

## Value

(dataframe) two-column dataframe with as many rows as there are unique
elements in the provided vector. First column is named "value" and
includes the unique elements of the vector, second column is named
"count" and includes the number of occurrences of each vector element.

## Examples

``` r
# Count instances of vector elements
supportR::count(vec = c(1, 1, NA, "a", 1, "a", NA, "x"))
#>   value count
#> 1     1     3
#> 2  <NA>     2
#> 3     a     2
#> 4     x     1
```
