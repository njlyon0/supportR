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

  # Error out if anything isn't provided
  if(is.null(data) | is.null(groups) | is.null(response))
    stop("All arguments must be specified")

  # Error out if groups or response are not characters
  if(is.character(groups) != TRUE | is.character(response) != TRUE)
    stop("Grouping and response variables must be supplied as characters")

  # Error out if groups or response are not column names in the data
  if(base::length(base::setdiff(x = groups, y = names(data))) != 0 |
     !response %in% names(data))
    stop("Grouping and response variables must be identical to column names in data object")

  # Error out if response is non-numeric
  if(is.numeric(data[[response]]) != TRUE)
    stop("Response variable must be numeric")

  # Warn if drop na isn't a logical
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
      mean = base::round(base::mean(!!rlang::ensym(response), na.rm = TRUE),
                         digits = round_digits),
      std_dev = base::round(stats::sd(!!rlang::ensym(response), na.rm = TRUE),
                            digits = round_digits),
      sample_size = dplyr::n(),
      std_error = base::round((std_dev / base::sqrt(sample_size)),
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
