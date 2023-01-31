#' @title Check a Column for Non-Numbers
#' @description Any elements in the column that would be changed to NA if `as.numeric` is used on the column are returned. This is useful for quickly identifying only the "problem" entries of an ostensibly numeric column that is read in as a character.
#'
#' @param data (dataframe) object containing at least one column of supposed dates
#' @param col (character or numeric) name or column number of the column containing putative dates in the data object
#'
#' @return (character) vector of malformed dates
#' @export
#'
#' @examples
#' # Create dataframe with a numeric column where some entries would be coerced into NA
#' spp <- c('salmon', 'bass', 'halibut', 'eel')
#' ct <- c(1, '14x', '_23', 12)
#' fish <- data.frame('species' = spp, 'count' = ct)
#'
#' # Use `num_check()` to return only the entries that would be lost
#' num_check(data = fish, col = "count")
num_check <- function(data = NULL, col = NULL) {

  # Error out if anything is missing
  if(base::is.null(data) | base::is.null(col))
    stop("Data object name and column name must be provided")

  # Make data a dataframe
  df <- base::as.data.frame(data)

  # Remove NAs
  notNA <- base::subset(df, !base::is.na(df[, col]))

  # Identify "numbers" that are malformed
  bad <- base::subset(notNA,
                      base::is.na(
                        base::suppressWarnings(
                          base::as.numeric(notNA[, col]))))
  # Return a vector of bad numbers
  if(nrow(bad) != 0){
    base::unique(bad[, col])
    # Or a message saying all is well
  } else { message('No bad numbers.') }
}
