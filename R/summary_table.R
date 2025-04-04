#' @title Generate Summary Table for Supplied Response and Grouping Variables
#'
#' @description Calculates mean, standard deviation, sample size, and standard error of a given response variable within user-defined grouping variables. This is meant as a convenience instead of doing `dplyr::group_by` followed by `dplyr::summarize` iteratively themselves.
#'
#' @param data (dataframe or dataframe-like) object with column names that match the values passed to the `groups` and `response` arguments
#' @param groups (character) vector of column names to group by
#' @param response (character) name of the column name to calculate summary statistics for (the column must be numeric)
#' @param drop_na (logical) whether to drop NAs in grouping variables. Defaults to FALSE
#' @param round_digits (numeric) number of digits to which mean, standard deviation, and standard error should be rounded
#'
#' @return (dataframe) summary table containing the mean, standard deviation, sample size, and standard error of the supplied response variable
#'
#' @importFrom magrittr %>%
#' @export
#'
summary_table <- function(data = NULL, groups = NULL, response = NULL,
                          drop_na = FALSE, round_digits = 2){
  # Handle no visible bindings note
  std_dev <- sample_size <- NULL
  
  # Error checks for data object
  if(is.null(data) || "data.frame" %in% class(data) != TRUE)
    stop("'data' must be specified as a dataframe-like object")
  
  # Error checks for groups column
  if(is.null(groups) || is.character(groups) != TRUE || length(setdiff(x = groups, y = names(data))) != 0)
    stop("'groups' must be a character vector of all be columns found in 'data'")
  
  # Error checks for response columns
  if(is.null(response) || is.character(response) != TRUE || length(response) != 1 || !response %in% names(data) || is.numeric(data[[response]]) != TRUE)
    stop("'response' must be a single column name in 'data' that is numeric")
  
  # Warn if drop_na isn't a logical
  if(is.logical(drop_na) != TRUE){
    warning("'drop_na' must be a logical. Defaulting to FALSE")
    drop_na <- FALSE }
  
  # Warn if rounding digits is not a number
  if(is.numeric(round_digits) != TRUE){
    warning("'round_digits' must be an integer. Defaulting to 2")
    round_digits <- 2 }
  
  # Silence `dplr::summarize`
  options(dplyr.summarise.inform = FALSE)
  
  # Create a summary table
  tidy <- data %>%
    # Group by provided grouping variables
    dplyr::group_by(dplyr::across(dplyr::all_of(groups))) %>%
    # Perform summarization
    dplyr::summarize(
      mean = round(mean(!!rlang::ensym(response), na.rm = TRUE),
                   digits = round_digits),
      std_dev = round(stats::sd(!!rlang::ensym(response), na.rm = TRUE),
                      digits = round_digits),
      sample_size = dplyr::n(),
      std_error = round((std_dev / sqrt(sample_size)),
                        digits = round_digits)) %>%
    # Make it a dataframe
    as.data.frame()
  
  # If `drop_na` is FALSE, return this tidy data
  if(drop_na == FALSE){ return(tidy)
    
    # Otherwise...
  } else {
    
    # Remove NAs in the grouping variable(s)
    tidy_full <- tidy %>%
      tidyr::drop_na(tidyr::all_of(groups))
    
    # And return that object instead
    return(tidy_full) } }
