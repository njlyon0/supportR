# Create Named Vector

Create a named vector in a single line without either manually defining
names at the outset (e.g., `c("name_1" = 1, "name_2" = 2, ...`) or
spending a second line to assign names to an existing vector (e.g.,
`names(vec) <- c("name_1", "name_2", ...)`). Useful in cases where you
need a named vector within a pipe and don't want to break into two pipes
just to define a named vector (see
[`tidyr::separate_wider_position`](https://tidyr.tidyverse.org/reference/separate_wider_delim.html))

## Usage

``` r
name_vec(content = NULL, name = NULL)
```

## Arguments

- content:

  (vector) content of vector

- name:

  (vector) names to assign to vector (must be in same order)

## Value

(named vector) vector with contents from the `content` argument and
names from the `name` argument

## Examples

``` r
# Create a named vector
supportR::name_vec(content = 1:10, name = paste0("text_", 1:10))
#>  text_1  text_2  text_3  text_4  text_5  text_6  text_7  text_8  text_9 text_10 
#>       1       2       3       4       5       6       7       8       9      10 
```
