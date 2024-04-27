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
(bad_vec <- c("’", "“", "”", "—", "−", "–", "×", "ﬁ", "ö", "­", 
              "·", "…", "`", "ò", "ó", "á", "à", "å", "ë", "ä", 
              "é", "è", "ü", "ú", "ù"))

# Check to make sure they are all non-ASCII characters
bad_vec[stringr::str_detect(string = bad_vec, pattern = "[^[:ascii:]]") == TRUE]

# Define function
fix_non_ascii <- function(x = NULL){
  
  # Error out if x isn't supplied
  if(is.null(x) == TRUE)
    stop("'x' must be specified")
  
  # Error out if x isn't a character
  if(is.character(x) != TRUE)
    stop("'x' must be a character")
  
  # Make a new object so we can make all find/replace steps identical
  q <- x
  
  # Do actual fixing
  ## Quotes / apostrophes
  q <- gsub(pattern = "’|`", replacement = "'", x = q)
  q <- gsub(pattern = "“|”", replacement = '"', x = q)
  ## Dashes / symbols
  q <- gsub(pattern = "—|−|–", replacement = "-", x = q)
  q <- gsub(pattern = "×", replacement = "*", x = q)
  q <- gsub(pattern = "·", replacement = ".", x = q)
  q <- gsub(pattern = "…", replacement = "...", x = q)
  ## Spaces
  q <- gsub(pattern = "­", replacement = " ", x = q)
  ## Letters
  q <- gsub(pattern = "ﬁ", replacement = "fi", x = q)
  q <- gsub(pattern = "ö|ó|ò", replacement = "o", x = q)
  q <- gsub(pattern = "ë|é|è", replacement = "e", x = q)
  q <- gsub(pattern = "ä|á|à|å", replacement = "a", x = q)
  q <- gsub(pattern = "ü|ú|ù", replacement = "u", x = q)
  
  # See if any are not fixed manually above
  unfixed <- q[stringr::str_detect(string = q, pattern = "[^[:ascii:]]") == TRUE]
  
  # Give a warning if any are found
  if(length(unfixed) != 0){
    warning("Failed to fix following non-ASCII characters: ", 
            paste0("'", unfixed, "'", collapse = "', '"), 
            "\nPlease open a GitHub Issue if you'd like this function to support a particular fix for this character") }
  
  # Return that fixed vector
  return(q) }

# Invoke function
(good_vec <- fix_non_ascii(x = bad_vec))

# Check to see if that worked
good_vec[stringr::str_detect(string = good_vec, pattern = "[^[:ascii:]]") == TRUE]

# Check on one that should throw the warning
fix_non_ascii(x = "§")


# End ----
