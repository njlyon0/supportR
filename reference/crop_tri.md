# Crop a Triangle from Data Object

Accepts a symmetric data object and replaces the chosen triangle with
NAs. Also allows user to choose whether to keep or drop the diagonal of
the data object

## Usage

``` r
crop_tri(data = NULL, drop_tri = "upper", drop_diag = FALSE)
```

## Arguments

- data:

  (dataframe, dataframe-like, or matrix) symmetric data object to remove
  one of the triangles from

- drop_tri:

  (character) which triangle to replace with NAs, either "upper" or
  "lower"

- drop_diag:

  (logical) whether to drop the diagonal of the data object (defaults to
  FALSE)

## Value

(dataframe or dataframe-like) data object with desired triangle removed
and either with or without the diagonal

## Examples

``` r
# Define a simple matrix wtih symmetric dimensions
mat <- matrix(data = c(1:2, 2:1), nrow = 2, ncol = 2)

# Crop off it's lower triangle
supportR::crop_tri(data = mat, drop_tri = "lower", drop_diag = FALSE)
#>      [,1] [,2]
#> [1,]    1    2
#> [2,]   NA    1
```
