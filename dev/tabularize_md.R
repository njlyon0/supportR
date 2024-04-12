## --------------------------------------------- ##
        # Tabularize Markdown Exploration
## --------------------------------------------- ##
# Script author(s): Nick Lyon

# PURPOSE:
## Ingest a specified markdown file and turn it into a dataframe
## Likely with columns for different levels of header
## Nested such that it is clear which set of headings a given set of contents is nested beneath

## --------------------------- ##
       # Housekeeping ----
## --------------------------- ##
# Load desired libraries
# install.packages("librarian")
librarian::shelf(tidyverse, devtools)
load_all()

# Clear environment
rm(list = ls())

## --------------------------- ##
        # Exploration ----
## --------------------------- ##

# Read the lines of the test markdown file
(text_v1 <- base::readLines(con = file.path("dev", "test-markdown.md")))

# Remove all empty entries
(text_v2 <- generics::setdiff(x = text_v1, y = ""))

# Make into a dataframe
(text_v3 <- data.frame("text" = text_v2))

# Identify number of hashtags (i.e., heading level)
text_v4 <- text_v3 %>% 
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

# Check that out
text_v4

# Identify just level 1s
text_v5a <- text_v4 %>% 
  dplyr::mutate(level_1 = ifelse(test = (info == "heading_1"),
                                 yes = text, no = NA)) %>% 
  # Fill downward with whatever the level one heading text is
  tidyr::fill(level_1, .direction = "down")

# Examine
text_v5a

# Identify all heading types found in the provided markdown file
(found_heads <- generics::setdiff(x = unique(text_v4$info), y = "content"))

# Duplicate the data to avoid mistakes
text_v5b <- text_v4

# Attempt a for-loop variant of identifying header nesting structure
for(head in found_heads){
  
  # Replace head with level (for use as a column name)
  lvl <- gsub(pattern = "heading", replacement = "level", x = head)
  
  # Actually do header structure identification
  text_v5b  %<>%
    # Pull this level of heading into its own column with only its text or nothing
    dplyr::mutate(lvl = ifelse(test = (info == head), yes = text, no = NA)) %>% 
    # Fill down
    tidyr::fill(lvl, .direction = "down") %>% 
    # Rename this new column more specifically
    safe_rename(data = ., bad_names = "lvl", good_names = eval(lvl))
  
  # Finishing message
  message("Finished identifying ", head, " structure")
  
} # Close loop

# Check out the result
text_v5b

# Final parsing
text_v6 <- text_v5b %>% 
  # Move text column after everything
  dplyr::relocate(text, .after = dplyr::everything()) %>% 
  # Filter out any rows where the 'info' is anything other than content
  ## All other info is now duplicated into level-specific columns
  dplyr::filter(info == "content") %>% 
  # Ditch 'info' column
  dplyr::select(-info)

# Final check
text_v6

## --------------------------- ##
# Function Writing ----
## --------------------------- ##

# Clear environment
rm(list = ls())

# Define function
tabularize_md <- function(file = NULL){
  
  # Error out if file isn't specified
  if(is.null(file) == TRUE)
    stop("`file` must be specified")
  
  # Error out for non-character entry
  if(is.character(file) != TRUE)
    stop("`file` must be specified as a character")
  
  # Error out if multiple files are provided
  if(length(file) != 1)
    stop("Only one markdown file can be tabularized at a time")
  
  # Error out for non-markdown
  if(tolower(x = tools::file_ext(x = file)) %in% c("md", "qmd", "rmd") != TRUE)
    stop("`file` must be a markdown file (with the 'md' file extension)")
  
  # Read in specified markdown file and
  md_v0 <- base::readLines(con = file)
  
  # Remove empty entries
  ## Empty entries in this vector are blank lines in markdown file
  md_v1 <- generics::setdiff(x = md_v0, y = "")

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
  found_heads <- generics::setdiff(x = unique(md_v3$info), y = "content")
  
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

# Invoke function
tabularize_md(file = file.path("dev", "test-markdown.md"))

# Try to trip errors
## No file specified
tabularize_md()

## Non-character entry
tabularize_md(file = 333)

## Too many entries
tabularize_md(file = c("xx", "aa"))

## Non-markdown file
tabularize_md(file = file.path("dev", "colinear_plot.R"))

# Does it work with Rmd files?
tabularize_md(file = file.path("dev", "test-rmark.Rmd"))

# What about Quarto documents?
tabularize_md(file = file.path("dev", "test-quarto.qmd"))


# End ----
