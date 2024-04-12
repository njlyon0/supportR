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
text_v5 <- text_v4 %>% 
  dplyr::mutate(level_1 = ifelse(test = (info == "heading_1"),
                                 yes = text, no = NA)) %>% 
  # Fill downward with whatever the level one heading text is
  tidyr::fill(level_1, .direction = "down")

# Examine
text_v5





# Demo/check pivoting
text_v4 %>% 
  dplyr::mutate(row_num = 1:nrow(x = . )) %>% 
  select(-info) %>% 
  pivot_wider(names_from = type, values_from = text)


text_v4 %>% 
  dplyr::mutate(row_num = 1:nrow(x = . )) %>% 
  dplyr::select(-level, -type) %>% 
  pivot_wider(names_from = info, values_from = text)


# End ----
