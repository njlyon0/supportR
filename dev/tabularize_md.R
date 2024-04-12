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
  # Coerce 0s to an artificially high number
  dplyr::mutate(level = ifelse(test = (level == 0), yes = 999, no = level))

# Check that out
text_v4




# End ----
