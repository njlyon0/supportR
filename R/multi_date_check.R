#' @title Check Multiple Columns for Non-Dates
#' @description Any elements in the columns that would be changed to NA if `as.Date` is used are returned. This is useful for quickly identifying only the "problem" entries of ostensibly date columns that are read in as characters. This function is an extension of the `date_check` function in this package that deals with only a single column.
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
  # Error out if anything is missing
  if(base::is.null(data) | base::is.null(col))
    stop("Data object name and column name must be provided")

  # Make an empty list to store the malformed dates in
  bad_list <- base::list()

  # Make sure data object is a dataframe
  df <- base::as.data.frame(data)

  # For each column the column vector...
  for(col_opt in col_vec) {

    # Remove NA entries
    notNA <- base::subset(df, !base::is.na(df[, col_opt]))

    # Identify rows that would be lost if `as.Date()` is used
    bad_df <- base::subset(notNA, is.na(base::as.Date(notNA[, col_opt])))

    # Get a vector of just the unique 'bad' entries
    bad_vec <- base::unique(bad_df[, col_opt])

    # If that vector is length 0 (i.e., no bad entries)...
    if(base::length(bad_vec) == 0){
      # ...print a message saying so
      message("For '", col_opt, "', no non-dates identified.")

      # If there are any bad entries...
    } else {
      # ... print the name of the column and all of the bad entries in it
      message("For '", col_opt, "', ", length(bad_vec), " non-dates identified: '", paste0(bad_vec, collapse = "' | '"), "'")

      # And add the values to a list
      bad_list[[col_opt]] <- bad_vec } }

  # Return the list
  return(bad_list)
}
