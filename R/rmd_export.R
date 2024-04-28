#' @title Knit an R Markdown File and Export to Google Drive
#'
#' @description This function allows you to knit a specified R Markdown file locally and export it to the Google Drive folder for which you provided a link. NOTE that if you have not used `googledrive::drive_auth` this will prompt you to authorize a Google account in a new browser tab. If you do not check the box in that screen before continuing you will not be able to use this function until you clear your browser cache and re-authenticate. I recommend invoking `drive_auth` beforehand to reduce the chances of this error
#'
#' @param rmd (character) name and path to R markdown file to knit
#' @param out_path (character) path to the knit file's destination (defaults to path returned by `getwd()`)
#' @param out_name (character) desired name for knit file (with or without file suffix)
#' @param out_type (character) either "html" or "pdf" depending on what YAML entry you have in the `output: ` field of your R Markdown file
#' @param drive_link (character) full URL of drive folder to upload the knit document
#' 
#' @return No return value, called to knit R Markdown file
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Authorize R to interact with GoogleDrive
#' googledrive::drive_auth()
#' ## NOTE: See warning about possible misstep at this stage
#'
#' # Use `rmd_export()` to knit and export an .Rmd file
#' rmd_export(rmd = "my_markdown.Rmd",  in_path = getwd(), out_path = getwd(),
#'            out_name = "my_markdown", out_type = "html",
#'            drive_link = "<Google Drive folder URL>")
#' }
#'
rmd_export <- function(rmd = NULL, out_path = getwd(), out_name = NULL, out_type = 'html', drive_link) {

  # Error out for unspecified R markdown file to knit
  if(base::is.null(rmd))
    stop("Name of .Rmd file to knit must be provided to 'rmd'")

  # Error out for unspecified export name
  if(base::is.null(out_name))
    stop("Name to export knit file locally must be provided to 'out_name'")

  # Error out if any argument is not a character
  if(!base::is.character(rmd) |
     !base::is.character(out_path) | !base::is.character(out_name) |
     !base::is.character(out_type) | !base::is.character(drive_link))
    stop("All arguments must be supplied as characters")

  # Error out for invalid export types
  if(!out_type %in% c("html", "pdf"))
    stop("Invalid 'out_type' specification. Please supply either 'html' or 'pdf'")

    # If the input name does not include .Rmd, add it
    if(stringr::str_detect(rmd, pattern = ".Rmd") != "TRUE"){ 
      rmd <- base::paste0(rmd, ".Rmd") }

    # Render provided input
    rmarkdown::render(input = rmd, output_dir = out_path, output_file = out_name)

    # Remove sharing part of link if it was provided
    link_simp <- gsub("\\?usp\\=sharing", "", drive_link)

    # Return the link as an ID recognized by `googledrive`
    id <- googledrive::as_id(x = link_simp)

    # Check output name for file suffix
    if(stringr::str_detect(out_name, pattern = out_type) != "TRUE"){
      out_name <- base::paste(out_name, out_type, sep = ".") }

    # Upload knit file to desired location
    googledrive::drive_upload(media = file.path(out_path, out_name),
                              path = id, overwrite = TRUE) }

