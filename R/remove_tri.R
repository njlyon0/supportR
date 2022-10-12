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

# Non-Function workflow ----

# Testing class errors (eventually needed)
unique(class(as_tibble(test2)) %in% c("tbl_df", "tbl", "data.frame"))
test3 <- as.data.frame(test2)

unique(class(as.data.frame(test3)) == "data.frame")

# Dup data
test4 <- test3
glimpse(test4)

# Make first column into rownames
rownames(x = test4) <- test4[,1]
test4

# Keep only columns in rownames
test5 <- test4[ , rownames(test4)]
test5

# Drop triangle
test5[upper.tri(x = test5, diag = TRUE)] <- NA
test5

# Function workflow ----
remove_tri_df <- function(data = NULL, tri_keep = "lower", drop_diag = TRUE){

  # Error out if triangle isn't approved specification
  if(!tri_keep %in% c("lower", "upper"))
    stop("`tri_keep` must be either 'lower' or 'upper'")

  # Error out for unsupported dataframe
  if(unique(class(data) %in% c("tbl_df", "tbl", "data.frame") == FALSE))
     stop("`data` format unsupported. For matrices, use `helpR::remove_tri_mat`")

  # If a tibble (multiple classes), coerce to dataframe
  if((length(class(data)) > 1) == TRUE){
    df2 <- as.data.frame(data)
    # Otherwise continue
  } else { df2 <- data }

  # Error out for asymmetric data frames
  if((nrow(df2) + 1) != ncol(df2))
    stop("Extra columns detected. `data` must include only the index column (to be made into rownames) and numeric columns")

  # Error out for mismatched index col and other col names
  if(length(setdiff(x = names(df2)[-1], y = df2[[1]])) > 0)
    stop("Mismatch between index column and other column names")

  # Assign first column as dataframe
  rownames(x = df2) <- df2[,1]

  # Drop index column (first column)
  df3 <- df2[,-1]

  # If diagonal isn't logical, coerce it to FALSE (default)
  if(class(drop_diag) != "logical"){
    drop_diag <- TRUE
    message("`drop_diag` must be logical. Defaulting to TRUE") }

  # Cut out desired triangle and (potentially) diagonal
  if(tri_keep == "upper"){
    df3[lower.tri(x = df3, diag = drop_diag)] <- NA
  }
  if(tri_keep == "lower"){
    df3[upper.tri(x = df3, diag = drop_diag)] <- NA
  }

  # Return cropped triangle
  return(df3) }

remove_tri_mat <- function(matrix = NULL, tri_keep = "lower", drop_diag = TRUE){

  # Error out if triangle isn't approved specification
  if(!tri_keep %in% c("lower", "upper"))
    stop("`tri_keep` must be either 'lower' or 'upper'")

  # Error out for unsupported class
  if(unique(class(matrix)) %in% c("matrix", "array") == FALSE)
    stop("`data` format unsupported. For tibbles/dataframes, use `helpR::remove_tri_df`")

  # If diagonal isn't logical, coerce it to FALSE (default)
  if(class(drop_diag) != "logical"){
    drop_diag <- TRUE
    message("`drop_diag` must be logical. Defaulting to TRUE") }

  # Duplicate data
  mat2 <- matrix

  # Cut out desired triangle and (potentially) diagonal
  if(tri_keep == "upper"){
    mat2[lower.tri(x = mat2, diag = drop_diag)] <- NA
  }
  if(tri_keep == "lower"){
    mat2[upper.tri(x = mat2, diag = drop_diag)] <- NA
  }

  # Return cropped triangle
  return(mat2) }



remove_tri_df(data = test2)


testB <- as.data.frame(test2)
rownames(testB) <- testB$focal_sp
test_actual <- testB[-1]

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

