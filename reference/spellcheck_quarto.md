# Check the Spelling of All Quarto Files in a Given Directory

Runs
[`spelling::spell_check_files`](https://docs.ropensci.org/spelling//reference/spell_check_files.html)
on all Quarto (.qmd) files in folders that would be rendered when
rendering a Quarto project (i.e., folders that do not begin with an
underscore).

## Usage

``` r
spellcheck_quarto(path = getwd(), quiet = FALSE)
```

## Arguments

- path:

  (character) directory in which to identify all Quarto files are to be
  identified and spell-checked. Recursively identifies Quarto files in
  folders within the top-level folder. Unrendered folders are ignored.
  Defaults to current working directory

- quiet:

  (logical) whether to message the name of the current file being
  spell-checked as it is checked. Defaults to `FALSE`

## Value

(dataframe) table containing a column for the Quarto file, its path,
words flagged as typos by `spell_check_files`, and what line(s) of the
file that typo was found. One row per typo. If found on multiple lines
in a single file, concatenated with comma as separators.
