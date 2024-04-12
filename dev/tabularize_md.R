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







# End ----
