# Explore 'count' Function

## With `plyr` deprecated, its helpful `count` function is likewise inaccessible
## While there is a workaround with `dplyr` it is three lines and it'd be nice to have a one-line simple option

# Load libraries
librarian::shelf(tidyverse)

# Clear environment
rm(list = ls())

# Make a test vector
(test_vec <- c(rep("a", times = 5), rep("x", times = 2),  rep("33", times = 6), 11, rep(NA, times = 3)))
# vec <- test_vec

# Define function
count <- function(vec = NULL){
  
  # Error out for missing vector
  if(is.null(vec) == TRUE)
    stop("'vec' must be specified")
  
  # Error out for non-vector
  if(is.vector(vec) != TRUE)
    stop("'vec' must be a vector")
  
  # Identify unique bits
  unique_vec <- unique(vec)
  
  # Make a dataframe to store counts
  count_df <- data.frame("value" = unique_vec,
                         "count" = NA)
  
  # Count number of occurrences of each unique element
  for(bit in unique_vec){
    
    # Handle instances of NA in original vector
    if(is.na(bit) == TRUE){
      
      # Actual bit counting
      bit_ct <- sum(is.na(vec))
      
      # Add to dataframe
      count_df[is.na(count_df$value), ]$count <- bit_ct
      
      # If not NA...
    } else {
      
      # Count occurrences
      bit_ct <- length(vec[vec == bit])
      
      # Add to dataframe
      count_df[(count_df$value == bit & !is.na(count_df$value)), ]$count <- bit_ct
      
    } # Close conditional
  } # Close loop
  
  # Return that dataframe
  return(count_df) }

# Invoke function
count(vec = test_vec)


