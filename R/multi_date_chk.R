#' @title Check Multiple Columns for Non-Dates.
#' @description Any elements in the columns that would be changed to NA if `as.Date()` is used are returned. This is useful for quickly identifying only the "problem" entries of ostensibly date columns that are read in as characters. This function is an extension of the `date_chk()` function in this package that deals with only a single column.
#'
#' @param data A data frame
#' @param col_vec A vector of column names from the provided data frame as a character vector
#'
#' @return A character vector
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
#' # Use `multi_date_chk()` to return only the entries that would be lost
#' helpR::multi_date_chk(data = sites, col_vec = c("first_visit", "second", "third"))
multi_date_chk <- function(data, col_vec){
  # For each column the column vector...
  for(col_opt in col_vec) {

    # Make sure data object is a dataframe
    df <- as.data.frame(data)

    # Remove NA entries
    notNA <- subset(df, !is.na(df[, col_opt]))

    # Identify rows that would be lost if `as.Date()` is used
    bad_df <- subset(notNA, is.na(as.Date(notNA[, col_opt])))

    # Get a vector of just the unique 'bad' entries
    bad_vec <- unique(bad_df[, col_opt])

    # If that vector is length 0 (i.e., no bad entries)...
    if(length(bad_vec) == 0){
      # ...print a message saying so
      print(paste0("For '", col_opt, "', ", length(bad_vec), " non-dates identified."))

      # If there are any bad entries...
    } else {
      # ... print the name of the column and all of the bad entries in it
      print(paste0("For '", col_opt, "', ", length(bad_vec), " non-dates identified: '", paste0(bad_vec, collapse = "' | '"), "'"))
    }
  }
}
