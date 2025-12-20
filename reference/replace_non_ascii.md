# Replace Non-ASCII Characters with Comparable ASCII Characters

Finds all non-ASCII (American Standard Code for Information Interchange)
characters in a character vector and replaces them with ASCII characters
that are as visually similar as possible. For example, various special
dash types (e.g., em dash, en dash, etc.) are replaced with a hyphen.
The function will return a warning if it finds any non-ASCII characters
for which it does not have a hard-coded replacement. Please open a
[GitHub Issue](https://github.com/njlyon0/supportR/issues) if you
encounter this warning and have a suggestion for what the replacement
character should be for that particular character.

## Usage

``` r
replace_non_ascii(x = NULL, include_letters = FALSE)
```

## Arguments

- x:

  (character) vector in which to replace non-ASCII characters

- include_letters:

  (logical) whether to include letters with accents (e.g., u with an
  umlaut, etc.). Defaults to `FALSE`

## Value

(character) vector where all non-ASCII characters have been replaced by
ASCII equivalents

## Examples

``` r
# Make a vector of the hexadecimal codes for several non-ASCII characters
## This function accepts the characters themselves but CRAN checks do not
non_ascii <- c("\u201C", "\u00AC", "\u00D7")

# Invoke function
(ascii <- supportR::replace_non_ascii(x = non_ascii))
#> [1] "\"" "-"  "x" 
```
