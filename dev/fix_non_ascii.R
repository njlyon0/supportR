## ------------------------------------------------------- ##
# Remove Non-ASCII Characters
## ------------------------------------------------------- ##
# Script author(s): Nick Lyon

# Purpose
## A function for coercing non-ASCII characters into ASCII equivalents

## ----------------------------------- ##
# Housekeeping ----
## ----------------------------------- ##

# Load libraries
librarian::shelf(tidyverse, supportR)

# Clear environment
rm(list = ls())

## ----------------------------------- ##
# Exploration ----
## ----------------------------------- ##

# Make a vector of non-ASCII characters
(bad_vec <- c("’", "“", "”", "—", "−", "-", "–", "×", "ﬁ", "ö", " ", "  ", "  ", "­", "·", "…"))

stringr::str_detect(string = bad_vec, pattern = "[^[:ascii:]]")






# End ----
