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
