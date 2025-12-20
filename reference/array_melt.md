# Melt an Array into a Dataframe

Melts an array of dimensions x, y, and z into a dataframe containing
columns `x`, `y`, `z`, and `value` where `value` is whatever was stored
in the array at those coordinates.

## Usage

``` r
array_melt(array = NULL)
```

## Arguments

- array:

  (array) array object to melt into a dataframe

## Value

(dataframe) object containing the "flattened" array in dataframe format

## Examples

``` r
# First we need to create an array to melt
## Make data to fill the array
vec1 <- c(5, 9, 3)
vec2 <- c(10:15)

## Create dimension names (x = col, y = row, z = which matrix)
x_vals <- c("Col_1","Col_2","Col_3")
y_vals <- c("Row_1","Row_2","Row_3")
z_vals <- c("Mat_1","Mat_2")

## Make an array from these components
g <- array(data = c(vec1, vec2), dim = c(3, 3, 2),
           dimnames = list(x_vals, y_vals, z_vals))

## "Melt" the array into a dataframe
supportR::array_melt(array = g)
#>        z     y     x value
#> 1  Mat_1 Col_1 Row_1     5
#> 2  Mat_1 Col_1 Row_2    10
#> 3  Mat_1 Col_1 Row_3    13
#> 4  Mat_1 Col_2 Row_1     9
#> 5  Mat_1 Col_2 Row_2    11
#> 6  Mat_1 Col_2 Row_3    14
#> 7  Mat_1 Col_3 Row_1     3
#> 8  Mat_1 Col_3 Row_2    12
#> 9  Mat_1 Col_3 Row_3    15
#> 10 Mat_2 Col_1 Row_1     5
#> 11 Mat_2 Col_1 Row_2    10
#> 12 Mat_2 Col_1 Row_3    13
#> 13 Mat_2 Col_2 Row_1     9
#> 14 Mat_2 Col_2 Row_2    11
#> 15 Mat_2 Col_2 Row_3    14
#> 16 Mat_2 Col_3 Row_1     3
#> 17 Mat_2 Col_3 Row_2    12
#> 18 Mat_2 Col_3 Row_3    15
```
