# List Objects in a Single Folder of a GitHub Repository

Accepts a GitHub repository URL and identifies all files in the
specified folder. If no folder is specified, lists top-level repository
contents. This function only works on repositories (public or private)
to which you have access.

## Usage

``` r
github_ls_single(repo = NULL, folder = NULL)
```

## Arguments

- repo:

  (character) full URL for a GitHub repository (including "github.com")

- folder:

  (NULL/character) either `NULL` or the name of the folder to list. If
  `NULL`, the top-level contents of the repository will be listed

## Value

(dataframe) two-column dataframe including (1) the names of the contents
and (2) the type of each content item (e.g., file/directory/etc.)

## Examples

``` r
if (FALSE) { # \dontrun{
# List contents of the top-level of the `supportR` package repository
supportR::github_ls_single(repo = "https://github.com/njlyon0/supportR")
} # }
```
