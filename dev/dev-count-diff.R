## -------------------------------------- ##
# Development Difference Count Function
## -------------------------------------- ##

# Should be similar to `count` but instead of counting instances of elements, should count difference in those counts between two vectors

## -------------------------- ##
# Housekeeping ----
## -------------------------- ##

# Load libraries
librarian::shelf(tidyverse)

# Clear environment
rm(list = ls()); gc()

## -------------------------- ##
# Explore Area ----
## -------------------------- ##

# Make two test vectors
x1 <- c(1, 1, NA, "a", 1, "a", NA, "x")
x2 <- c(1, NA, NA, "a", "x")

# Count elements
ct1 <- supportR::count(vec = x1) %>% 
  dplyr::rename(count_one = count)
ct2 <- supportR::count(vec = x2) %>% 
  dplyr::rename(count_two = count)

# Combine
ixn <- dplyr::full_join(x = ct1, y = ct2, by = "value") %>% 
  dplyr::mutate(diff = count_one - count_two) %>% 
  dplyr::select(-dplyr::starts_with("count_"))

# Check out output
ixn

# Clear environment
rm(list = ls()); gc()

## -------------------------- ##
# Function Dev Area ----
## -------------------------- ##

# Define function
count_diff <- function(vec1, vec2, what = NULL){
  
  # If 'what' is NULL, make it the unique contents of both vectors
  if(is.null(what)){ what <- unique(c(vec1, vec2)) }
  
  # Count all items in each vector
  n1 <- supportR::count(vec = vec1)
  n2 <- supportR::count(vec = vec2)
  
  # Combine these data objects
  full_n <- dplyr::full_join(x = n1, y = n2, by = "value") %>% 
    # Calculate difference
    dplyr::mutate(diff = count.x - count.y) %>% 
    # Rename columns
    dplyr::rename(vec1_count = count.x,
                  vec2_count = count.y)
  
  # Subset to only desired items
  sub_n <- dplyr::filter(.data = full_n, value %in% what)
  
  # Return warning if 'what' is not found in either vector
  if(nrow(sub_n) == 0)
    warning("No values found in either vector matching 'what' specification")
  
  # Return that
  return(sub_n) }

# Define test vectors
x1 <- c(1, 1, NA, "a", 1, "a", NA, "x")
x2 <- c(1, NA, NA, "a", "x")

# Invoke function to get difference of all things
count_diff(vec1 = x1, vec2 = x2, what = NULL)

# Invoke again to count difference in a specific element
count_diff(vec1 = x1, vec2 = x2, what = NA)
count_diff(vec1 = x1, vec2 = x2, what = "a")

# Check for warnings
count_diff(vec1 = x1, vec2 = x2, what = "B")

# Clear environment
rm(list = ls()); gc()



# End ----
