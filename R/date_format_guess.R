#' @title Identify Probable Format for Ambiguous Date Formats
#'
#' @description In a column containing multiple date formats (e.g., MM/DD/YYYY, "YYYY/MM/DD, etc.) identifies probable format of each date. Provision of a grouping column improves inference. Any formats that cannot be determined are flagged as "FORMAT UNCERTAIN" for human double-checking. This is useful for quickly sorting the bulk of ambiguous dates into clear categories for later conditional wrangling.
#'
#' @param data (dataframe) object containing at least one column of ambiguous dates
#' @param date_col (character) name of column containing ambiguous dates
#' @param groups (logical) whether groups exist in the dataframe / should be used (defaults to TRUE)
#' @param group_col (character) name of column containing grouping variable
#' @param return (character) either "dataframe" or "vector" depending on whether the user wants the date format "guesses" returned as a new column on the dataframe or a vector
#' @param quiet (logical) whether certain optional messages should be displayed (defaults to FALSE)
#'
#'
#' @return (dataframe or character) object containing date format guesses
#' @importFrom magrittr %>%
#' @export
#'
#' @examples
#' # Create dataframe of example ambiguous dates & grouping variable
#' my_df <- data.frame('data_enterer' = c('person A', 'person B',
#'                                        'person B', 'person B',
#'                                        'person C', 'person D',
#'                                        'person E', 'person F',
#'                                        'person G'),
#'                     'bad_dates' = c('2022.13.08', '2021/2/02',
#'                                     '2021/2/03', '2021/2/04',
#'                                     '1899/1/15', '10-31-1901',
#'                                     '26/11/1901', '08.11.2004',
#'                                     '6/10/02'))
#'
#' # Now we can invoke the function!
#' date_format_guess(data = my_df, date_col = "bad_dates",
#' group_col = "data_enterer", return = "dataframe")
#'
#' # If preferred, do it without groups and return a vector
#' date_format_guess(data = my_df, date_col = "bad_dates",
#' groups = FALSE, return = "vector")
#'
date_format_guess <- function(data = NULL, date_col = NULL,
                              groups = TRUE, group_col = NULL,
                              return = "dataframe", quiet = FALSE){
  # Squelch 'visible bindings' note
  new_dates <- simp_dates <- simp_dates2 <- NULL
  num_L <- num_R <- year <- format_guess <- NULL

  # Error check for data object
  if(is.null(data) || "data.frame" %in% class(data) != TRUE)
    stop("'data' must be specified as a dataframe-like object")
  
  # Error checks for date column
  if(is.null(date_col) || is.character(date_col) != TRUE || length(date_col) != 1 || date_col %in% names(data) != TRUE || is.character(data[[date_col]]) != TRUE)
    stop("'date_col' must be the name of a character column found in 'data'")
  
  # Warn when 'groups' isn't a logical and re-set it to 'FALSE'
  if(is.logical(groups) != TRUE){
    warning("'groups' must be a logical. Re-setting to 'FALSE'")
    groups <- FALSE }

  # Error if groups are indicated but not defined
  if(groups == TRUE & is.null(group_col))
    stop("'group_col' must be defined if 'groups' is set to TRUE")
  
  # Error checks for group_col if it is needed and provided
  if(groups == TRUE & !is.null(group_col)){
    if(length(group_col) != 1 || is.character(group_col) != TRUE || length(group_col) != 1 || group_col %in% names(data) != TRUE || is.character(data[[group_col]]) != TRUE)
      stop("If provided, 'group_col' must be the name of a single character column found in 'data'. 'group_col' only supports a single grouping column. Consider collapsing several columns to achieve this if necessary") }

  # Warn when 'quiet' isn't a logical and re-set it to 'FALSE'
  if(is.logical(quiet) != TRUE){
    warning("'quiet' must be a logical. Defaulting to 'FALSE'")
    quiet <- FALSE }

  # Error checks for 'return
  if(is.null(return) || !return %in% c("dataframe", "vector"))
    stop("'return' must be provided as one of either 'dataframe' or 'vector'")

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

  # 'groups == TRUE' ----
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

  # 'groups == FALSE' ----
  if(groups == FALSE){

    # Warn the user that lacking groups makes the function worse
    if(quiet != TRUE){
      message("Defining 'groups' is strongly recommended! If none exist, consider adding a single artificial group shared by all rows then re-run this function") }

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

  # If 'return = "dataframe"', return that object
  if(return == "dataframe"){
    if(quiet != TRUE){ message("Returning dataframe of data format guesses") }
    return(guess_actual) }
  # If 'return = "vector"', return *that* object
  if(return == "vector"){
    if(quiet != TRUE){ message("Returning vector of data format guesses") }
    return(guess_actual$format_guess) }
}
