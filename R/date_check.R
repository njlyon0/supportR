#' @title Check a Column for Non-Dates
#' @description Any elements in the column that would be changed to NA if `as.Date` is used on the column are returned. This is useful for quickly identifying only the "problem" entries of an ostensibly date column that is read in as a character.
#'
#' @param data (dataframe) object containing at least one column of supposed dates
#' @param col (character or numeric) name or column number of the column containing putative dates in the data object
#'
#' @return (character) vector of malformed dates
#' @export
#'
#' @examples
#' # Let's create some data that will be useful in demoing this function
#' loc <- c("LTR", "GIL", "PYN", "RIN")
#' time <- c('2021-01-01', '2021-01-0w', '1990', '2020-10-xx')
#' sites <- data.frame('site' = loc, 'visit' = time)
#'
#' # Now we can use our function to identify bad dates
#' date_check(data = sites, col = 'visit')
date_check <- function(data = NULL, col = NULL) {

  # Error out if anything is missing
  if(base::is.null(data) | base::is.null(col))
    stop("Data object name and column name must be provided")

  # Make the data a dataframe
  df <- base::as.data.frame(data)

  # Drop any NAs
  notNA <- base::subset(df, !base::is.na(df[, col]))

  # Identify only 'bad' (i.e., malformed) dates
  bad <- base::subset(notNA, base::is.na(base::as.Date(notNA[, col])))

  # If there are any bad dates, return them
  if(base::nrow(bad) != 0){
    base::unique(bad[, col])

    # If there are no bad dates, return a success message!
  } else { base::message('No bad dates.') }
}
