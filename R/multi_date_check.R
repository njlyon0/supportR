#' @title Check Multiple Columns for Non-Dates
#' 
#' @keywords internal
#' 
#' @description 
#' `r lifecycle::badge("deprecated")`
#' 
#' This function was deprecated because I realized that it is just a special case of the [date_check()] function.
#'
#' @param data (dataframe) object containing at least one column of supposed dates
#' @param col_vec (character or numeric) vector of names or column numbers of the columns containing putative dates in the data object
#'
#' @return list of same length as `col_vec` with malformed dates from each column in their respective element
#' @export
#'
#' @examples
#' # Make a dataframe to test the function
#' loc <- c("LTR", "GIL", "PYN", "RIN")
#' time <- c('2021-01-01', '2021-01-0w', '1990', '2020-10-xx')
#' time2 <- c('1880-08-08', '2021-01-02', '1992', '2049-11-01')
#' time3 <- c('2022-10-31', 'tomorrow', '1993', NA)
#'
#' # Assemble our vectors into a dataframe
#' sites <- data.frame('site' = loc, 'first_visit' = time, "second" = time2, "third" = time3)
#'
#' # Use `multi_date_check()` to return only the entries that would be lost
#' multi_date_check(data = sites, col_vec = c("first_visit", "second", "third"))
multi_date_check <- function(data = NULL, col_vec = NULL){
  
  # Add deprecation message
  lifecycle::deprecate_warn(when = "1.2.0", what = "multi_date_check()", with = "date_check()")
  
  # Invoke `num_check` instead
  date_check(data = data, col = col_vec)
  
}
