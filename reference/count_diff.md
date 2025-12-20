# Count Difference in Occurrences of Vector Elements

Counts the number of occurrences of each element in both provided
vectors and then calculates the difference in that count between the
first and second input vector. Counting of NAs in addition to non-NA
values is supported.

## Usage

``` r
count_diff(vec1, vec2, what = NULL)
```

## Arguments

- vec1:

  (vector) first vector containing elements to count

- vec2:

  (vector) second vector containing elements to count

- what:

  (vector) optional argument for what element(s) to count. If left
  `NULL`, defaults to all unique elements found in either vector

## Value

(dataframe) four-column dataframe with as many rows as there are unique
elements across both specified vectors or as the number of elements
passed to 'what'. First column is named "value" and includes the unique
elements of the vector, second and third columns are named "vec1_count"
and "vec2_count" respectively and include the number of occurrences of
each vector element in each vector. Final column is "diff" and the
difference in the count of each element between the first and second
input vectors

## Examples

``` r
# Define two vectors
x1 <- c(1, 1, NA, "a", 1, "a", NA, "x")
x2 <- c(1, "a", "x", "b")

# Count difference in number of NAs between the two vectors
supportR::count_diff(vec1 = x1, vec2 = x2, what = NA)
#>   value vec1_count vec2_count diff
#> 1  <NA>          2          0    2

# Count difference in all values between the two
supportR::count_diff(vec1 = x1, vec2 = x2)
#>   value vec1_count vec2_count diff
#> 1     1          3          1    2
#> 2  <NA>          2          0    2
#> 3     a          2          1    1
#> 4     x          1          1    0
#> 5     b          0          1   -1
```
