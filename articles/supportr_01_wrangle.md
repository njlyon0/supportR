# Data Wrangling

## Overview

The `supportR` package is an amalgam of distinct functions I’ve written
to accomplish small data wrangling, quality control, or visualization
tasks. These functions tend to be short and narrowly-defined. An
additional consequence of the motivation for creating them is that they
tend to not be inter-related or united by a common theme. To help
account for that, I’ve divided this vignette into groups of functions
that do have similar purposes.

If any of these functions don’t work for you, please [open an
issue](https://github.com/njlyon0/supportR/issues) so that I can repair
the issue as soon as possible.

``` r
# install.packages("supportR")
library(supportR)
```

### Example Data

In order to demonstrate some of the data wrangling functions of
`supportR`, we’ll use some some example data from Dr. [Allison
Horst](https://allisonhorst.com/allison-horst)’s [`palmerpenguins` R
package](https://github.com/allisonhorst/palmerpenguins).

``` r
# Check the structure of the penguins dataset
str(penguins)
#> 'data.frame':    344 obs. of  8 variables:
#>  $ species          : Factor w/ 3 levels "Adelie","Chinstrap",..: 1 1 1 1 1 1 1 1 1 1 ...
#>  $ island           : Factor w/ 3 levels "Biscoe","Dream",..: 3 3 3 3 3 3 3 3 3 3 ...
#>  $ bill_length_mm   : num  39.1 39.5 40.3 NA 36.7 39.3 38.9 39.2 34.1 42 ...
#>  $ bill_depth_mm    : num  18.7 17.4 18 NA 19.3 20.6 17.8 19.6 18.1 20.2 ...
#>  $ flipper_length_mm: int  181 186 195 NA 193 190 181 195 193 190 ...
#>  $ body_mass_g      : int  3750 3800 3250 NA 3450 3650 3625 4675 3475 4250 ...
#>  $ sex              : Factor w/ 2 levels "female","male": 2 1 1 NA 1 2 1 2 NA NA ...
#>  $ year             : int  2007 2007 2007 2007 2007 2007 2007 2007 2007 2007 ...
```

### Summarize Within Groups

With that data loaded, we can use the `summary_table` function to
quickly get group-wise summaries and retrieve generally useful summary
statistics.

The `groups` argument supports a vector of all of the column names to
group by while `response` must be a single numeric column. The `drop_na`
argument allows group combinations that result in an NA to be
automatically dropped (i.e., if a penguin didn’t have an island listed
that would be dropped). The mean, standard deviation (SD), sample size,
and standard error (SE) are all returned to facilitate easy figure
creation. There is also a `round_digits` argument that lets you specify
how many digits you’d like to retain for the mean, SD, and SE.

``` r
# Summarize the data
supportR::summary_table(data = penguins, groups = c("species", "island"),
                        response = "bill_length_mm", drop_na = TRUE)
#>     species    island  mean std_dev sample_size std_error
#> 1    Adelie    Biscoe 38.98    2.48          44      0.37
#> 2    Adelie     Dream 38.50    2.47          56      0.33
#> 3    Adelie Torgersen 38.95    3.03          52      0.42
#> 4 Chinstrap     Dream 48.83    3.34          68      0.41
#> 5    Gentoo    Biscoe 47.50    3.08         124      0.28
```

### Safely Rename Columns

The `safe_rename` function allows–perhaps predictably–“safe” renaming of
column names in a given data object. The ‘bad’ column names and
corresponding ‘good’ names must be specified. The order of entries in
the two vectors must match (i.e., the first bad name will be replaced
with the first good name), but that order need not match the order in
which they occur in the data!

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

### Handle Special Characters

When loading text data into R you may have encountered pernicious
‘special’ characters that can affect the meaning of character data.
These characters are often non-ASCII (see
[here](https://en.wikipedia.org/wiki/ASCII) for more context on “ASCII”
characters) and `supportR` offers the `replace_non_ascii` function to
find and replace these characters with visually similar equivalents in a
given vector.

Note that letters with accents above or below them (e.g., umlaut, accent
circumflex, etc.) are technically non-ASCII characters. Because they are
often a part of proper nouns rather than being categorically incorrect
I’ve split off whether they should be replaced into an `include_letters`
argument that defaults to `FALSE`.

Also, non-ASCII characters trigger errors in the R package submission
process so the example below uses “u-escape” codes for ASCII characters
to still demonstrate the function without causing errors when I submit
version updates of `supportR` to CRAN.

``` r
# Make a vector of non-ASCII characters
(non_ascii <- c("\u201C", "\u00AC", "\u00D7"))
#> [1] "“" "¬" "×"
```

``` r
# Replace them with ASCII equivalents
supportR::replace_non_ascii(x = non_ascii, include_letters = F)
#> [1] "\"" "-"  "x"
```

### Crop Triangles

`crop_tri` allows dropping one “triangle” of a symmetric dataframe /
matrix. It also includes a `drop_diag` argument that accepts a logical
for whether to drop the diagonal of the data object. This is primarily
useful (I find) in allowing piping through this function as opposed to
using the base R notation for removing a triangle of a symmetric data
object.

``` r
# Define a simple matrix wtih symmetric dimensions
mat <- matrix(data = c(1:2, 2:1), nrow = 2, ncol = 2)

# Crop off it's lower triangle
supportR::crop_tri(data = mat, drop_tri = "lower", drop_diag = FALSE)
#>      [,1] [,2]
#> [1,]    1    2
#> [2,]   NA    1

# Drop the diagonal as well
supportR::crop_tri(data = mat, drop_tri = "lower", drop_diag = TRUE)
#>      [,1] [,2]
#> [1,]   NA    2
#> [2,]   NA   NA
```

### “Melt” Arrays into Dataframes

`array_melt` allows users to ‘melt’ an array of dimensions X, Y, and Z
into a dataframe containing columns “x”, “y”, “z”, and “value” where
“value” is whatever was stored at those coordinates in the array.

``` r
# Make data to fill the array
vec1 <- c(5, 9, 3)
vec2 <- c(10:15)

# Create dimension names (x = col, y = row, z = which matrix)
x_vals <- c("Col_1","Col_2","Col_3")
y_vals <- c("Row_1","Row_2","Row_3")
z_vals <- c("Mat_1","Mat_2")

# Make an array from these components
g <- array(data = c(vec1, vec2), dim = c(3, 3, 2),
           dimnames = list(x_vals, y_vals, z_vals))

# "Melt" the array into a dataframe
melted <- supportR::array_melt(array = g)

# Look at that top of that
head(melted)
#>       z     y     x value
#> 1 Mat_1 Col_1 Row_1     5
#> 2 Mat_1 Col_1 Row_2    10
#> 3 Mat_1 Col_1 Row_3    13
#> 4 Mat_1 Col_2 Row_1     9
#> 5 Mat_1 Col_2 Row_2    11
#> 6 Mat_1 Col_2 Row_3    14
```
