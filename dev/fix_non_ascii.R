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
(bad_vec <- c("’", "“", "”", "—", "−", "–", "×", "ﬁ", "ö", "­", "·", "…"))

# Check to make sure they are all non-ASCII characters
stringr::str_detect(string = bad_vec, pattern = "[^[:ascii:]]")

# Define function
fix_non_ascii <- function(x = NULL){
  
  # Error out if x isn't supplied
  if(is.null(x) == TRUE)
    stop("'x' must be specified")
  
  # Error out if x isn't a character
  if(is.character(x) != TRUE)
    stop("'x' must be a character")
  
  # Make a new object for ease of later manipulations
  q <- x
  
  # Do actually fixing
  
  
  # Return that fixed vector
  return(q) }

# Invoke function
(good_vec <- fix_non_ascii(x = bad_vec))

# Check to see if that worked
## Conditional is a double negative ('not not ASCII')
any(stringr::str_detect(string = good_vec, pattern = "[^[:ascii:]]") != TRUE)

# End ----
