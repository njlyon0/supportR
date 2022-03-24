#' @title Check Multiple Column for Non-Numbers.
#' @description Any elements in the columns that would be changed to NA if `as.numeric()` is used are returned. This is useful for quickly identifying only the "problem" entries of ostensibly numeric columns that are read in as characters. This function is an extension of the `num_chk()` function in this package that deals with only a single column.
#'
#' @param data A data frame
#' @param col_vec A vector of column names from the provided data frame as a character vector
#'
#' @return A character vector
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
#' # Use `multi_num_chk()` to return only the entries that would be lost
#' helpR::multi_num_chk(data = fish, col_vec = c("count", "num_col2", "third_count"))
multi_num_chk <- function(data, col_vec){
  ## data = A data frame
  ## col_vec = vector of column names to check

  # For each column the column vector...
  for(col_opt in col_vec) {

    # Remove NA entries
    notNA <- subset(data, !is.na(data[, col_opt]))

    # Identify rows that would be lost if `as.numeric()` is used
    bad_df <- subset(notNA, is.na(suppressWarnings(as.numeric(notNA[, col_opt]))))

    # Get a vector of just the unique 'bad' entries
    bad_vec <- unique(bad_df[, col_opt])

    # If that vector is length 0 (i.e., no bad entries)...
    if(length(bad_vec) == 0){
      # ...print a message saying so
      print(paste0("For '", col_opt, "', ", length(bad_vec), " non-numbers identified."))

      # If there are any bad entries...
    } else {
      # ... print the name of the column and all of the bad entries in it
      print(paste0("For '", col_opt, "', ", length(bad_vec), " non-numbers identified: '",
                   paste0(bad_vec, collapse = "' | '"), "'"))
    }
  }
}
