# supportR Version 1.5.0.900

This is the development version of `supportR`. Changes from preceding version are listed below

- No changes (yet!)

# supportR Version 1.5.0

Changes from preceding version are listed below

- New function: `count_diff`. Similar to `count` except that it accepts two input vectors and counts the difference for each specified element (or all elements) between the two
- Function fix: Fixed issue with `replace_non_ascii` where if `include_letters` was set to `FALSE` a warning was still generated for non-ASCII letters when they were part of a larger string (e.g., "\<non-ascii\>xyz", etc.)
- Vignette update: separated the single package vignette into separate, smaller files that give a tutorial for groups of functions with similar use-cases (e.g., quality control, data visualization, etc.)
- Namespaced all function examples--should allow users to run example code without loading the package explicitly (though they will need to have installed the package at least once before)

# supportR Version 1.4.0

Changes from preceding version are listed below

- New function: `replace_non_ascii`. Replaces non-ASCII characters with ASCII characters that are as visually similar as possible
- New function: `count`. Counts occurrences of each unique element in the provided vector
- New function: `ordination`. Generic function that creates either NMS or PCoA ordinations. Makes extensive use of the `...` argument to greatly increase level of control user can expect over internal base R graphing functions. Supersedes `nms_ord` and `pcoa_ord`.
- Superseded functions: `nms_ord` and `pcoa_ord` are now superseded because they are special cases of `ordination`
- New function behavior: `nms_ord` and `pcoa_ord` now support modifying axis label text size and axis tickmark text size
- Began the process of adding units tests for most functions in the package. Users may notice some small cases where more informative errors/warnings are returned but generally this shouldn't change function behavior in an appreciable way

# supportR Version 1.3.0

Changes from preceding version are listed below

- New function: `force_num`. Coerces a vector to numeric and automatically silences any warnings due to coercing values to NA
- New function: `safe_rename`. Renames columns in a given dataframe by matching 'bad' names with 'good' names
- New function: `tabularize_md`. Converts a markdown file into a table that retains the nested structure of any headings in the file

# supportR Version 1.2.0

Changes from preceding version are listed below

- New function: `name_vec`. Creates a named vector of specified contents and names
- `github_tree` now supports excluding no directories from the folder tree (this is the default behavior now)
- New function behavior: `num_check` now accepts multiple column names/numbers to its `col` argument
- New function behavior: `date_check` now accepts multiple column names/numbers to its `col` argument
- Deprecated function: `multi_num_check` is now deprecated (with a warning) because it is a special case of `num_check`
- Deprecated function: `multi_date_check` is now deprecated (with a warning) because it is a special case of `date_check`

# supportR Version 1.1.0

Changes from preceding version are listed below

- New function: `github_ls`. Lists contents of specified GitHub repository either recursively or only top-level/specified folder
- New function: `github_tree`. Creates a file tree diagram for a specified GitHub repository
- Refined and clarified the package vignette
- `pcoa_ord` and `nms_ord` now include arguments for changing point size (`pt_size`) and opacity (`pt_alpha`; i.e., transparency). Changes to point size are reflected in the legend but changes to opacity are not reflected in the legend points
- Fixed a typo in the message returned by `diff_check`
- Added example in documentation for `crop_tri`

# supportR Version 1.0.0

This is the first fully-functioning version of the package. It currently has no ERRORs, WARNINGs, or NOTEs from `devtools::check`
