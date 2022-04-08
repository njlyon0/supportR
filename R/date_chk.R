#' @title Check a Column for Non-Dates.
#' @description Any elements in the column that would be changed to NA if `as.Date()` is used on the column are returned. This is useful for quickly identifying only the "problem" entries of an ostensibly date column that is read in as a character.
#'
#' @param data A data frame
#' @param col A column name from the provided data frame as a character vector
#'
#' @return A character vector
#' @export
#'
#' @examples
#' # Let's create some data that will be useful in demoing this function
#' loc <- c("LTR", "GIL", "PYN", "RIN")
#' time <- c('2021-01-01', '2021-01-0w', '1990', '2020-10-xx')
#' sites <- data.frame('site' = loc, 'visit' = time)
#'
#' # Now we can use our function to identify bad dates
#' helpR::date_chk(data = sites, col = 'visit')
date_chk <- function(data, col) {
  df <- as.data.frame(data)
  notNA <- subset(df, !is.na(df[, col]))
  bad <- subset(notNA, is.na(as.Date(notNA[, col])))
  if(nrow(bad) != 0){
    unique(bad[, col])
  } else { print('No bad dates.') }
}
