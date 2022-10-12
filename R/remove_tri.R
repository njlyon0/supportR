library(tidyverse)

# Read in data
test <- read.csv("test_df.csv")

# Check it
glimpse(test)

# Pivot wider
test2 <- test %>%
  filter(site == "Andrews") %>%
  select(-site) %>%
  mutate(other_sp = gsub(" ", "_", other_sp),
         focal_sp = gsub(" ", "_", focal_sp)) %>%
  pivot_wider(names_from = other_sp,
              values_from = relatedness_dist)

# Check again
glimpse(test2)

# Do more prep work
testB <- as.data.frame(test2)
rownames(testB) <- testB$focal_sp
test_actual <- testB[-1]

# Invoke function
cut_tri <- function(data = NULL, drop_tri = "upper", drop_diag = FALSE){

  # Error out for missing data
  if(is.null(data)) stop("`data` must be provided")

  # Error out if triangle argument isn't supported
  if(!drop_tri %in% c("upper", "lower"))
    stop("`drop_tri` must be one of 'upper' or 'lower'")

  # Coerce `drop_diag` to logical if it isn't
  if(class(drop_diag) != "logical"){
    drop_diag <- FALSE
    message("`drop_diag` must be logical. Defaulting to FALSE") }

  # Duplicate data
  crop_data <- data

  # Cut triangle
  if(drop_tri == "upper"){
    crop_data[upper.tri(x = crop_data, diag = drop_diag)] <- NA
  }
  if(drop_tri == "lower"){
    crop_data[lower.tri(x = crop_data, diag = drop_diag)] <- NA
  }

  # Return it
  return(crop_data) }

cut_tri(data = test_actual)

# End ----

