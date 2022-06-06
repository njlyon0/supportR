#' @title Knit an R Markdown File and Export to Google Drive
#'
#' @description This function allows you to knit a specified R Markdown file locally and export it to the Google Drive folder for which you provided a link. NOTE that if you have not used `googledrive::drive_auth()` this will prompt you to authorize a Google account in a new browser tab. If you do not check the box in that screen before continuing you will not be able to use this function until you clear your browser cache and re-authenticate. I recommend invoking `drive_auth()` beforehand to reduce the chances of this error
#'
#' @param in_path path to the .Rmd file (defaults to `getwd()`)
#' @param in_name name of .Rmd file (with or without ".Rmd" at end)
#' @param out_path path to the knit file's destination (defaults to `getwd()`)
#' @param out_name desired name for knit file (with or without file suffix)
#' @param out_type either "html" or "pdf" depending on what YAML entry you have in the `output: ` field of your .Rmd
#' @param drive_link full URL of drive folder to upload the knit document
#'
#' @export
#'
#' @examples
#' # Authorize R to interact with GoogleDrive
#' # googledrive::drive_auth()
#' ## NOTE: See above warning about possible misstep at this stage
#'
#' # Use `rmd_export()` to knit and export an .Rmd file
#' # rmd_export(in_name = "my_markdown.Rmd",
#' # in_path = file.path("Folder in my WD with the .Rmd named in `in_name`"),
#' # out_path = file.path("Folder in my WD to save the knit file to"),
#' # out_name = "desired name for output",
#' # out_type = "html",
#' # drive_link = "https://...Google Drive link...")
#'
rmd_export <- function(in_path = getwd(), in_name, out_path = getwd(), out_name, out_type = 'html', drive_link) {

  # 0 - Reject inappropriate out_type specification
  if(!out_type %in% c("html", "pdf") | base::length(base::nchar(out_type)) == 0){
    message("Inappropriate `out_type` specification. Please supply either 'html' or 'pdf'")
  } else {

    # 1 - Render Rmarkdown Locally
    ## If the input name does not include .Rmd, add it
    if(stringr::str_detect(in_name, pattern = ".Rmd") != "TRUE"){ in_name <- paste0(in_name, ".Rmd") }

    ## Render provided input
    rmarkdown::render(input = in_name, output_dir = out_path, output_file = out_name)
    # 2 - dentify Drive ID from provided link
    ## Remove sharing part of link if it was provided
    link_simp <- gsub("\\?usp\\=sharing", "", drive_link)
    ## Return the link as an ID recognized by `googledrive`
    id <- googledrive::as_id(x = link_simp)
    # 3 - Check output name for file suffix
    if(stringr::str_detect(out_name, pattern = out_type) != "TRUE"){
      out_name <- paste(out_name, out_type, sep = ".") }
    # 4 - Upload knit file to desired location
    googledrive::drive_upload(media = file.path(out_path, out_name),
                              path = id, overwrite = TRUE) }
}

