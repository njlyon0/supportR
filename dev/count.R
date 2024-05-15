# Explore 'count' Function

## With `plyr` deprecated, its helpful `count` function is likewise inaccessible
## While there is a workaround with `dplyr` it is three lines and it'd be nice to have a one-line simple option

# Load libraries
librarian::shelf(tidyverse)

# Clear environment
rm(list = ls())

# Make a test vector
(test_vec <- c(rep("a", times = 5), rep("x", times = 2),  rep("33", times = 6), 11))

# Identify unique bits
(unique_vec <- unique(x = test_vec))

# Make a dataframe for that
count_df <- data.frame("value" = unique_vec,
                       "count" = NA)

# Work on counting elements
for(bit in unique_vec){
  
  # Count number of occurrences
  bit_ct <- length(test_vec[test_vec == bit])
  
  # Add to dataframe
  count_df[count_df$value == bit, ]$count <- bit_ct
  
}



