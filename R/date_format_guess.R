

# Necessary housekeeping ----
library(tidyverse)

rm(list = ls())

(test <- data.frame(
  'survey' = c('person A', 'person B',
               'person B', 'person B',
               'person C', 'person D',
               'person E', 'person F',
               'person G'),
  'bad_dates' = c('2022.13.08', '2021/2/02',
                  '2021/2/03', '2021/2/04',
                  '1899/1/15', '10-31-1901',
                  '26/11/1901', '08.11.2004',
                  '6/10/02')) )

# Non-function workflow ----
test2 <- test %>%
  dplyr::mutate(
    # Fix various means of separating numbers in a date
    new_dates = gsub(pattern = "\\_|\\-|\\.", replacement = "/", x = bad_dates),
    # Extract year
    year = stringr::str_extract(string = new_dates, pattern = "[:digit:]{4}/|/[:digit:]{4}"),
    # Remove year from rest of date
    simp_dates = stringr::str_replace(string = new_dates,
                                     pattern = "[:digit:]{4}", replacement = ""),
    # Remove the leading/trailing symbol separating numbers
    simp_dates2 = stringr::str_extract(string = simp_dates,
                                       pattern = "[:digit:]{1,2}/[:digit:]{1,2}")
    ) %>%
  # Split the two numbers apart
  tidyr::separate(col = simp_dates2, sep = "/", into = c("num_L", "num_R")) %>%
  # Make both numbers truly numeric
  dplyr::mutate(num_L = as.numeric(num_L), num_R = as.numeric(num_R)) %>%
  # Group by the grouping variable and first number and count its frequency
  dplyr::group_by(survey, num_L) %>%
  dplyr::mutate(L_freq = dplyr::n()) %>%
  # Group by the grouping var and the other number and count its frequency too
  dplyr::group_by(survey, num_R) %>%
  dplyr::mutate(R_freq = dplyr::n()) %>%
  # Ungroup
  dplyr::ungroup() %>%
  # Use those frequencies to guess which is which!
  ## Note that the month/day vs. day/month are doubled to account for year placement
  dplyr::mutate(guess_partial = dplyr::case_when(
    # If one number is less than 12 & has more rows within a group, it's probably day
    num_L <= 12 & L_freq > R_freq ~ "month/day",
    num_R <= 12 & R_freq > L_freq ~ "day/month",
    # If frequency is equal, but one number is more than 12, that number is day
    L_freq == R_freq & num_L > 12 ~ "day/month",
    L_freq == R_freq & num_R > 12 ~ "month/day",
    # If frequency is equal and both numbers are less than/equal to 12, its not guessable
    L_freq == R_freq & num_L <= 12 & num_R <= 12 ~ "format uncertain")) %>%
  # Now figure out whether year was on the left or right
  # Make a quick partial year column
  dplyr::mutate(year_partial = stringr::str_sub(string = year,
                                                start = nchar(year) - 1,
                                                end = nchar(year))) %>%
  dplyr::mutate(format_guess = dplyr::case_when(
    # If we couldn't guess day vs. month, year won't help things
    guess_partial == "format uncertain" ~ "format uncertain",
    # If year is the wrong length we can't process the date
    nchar(year) != 5 ~ guess_partial,
    # If year is right and has a leading slash, it was at the end of the raw date
    stringr::str_sub(string = year,
                     start = 1, end = 1) == "/" ~ paste0(guess_partial, "/year"),
    "/" %in% gsub(pattern = "0|1|2|3|4|5|6|7|8|9", replacement = "",
                  x = year_partial) ~ paste0("year/", guess_partial) ) ) %>%
  # Remove intermediary columns
  dplyr::select(-new_dates, -year, -simp_dates,
                -num_L, -num_R, -L_freq, -R_freq,
                -guess_partial, -year_partial) %>%
  as.data.frame()

test2


# Name option:
# "guesstiDATE" (instead of estimate)

# Function variant ----
date_format_guess <- function(data = NULL, date_col = NULL,
                              groups = TRUE, group_col = NULL,
                              return = "dataframe", quiet = FALSE){

  # Error out if `data` isn't defined
  if(is.null(data)) stop("`data` must be defined")

  # Error out if `date_col` is undefined...
  if(is.null(date_col)) stop("`date_col` must be defined")
  # ...Or isn't a character...
  if(class(date_col) != "character") stop("`date_col` must be a character")
  # ...Or isn't a column in `data`
  if(!date_col %in% names(data)) stop("`date_col` must be a column name in `data`")

  # Warn when `groups` isn't a logical and re-set it to `FALSE`
  if(class(groups) != "logical"){
    message("`groups` must be a logical. Re-setting to `FALSE`")
    groups <- FALSE }

  # Error out if `groups = TRUE` but `group_col` is undefined...
  if(groups == TRUE & is.null(group_col))
    stop("`group_col` must be defined if `groups == TRUE`")
  # Error out if `groups = TRUE` and `group_col` *is* defined BUT...
  if(groups == TRUE & !is.null(group_col)){
    # ...Isn't a character...
    if(class(group_col) != "character")
      stop("`group_col` must be a character")
    #...Or isn't in the dataframe
    if(!group_col %in% names(data))
      stop("`group_col` must be a column name in `data`") }

  # Warn when `quiet` isn't a logical and re-set it to `FALSE`
  if(class(quiet) != "logical"){
    message("`quiet` must be a logical. Re-setting to `FALSE`")
    quiet <- FALSE }

  # Error out if `return is unspecified`...
  if(is.null(return)) stop("`return` must be defined")
  # ...Or isn't either "dataframe" or "vector"
  if(!return %in% c("dataframe", "vector"))
    stop("`return` must be one of either 'dataframe' or 'vector'")

  # Do some initial standardization & extraction
  guess_v1 <- data %>%
    dplyr::mutate(
      # Standardize special characters between date components
      new_dates = gsub(pattern = "\\_|\\-|\\.", replacement = "/",
                       x = data[[date_col]]),
      # Extract year regardless of whether it is first or last
      year = stringr::str_extract(string = new_dates, pattern = "[:digit:]{4}/|/[:digit:]{4}"),
      # Remove year from rest of date
      simp_dates = stringr::str_replace(string = new_dates,
                                        pattern = "[:digit:]{4}", replacement = ""),
      # Remove the leading/trailing symbol separating numbers
      simp_dates2 = stringr::str_extract(string = simp_dates,
                                         pattern = "[:digit:]{1,2}/[:digit:]{1,2}")) %>%
    # Split the two numbers (MM/DD or DD/MM) apart
    tidyr::separate(col = simp_dates2, sep = "/", into = c("num_L", "num_R")) %>%
    # Make both numbers truly numeric
    dplyr::mutate(num_L = as.numeric(num_L), num_R = as.numeric(num_R))

  # `groups == TRUE` ----
  # Count frequencies and use that to help our inference
  if(groups == TRUE) {

  # Frequency counting with groups
  guess_v2 <- guess_v1 %>%
    # Group by the grouping variable and first number and count its frequency
    dplyr::group_by(data[[group_col]], num_L) %>%
    dplyr::mutate(L_freq = dplyr::n()) %>%
    # Group by the grouping var and the other number and count its frequency too
    dplyr::group_by(data[[group_col]], num_R) %>%
    dplyr::mutate(R_freq = dplyr::n()) %>%
    # Ungroup
    dplyr::ungroup()

  # Now, make (informed) format guesses!
  guess_v3 <- guess_v2 %>%
    # Use those frequencies to guess which is which!
    dplyr::mutate(guess_partial = dplyr::case_when(
      # If one number is less than 12 & has more rows within a group, it's probably day
      num_L <= 12 & L_freq > R_freq ~ "month/day",
      num_R <= 12 & R_freq > L_freq ~ "day/month",
      # If frequency is equal, but one number is more than 12, that number is day
      L_freq == R_freq & num_L > 12 ~ "day/month",
      L_freq == R_freq & num_R > 12 ~ "month/day",
      # If frequency is equal and both numbers are less than/equal to 12, its not guessable
      L_freq == R_freq & num_L <= 12 & num_R <= 12 ~ "format uncertain")) %>%
    # Now figure out whether year was on the left or right
    # Make a quick partial year column
    dplyr::mutate(year_partial = stringr::str_sub(string = year,
                                                  start = nchar(year) - 1,
                                                  end = nchar(year))) %>%
    dplyr::mutate(format_guess = dplyr::case_when(
      # If we couldn't guess day vs. month, year won't help things
      guess_partial == "format uncertain" ~ "FORMAT UNCERTAIN",
      # If year is the wrong length we can't process the date
      nchar(year) != 5 ~ guess_partial,
      # If year is right and has a leading slash, it was at the end of the raw date
      stringr::str_sub(string = year,
                       start = 1, end = 1) == "/" ~ paste0(guess_partial, "/year"),
      "/" %in% gsub(pattern = "0|1|2|3|4|5|6|7|8|9", replacement = "",
                    x = year_partial) ~ paste0("year/", guess_partial) ) ) }

  # `groups == FALSE` ----
  if(groups == FALSE){

    # Warn the user that lacking groups makes the function worse
    if(quiet != TRUE){
      message("Defining `groups` is strongly recommended! If none exist, consider adding a single artificial group shared by all rows then re-run this function") }

    # We can't do the frequency counting thing so we'll just make empty columns
    guess_v2 <- guess_v1 %>%
      dplyr::mutate(L_freq = 'a', R_freq = 'b')

    # Now, make the best guesses possible
    guess_v3 <- guess_v2 %>%
      # Use those frequencies to guess which is which!
      dplyr::mutate(guess_partial = dplyr::case_when(
        # If a number is greater than 12, it has to be day
        num_L > 12 ~ "day/month",
        num_R > 12 ~ "month/day",
        # Unfortunately this is the best we can do without the frequency info
        TRUE ~ "format uncertain")) %>%
      # Now figure out whether year was on the left or right
      # Make a quick partial year column
      dplyr::mutate(year_partial = stringr::str_sub(string = year,
                                                    start = nchar(year) - 1,
                                                    end = nchar(year))) %>%
      dplyr::mutate(format_guess = dplyr::case_when(
        # If we couldn't guess day vs. month, year won't help things
        guess_partial == "format uncertain" ~ "FORMAT UNCERTAIN",
        # If year is the wrong length we can't process the date
        nchar(year) != 5 ~ guess_partial,
        # If year is right and has a leading slash, it was at the end of the raw date
        stringr::str_sub(string = year,
                         start = 1, end = 1) == "/" ~ paste0(guess_partial, "/year"),
        "/" %in% gsub(pattern = "0|1|2|3|4|5|6|7|8|9", replacement = "",
                      x = year_partial) ~ paste0("year/", guess_partial) ) ) }

  # Do final post-processing
  guess_actual <- guess_v3 %>%
    # Remove intermediary columns
    dplyr::select(names(data), format_guess) %>%
    # Make it a dataframe
    as.data.frame()

  # If `return = "dataframe"`, return that object
  if(return == "dataframe"){
    if(quiet != TRUE){ message("Returning dataframe of data format guesses") }
    return(guess_actual) }
  # If `return = "vector"`, return *that* object
  if(return == "vector"){
    if(quiet != TRUE){ message("Returning vector of data format guesses") }
    return(guess_actual$format_guess) }
}

# Testing function
date_format_guess(data = test, date_col = "bad_dates", group_col = "survey")

# What about without groups
date_format_guess(data = test, date_col = "bad_dates", groups = FALSE)

# What about with groups but return as a vector
date_format_guess(data = test, date_col = "bad_dates",
                  group_col = "survey", return = "vector")

# Try to get the error/warning messages
# Error out if `data` isn't defined
date_format_guess(date_col = "bad_dates", groups = TRUE, group_col = "survey")

# Error out if `date_col` is undefined...
date_format_guess(data = test, groups = TRUE, group_col = "survey")
# ...Or isn't a column in `data`
date_format_guess(data = test, date_col = "wrong_column", group_col = "survey")
# ...Or isn't a character
date_format_guess(data = test, date_col = 4, group_col = "survey")

# Error out when `return` is not allowable entry
date_format_guess(data = test, date_col = "bad_dates",
                  group_col = "survey", return = "blah blah blah")
date_format_guess(data = test, date_col = "bad_dates",
                  group_col = "survey", return = 2)

# Warn when `groups` isn't a logical and re-set it to `FALSE`
date_format_guess(data = test, date_col = "bad_dates",
                  groups = "true", group_col = "survey")

# Error out if `groups = TRUE` but `group_col` is undefined...
date_format_guess(data = test, date_col = "bad_dates", groups = TRUE)
# ...Or isn't in the dataframe
date_format_guess(data = test, date_col = "bad_dates", group_col = "wrong_column")
# ...Or isn't a character
date_format_guess(data = test, date_col = "bad_dates", group_col = 13)

# Warn when `quiet` isn't a logical and re-set it to `FALSE`
date_format_guess(data = test, date_col = "bad_dates",
                  groups = FALSE, quiet = 'false')

# End ---
