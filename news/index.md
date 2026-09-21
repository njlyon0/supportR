# Changelog

## supportR Version 1.6.1.900

This is the development version. Changes from the preceding version will
be identified here as they are made.

## supportR Version 1.6.1

CRAN release: 2026-09-18

### New Features

- [`spellcheck_quarto()`](https://njlyon0.github.io/supportR/reference/spellcheck_quarto.md)
  runs
  [`spelling::spell_check_files()`](https://docs.ropensci.org/spelling//reference/spell_check_files.html)
  on all Quarto files (`.qmd`) that would be rendered (e.g., to make a
  website)

### Documentation / Testing

- Updates maintainer email.

## supportR Version 1.6.0

CRAN release: 2025-12-21

- [`count_diff()`](https://njlyon0.github.io/supportR/reference/count_diff.md)
  correctly handles counting of vector elements found in only one of the
  input vectors (i.e., should be 0 occurrences not `NA` occurrences).
- [`num_check()`](https://njlyon0.github.io/supportR/reference/num_check.md)
  no longer flags a 0-length, ‘empty’ element as a non-number.
- [`diff_check()`](https://njlyon0.github.io/supportR/reference/diff_check.md)
  coerces dates into characters before evaluating vector differences
  because [`is.vector()`](https://rdrr.io/r/base/vector.html) returns
  `FALSE` for date vectors which erroneously produces an error in this
  function.

## supportR Version 1.5.0

CRAN release: 2025-06-03

### New Features

- [`count_diff()`](https://njlyon0.github.io/supportR/reference/count_diff.md)
  accepts two input vectors and counts the difference for each specified
  element (or all elements) between the two.

### Bug Fixes

- [`replace_non_ascii()`](https://njlyon0.github.io/supportR/reference/replace_non_ascii.md)
  no longer returns inappropriate warning if `include_letters = FALSE`
  for non-ASCII letters when they were part of a larger string (e.g.,
  “\<non-ascii\>xyz”).

### Documentation / Testing

- Separates vignette into separate, smaller files that tutorialize
  thematic groups of functions with similar use-cases (e.g., quality
  control, data visualization).
- Namespaces all function examples.

## supportR Version 1.4.0

CRAN release: 2024-06-13

### New Features

- [`replace_non_ascii()`](https://njlyon0.github.io/supportR/reference/replace_non_ascii.md)
  replaces non-ASCII characters with ASCII characters that are as
  visually similar as possible.
- [`count()`](https://njlyon0.github.io/supportR/reference/count.md)
  counts occurrences of each unique element in the provided vector.
- [`ordination()`](https://njlyon0.github.io/supportR/reference/ordination.md)
  creates NMS and PCoA ordinations. Supersedes
  [`nms_ord()`](https://njlyon0.github.io/supportR/reference/nms_ord.md)
  and
  [`pcoa_ord()`](https://njlyon0.github.io/supportR/reference/pcoa_ord.md).
- [`nms_ord()`](https://njlyon0.github.io/supportR/reference/nms_ord.md)
  and
  [`pcoa_ord()`](https://njlyon0.github.io/supportR/reference/pcoa_ord.md)
  support modifying axis label text size and axis tickmark text size.

### Documentation / Testing

- Begins adding unit tests for most functions in the package.

## supportR Version 1.3.0

CRAN release: 2024-04-12

- [`force_num()`](https://njlyon0.github.io/supportR/reference/force_num.md)
  coerces a vector to numeric and automatically silences any warnings
  (e.g., due to coercing values to `NA`).
- [`safe_rename()`](https://njlyon0.github.io/supportR/reference/safe_rename.md)
  renames columns in a given dataframe by matching ‘bad’ names with
  ‘good’ names.
- [`tabularize_md()`](https://njlyon0.github.io/supportR/reference/tabularize_md.md)
  converts a markdown file into a table that retains the nested
  structure of any headings in the file.

## supportR Version 1.2.0

CRAN release: 2023-08-22

### New Features

- [`name_vec()`](https://njlyon0.github.io/supportR/reference/name_vec.md)
  creates a named vector of specified contents and names.
- [`github_tree()`](https://njlyon0.github.io/supportR/reference/github_tree.md)
  supports excluding no directories from the folder tree (this is the
  default behavior now).
- [`num_check()`](https://njlyon0.github.io/supportR/reference/num_check.md)
  and
  [`date_check()`](https://njlyon0.github.io/supportR/reference/date_check.md)
  accept multiple column names/numbers to `col` parameter.

### Breaking Changes

- [`multi_num_check()`](https://njlyon0.github.io/supportR/reference/multi_num_check.md)
  and
  [`multi_date_check()`](https://njlyon0.github.io/supportR/reference/multi_date_check.md)
  are now deprecated because they are special case of
  [`num_check()`](https://njlyon0.github.io/supportR/reference/num_check.md)
  and
  [`date_check()`](https://njlyon0.github.io/supportR/reference/date_check.md)
  respectively.

## supportR Version 1.1.0

CRAN release: 2023-07-08

### New Features

- [`github_ls()`](https://njlyon0.github.io/supportR/reference/github_ls.md)
  lists contents of specified GitHub repository either recursively or
  only top-level/specified folder.
- [`github_tree()`](https://njlyon0.github.io/supportR/reference/github_tree.md)
  creates a file tree diagram for a specified GitHub repository.
- [`pcoa_ord()`](https://njlyon0.github.io/supportR/reference/pcoa_ord.md)
  and
  [`nms_ord()`](https://njlyon0.github.io/supportR/reference/nms_ord.md)
  include new parameters for changing point size (`pt_size`) and opacity
  (`pt_alpha`).

### Bug Fixes

- Resolves typo in
  [`diff_check()`](https://njlyon0.github.io/supportR/reference/diff_check.md)
  message.

### Documentation / Testing

- Refines and clarifies the package vignette.
- Adds example for
  [`crop_tri()`](https://njlyon0.github.io/supportR/reference/crop_tri.md).

## supportR Version 1.0.0

CRAN release: 2023-02-09

First fully-functioning version of the package.
