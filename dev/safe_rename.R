## --------------------------------------------- ##
# Safely Rename Columns
## --------------------------------------------- ##

# PURPOSE:
## Safely rename columns via a function
## Alternative (unsafe) is something like:
### `names(df)[1] <- c("x")`

## ----------------------------- ##
# Housekeeping ----
## ----------------------------- ##

# Load libraries
librarian::shelf(tidyverse, supportR)

# Clear environment
rm(list = ls())

## ----------------------------- ##
# Testing Arena ----
## ----------------------------- ##

# Make a dataframe
(df <- data.frame("first" = 1:3,
                  "middle" = 4:6,
                  "second" = 7:9))

# Duplicate to test various renaming approaches
df4 <- df3 <- df2 <- df

# Rename in base R / unsafe manner
names(df2)[1] <- "number_one"
df2

# Safe-r method
## ID bad name
bad_name <- c("first", "second")

## Match and replace it in the names vector
names(df3)[names(df3) %in% bad_name] <- c("safe_first", "safe_second")
df3


# Function-style exploration
safe_rename <- function(data = NULL, bad_names = NULL, good_names = NULL){
  
  # Error out if any arguments are missing
  
  
  # Error out if a different number of bad names and good names
  if(length(bad_names) != length(good_names))
    stop("Must provide same number of replacement column names as names to be replaced")
  
  # Error out if good names are not characters
  if(is.character(good_names) != TRUE)
    stop("Replacement column names must be provided as a character")
  
  # Error out if bad names are not either numbers or characters
  if(is.character(bad_names) != TRUE & is.numeric(bad_names) != TRUE)
    stop("`bad_names` must be either a character or a number")
  
  # Duplicate data
  renamed_data <- data
  
  # Number variant
  if(is.numeric(bad_names) == TRUE){
    
    # Error out if numbers reference positions that don't exist
    if(max(bad_names, na.rm = TRUE) > length(names(data)))
      stop("Invalid column positions specified")
    
    # Replace names
    names()
    
    
    
    
  } # Close 'bad names are NUMBERS' conditional
  
  # Character variant
  if(is.character(bad_names) == TRUE){
    
    # Error out if not all "bad_names" are found in the data
    if(all(bad_names %in% names(data)) != TRUE)
      stop("Not all `bad_names` found in data")
    
    # Replace names (safely)
    names(renamed_data)[names(renamed_data) %in% bad_names] <- good_names
    
  } # Close 'bad names are CHARACTERS' conditional
  
  # Return the renamed data object
  return(renamed_data) }




# End ----
