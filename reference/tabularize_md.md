# Make a Markdown File into a Table

Accepts one markdown file (i.e., "md" file extension) and returns its
content as a table. Nested heading structure in markdown file–as defined
by hashtags / pounds signs (#)–is identified and preserved as columns in
the resulting tabular format. Each line of non-heading content in the
file is preserved in the right-most column of one row of the table.

## Usage

``` r
tabularize_md(file = NULL)
```

## Arguments

- file:

  (character/url connection) name and file path of markdown file to
  transform into a table or a connection object to a URL of a markdown
  file (see [`?url`](https://rdrr.io/r/base/connections.html) for more
  details)

## Value

(dataframe) table with one additional column than there are heading
levels in the document (e.g., if first and second level headings are in
the document, the resulting table will have three columns) and one row
per line of non-heading content in the markdown file.

## Examples

``` r
if (FALSE) { # \dontrun{
# Identify URL to the NEWS.md file in `supportR` GitHub repo
md_cxn <- url("https://raw.githubusercontent.com/njlyon0/supportR/main/NEWS.md")

# Transform it into a table
md_df <- supportR::tabularize_md(file = md_cxn)

# Close connection (just good housekeeping to do so)
close(md_cxn)

# Check out the table format
str(md_df)
} # }
```
