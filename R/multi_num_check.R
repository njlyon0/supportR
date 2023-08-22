#' @title Check Multiple Columns for Non-Numbers
#' 
#' @keywords internal
#' 
#' @description 
#' `r lifecycle::badge("deprecated")`
#' 
#' This function was deprecated because I realized that it is just a special case of the [num_check()] function.
#' 
#' @param data (dataframe) object containing at least one column of supposed numbers
#' @param col_vec (character or numeric) vector of names or column numbers of the columns containing putative numbers in the data object
#'
#' @return list of same length as `col_vec` with malformed numbers from each column in their respective element
#' @export
#'
#' @examples
#' # Create dataframe with a numeric column where some entries would be coerced into NA
#' spp <- c('salmon', 'bass', 'halibut', 'eel')
#' ct <- c(1, '14x', '_23', 12)
#' ct2 <- c('a', '2', '4', '0')
#' ct3 <- c(NA, 'Y', 'typo', '2')
#' fish <- data.frame('species' = spp, 'count' = ct, 'num_col2' = ct2, 'third_count' = ct3)
#'
#' # Use `multi_num_check()` to return only the entries that would be lost
#' multi_num_check(data = fish, col_vec = c("count", "num_col2", "third_count"))
multi_num_check <- function(data = NULL, col_vec = NULL){
  
  # Add deprecation message
  lifecycle::deprecate_warn(when = "1.2.0", what = "multi_num_check()", with = "num_check()")
  
  # Invoke `num_check` instead
  num_check(data = data, col = col_vec)
  
}
