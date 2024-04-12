#' @title Make a Markdown File into a Table
#' 
#' @description Accepts one markdown file (i.e., "md" file extension) and returns its content as a table. Nested heading structure in markdown file--as defined by hashtags / pounds signs (#)--is identified and preserved as columns in the resulting tabular format. Each line of non-heading content in the file is preserved in the right-most column of one row of the table.
#'
#' @param file (character/url connection) name and file path of markdown file to transform into a table or a connection object to a URL of a markdown file (see `?base::url` for more details)
#' 
#' @return (dataframe) table with one additional column than there are heading levels in the document (e.g., if first and second level headings are in the document, the resulting table will have three columns) and one row per line of non-heading content in the markdown file.
#' 
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
#' @export
#' 
#' @examples
#' \dontrun{
#' # Identify URL to the NEWS.md file in `supportR` GitHub repo
#' md_cxn <- url("https://raw.githubusercontent.com/njlyon0/supportR/main/NEWS.md")
#' 
#' # Transform it into a table
#' md_df <- tabularize_md(file = md_cxn)
#' 
#' # Close connection (just good housekeeping to do so)
#' close(md_cxn)
#' 
#' # Check out the table format
#' str(md_df)
#' }
#' 
tabularize_md <- function(file = NULL){
  # Handle no visible bindings note
  . <- info <- level <- text <- type <- NULL
  
  # Error out if file isn't specified
  if(is.null(file) == TRUE)
    stop("`file` must be specified")
  
  # Error out if multiple files are provided
  if(length(file) != 1)
    stop("Only one markdown file can be tabularized at a time")
  
  # Handle URL/connection possibility
  if(methods::is(object = file, class2 = "url") == TRUE &
     methods::is(object = file, class2 = "connection") == TRUE){
    
    # Handle non-URL inputs
  } else {
    # If not URL/connection, file needs to be provided as a character
    if(is.character(file) != TRUE)
      stop("`file` must be specified as a character")
    
    # Error out for non-markdown file types
    if(tolower(x = tools::file_ext(x = file)) %in% c("md") != TRUE)
      stop("`file` must be a markdown file (with the 'md' file extension)")
  }
  
  # Read in specified markdown file and
  md_v0 <- base::readLines(con = file)
  
  # Remove empty entries
  ## Empty entries in this vector are blank lines in markdown file
  md_v1 <- base::setdiff(x = md_v0, y = "")

  # Make into a simple dataframe
  md_v2 <- data.frame("text" = md_v1)
  
  # Do preparatory wrangling
  md_v3 <- md_v2 %>% 
    # Count number of hashtags in each row
    dplyr::mutate(level = stringr::str_count(string = text, pattern = "#"),
                  .before = dplyr::everything()) %>% 
    # Remove hashtags from text
    dplyr::mutate(text = gsub(pattern = "#", replacement = "", x = text)) %>% 
    # Remove leading/trailing white space
    dplyr::mutate(text = trimws(x = text)) %>% 
    # Coerce 0s to an artificially high number
    dplyr::mutate(level = ifelse(test = (level == 0), yes = 999, no = level)) %>% 
    # Separate headings versus non-heading content
    dplyr::mutate(type = ifelse(test = (level < 999), yes = "heading", no = "content"),
                  .before = text) %>% 
    # Combine level and type
    dplyr::mutate(info = ifelse(test = (type == "heading"),
                                yes = paste0(type, "_", level), no = type),
                  .before = dplyr::everything()) %>% 
    # Remove superseded columns
    dplyr::select(-type, -level)
  
  # Identify all heading types found in the provided markdown file
  found_heads <- base::setdiff(x = unique(md_v3$info), y = "content")
  
  # Duplicate the data to avoid mistakes
  md_v4 <- md_v3
  
  # Attempt a for-loop variant of identifying header nesting structure
  for(head in found_heads){
    
    # Replace head with level (for use as a column name)
    lvl <- gsub(pattern = "heading", replacement = "level", x = head)
    
    # Actually do header structure identification
    md_v4 %<>%
      # Pull this level of heading into its own column with only its text or nothing
      dplyr::mutate(lvl = ifelse(test = (info == head), yes = text, no = NA)) %>% 
      # Fill down
      tidyr::fill(lvl, .direction = "down") %>% 
      # Rename this new column more specifically
      safe_rename(data = ., bad_names = "lvl", good_names = eval(lvl))
    
  } # Close loop
  
  # Final parsing
  md_v5 <- md_v4 %>% 
    # Move text column after everything
    dplyr::relocate(text, .after = dplyr::everything()) %>% 
    # Filter out any rows where the 'info' is anything other than content
    ## All other info is now duplicated into level-specific columns
    dplyr::filter(info == "content") %>% 
    # Ditch 'info' column
    dplyr::select(-info)
  
  # Return this 'tabularized' markdown file
  return(md_v5) }
