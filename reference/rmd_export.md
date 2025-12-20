# Knit an R Markdown File and Export to Google Drive

This function allows you to knit a specified R Markdown file locally and
export it to the Google Drive folder for which you provided a link. NOTE
that if you have not used
[`googledrive::drive_auth`](https://googledrive.tidyverse.org/reference/drive_auth.html)
this will prompt you to authorize a Google account in a new browser tab.
If you do not check the box in that screen before continuing you will
not be able to use this function until you clear your browser cache and
re-authenticate. I recommend invoking `drive_auth` beforehand to reduce
the chances of this error

## Usage

``` r
rmd_export(
  rmd = NULL,
  out_path = getwd(),
  out_name = NULL,
  out_type = "html",
  drive_link
)
```

## Arguments

- rmd:

  (character) name and path to R markdown file to knit

- out_path:

  (character) path to the knit file's destination (defaults to path
  returned by [`getwd()`](https://rdrr.io/r/base/getwd.html))

- out_name:

  (character) desired name for knit file (with or without file suffix)

- out_type:

  (character) either "html" or "pdf" depending on what YAML entry you
  have in the `output: ` field of your R Markdown file

- drive_link:

  (character) full URL of drive folder to upload the knit document

## Value

No return value, called for side effect (to knit R Markdown file)

## Examples

``` r
if (FALSE) { # \dontrun{
# Authorize R to interact with GoogleDrive
googledrive::drive_auth()
## NOTE: See warning about possible misstep at this stage

# Use `rmd_export()` to knit and export an .Rmd file
supportR::rmd_export(rmd = "my_markdown.Rmd",  in_path = getwd(), out_path = getwd(),
                     out_name = "my_markdown", out_type = "html",
                     drive_link = "<Google Drive folder URL>")
} # }
```
