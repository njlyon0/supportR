# supportR Version 1.6.1.900

This is the development version. Changes from the preceding version will be identified here as they are made.

# supportR Version 1.6.1

## New Features

- `spellcheck_quarto()` runs `spelling::spell_check_files()` on all Quarto files (`.qmd`) that would be rendered (e.g., to make a website)

## Documentation / Testing

- Updates maintainer email.

# supportR Version 1.6.0

- `count_diff()` correctly handles counting of vector elements found in only one of the input vectors (i.e., should be 0 occurrences not `NA` occurrences).
- `num_check()` no longer flags a 0-length, 'empty' element as a non-number.
- `diff_check()` coerces dates into characters before evaluating vector differences because `is.vector()` returns `FALSE` for date vectors which erroneously produces an error in this function.

# supportR Version 1.5.0

## New Features

- `count_diff()` accepts two input vectors and counts the difference for each specified element (or all elements) between the two.

## Bug Fixes

- `replace_non_ascii()` no longer returns inappropriate warning if `include_letters = FALSE` for non-ASCII letters when they were part of a larger string (e.g., "\<non-ascii\>xyz").

## Documentation / Testing

- Separates vignette into separate, smaller files that tutorialize thematic groups of functions with similar use-cases (e.g., quality control, data visualization).
- Namespaces all function examples.

# supportR Version 1.4.0

## New Features

- `replace_non_ascii()` replaces non-ASCII characters with ASCII characters that are as visually similar as possible.
- `count()` counts occurrences of each unique element in the provided vector.
- `ordination()` creates NMS and PCoA ordinations. Supersedes `nms_ord()` and `pcoa_ord()`.
- `nms_ord()` and `pcoa_ord()` support modifying axis label text size and axis tickmark text size.

## Documentation / Testing

- Begins adding unit tests for most functions in the package.

# supportR Version 1.3.0

- `force_num()` coerces a vector to numeric and automatically silences any warnings (e.g., due to coercing values to `NA`).
- `safe_rename()` renames columns in a given dataframe by matching 'bad' names with 'good' names.
- `tabularize_md()` converts a markdown file into a table that retains the nested structure of any headings in the file.

# supportR Version 1.2.0

## New Features

- `name_vec()` creates a named vector of specified contents and names.
- `github_tree()` supports excluding no directories from the folder tree (this is the default behavior now).
- `num_check()` and `date_check()` accept multiple column names/numbers to `col` parameter.

## Breaking Changes

- `multi_num_check()` and `multi_date_check()` are now deprecated because they are special case of `num_check()` and `date_check()` respectively.

# supportR Version 1.1.0

## New Features

- `github_ls()` lists contents of specified GitHub repository either recursively or only top-level/specified folder.
- `github_tree()` creates a file tree diagram for a specified GitHub repository.
- `pcoa_ord()` and `nms_ord()` include new parameters for changing point size (`pt_size`) and opacity (`pt_alpha`).

## Bug Fixes

- Resolves typo in `diff_check()` message.

## Documentation / Testing

- Refines and clarifies the package vignette.
- Adds example for `crop_tri()`.

# supportR Version 1.0.0

First fully-functioning version of the package.
