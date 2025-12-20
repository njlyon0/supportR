# Create File Tree of a GitHub Repository

Recursively identifies all files in a GitHub repository and creates a
file tree using the `data.tree` package to create a simple,
human-readable visualization of the folder hierarchy. Folders can be
specified for exclusion in which case the number of elements within them
is listed but not the names of those objects. This function only works
on repositories (public or private) to which you have access.

## Usage

``` r
github_tree(repo = NULL, exclude = NULL, quiet = FALSE)
```

## Arguments

- repo:

  (character) full URL for a github repository (including "github.com")

- exclude:

  (character) vector of folder names to exclude from the file tree. If
  `NULL` (the default) no folders are excluded

- quiet:

  (logical) whether to print an informative message as the contents of
  each folder is being listed and as the tree is prepared from that
  information

## Value

(node / R6) `data.tree` package object class

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a file tree for the `supportR` package GitHub repository
supportR::github_tree(repo = "github.com/njlyon0/supportR", exclude = c("man", "docs", ".github"))
} # }
```
