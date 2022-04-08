#' @title Check a Column for Non-Numbers.
#' @description Any elements in the column that would be changed to NA if `as.numeric()` is used on the column are returned. This is useful for quickly identifying only the "problem" entries of an ostensibly numeric column that is read in as a character.
#'
#' @param data A data frame
#' @param col A column name from the provided data frame as a character vector
#'
#' @return A character vector
#' @export
#'
#' @examples
#' # Create dataframe with a numeric column where some entries would be coerced into NA
#' spp <- c('salmon', 'bass', 'halibut', 'eel')
#' ct <- c(1, '14x', '_23', 12)
#' fish <- data.frame('species' = spp, 'count' = ct)
#'
#' # Use `num_chk()` to return only the entries that would be lost
#' helpR::num_chk(data = fish, col = "count")
num_chk <- function(data, col) {
  df <- as.data.frame(data)
  notNA <- subset(df, !is.na(df[, col]))
  bad <- subset(notNA, is.na(suppressWarnings(as.numeric(notNA[, col]))))
  if(nrow(bad) != 0){
    unique(bad[, col])
  } else { print('No bad numbers.') }
}
