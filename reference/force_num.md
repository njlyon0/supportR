# Force Coerce to Numeric

Coerces a vector into a numeric vector and automatically silences
`NAs introduced by coercion` warning. Useful for cases where non-numbers
are known to exist in vector and their coercion to NA is expected /
unremarkable. Essentially just a way of forcing this coercion more
succinctly than wrapping `as.numeric` in `suppressWarnings`.

## Usage

``` r
force_num(x = NULL)
```

## Arguments

- x:

  (non-numeric) vector containing elements to be coerced into class
  numeric

## Value

(numeric) vector of numeric values

## Examples

``` r
# Coerce a character vector to numeric without throwing a warning
supportR::force_num(x = c(2, "A", 4))
#> [1]  2 NA  4
```
