# List Objects in a GitHub Repository

Accepts a GitHub repository URL and identifies all files in the
specified folder. If no folder is specified, lists top-level repository
contents. Recursive listing of sub-folders is supported by an additional
argument. This function only works on repositories (public or private)
to which you have access.

## Usage

``` r
github_ls(repo = NULL, folder = NULL, recursive = TRUE, quiet = FALSE)
```

## Arguments

- repo:

  (character) full URL for a GitHub repository (including "github.com")

- folder:

  (NULL/character) either `NULL` or the name of the folder to list. If
  `NULL`, the top-level contents of the repository will be listed

- recursive:

  (logical) whether to recursively list contents (i.e., list contents of
  sub-folders identified within previously identified sub-folders)

- quiet:

  (logical) whether to print an informative message as the contents of
  each folder is being listed

## Value

(dataframe) three-column dataframe including (1) the names of the
contents, (2) the type of each content item (e.g., file/directory/etc.),
and (3) the full path from the starting folder to each item

## Examples

``` r
if (FALSE) { # \dontrun{
# List complete contents of the `supportR` package repository
supportR::github_ls(repo = "https://github.com/njlyon0/supportR", recursive = TRUE, quiet = FALSE)
} # }
```
