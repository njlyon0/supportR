#' @title Check Multiple Columns for Non-Numbers
#' @description Any elements in the columns that would be changed to NA if `as.numeric` is used are returned. This is useful for quickly identifying only the "problem" entries of ostensibly numeric columns that are read in as characters. This function is an extension of the `num_check` function in this package that deals with only a single column.
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
  # Error out if anything is missing
  if(base::is.null(data) | base::is.null(col))
    stop("Data object name and column name must be provided")

  # Make an empty list to store the malformed dates in
  bad_list <- base::list()

  # Make sure the data object is a dataframe
  df <- base::as.data.frame(data)

  # For each column the column vector...
  for(col_opt in col_vec) {

    # Remove NA entries
    notNA <- base::subset(df, !base::is.na(df[, col_opt]))

    # Identify rows that would be lost if `as.numeric()` is used
    bad_df <- base::subset(notNA,
                           base::is.na(
                             base::suppressWarnings(
                               base::as.numeric(notNA[, col_opt]))))

    # Get a vector of just the unique 'bad' entries
    bad_vec <- base::unique(bad_df[, col_opt])

    # If that vector is length 0 (i.e., no bad entries)...
    if(base::length(bad_vec) == 0){
      # ...print a message saying so
      message("For '", col_opt, "', no non-numeric values identified.")

      # If there are any bad entries...
    } else {
      # ... print the name of the column and all of the bad entries in it
      message("For '", col_opt, "', ", length(bad_vec),
              " non-numbers identified: '",
              paste0(bad_vec, collapse = "' | '"), "'")# And add the values to a list
      bad_list[[col_opt]] <- bad_vec } }

  # Return the list
  return(bad_list)
}
