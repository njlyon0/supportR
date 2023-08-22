#' @title Check Columns for Non-Dates
#' 
#' @description Identifies any elements in the column(s) that would be changed to NA if `as.Date` is used on the column(s). This is useful for quickly identifying only the "problem" entries of ostensibly date column(s) that is/are read in as a character.
#'
#' @param data (dataframe) object containing at least one column of supposed dates
#' @param col (character or numeric) name(s) or column number(s) of the column(s) containing putative dates in the data object
#'
#' @return (list) malformed dates from each supplied column in separate list elements
#' @export
#'
#' @examples
# Make a dataframe to test the function
#' loc <- c("LTR", "GIL", "PYN", "RIN")
#' time <- c('2021-01-01', '2021-01-0w', '1990', '2020-10-xx')
#' time2 <- c('1880-08-08', '2021-01-02', '1992', '2049-11-01')
#' time3 <- c('2022-10-31', 'tomorrow', '1993', NA)
#'
#' # Assemble our vectors into a dataframe
#' sites <- data.frame('site' = loc, 'first_visit' = time, "second" = time2, "third" = time3)
#'
#' # Use `date_check()` to return only the entries that would be lost
#' date_check(data = sites, col = c("first_visit", "second", "third"))
date_check <- function(data = NULL, col = NULL) {

  # Error out if anything is missing
  if(base::is.null(data) | base::is.null(col))
    stop("Data object name and column name must be provided")

  # Make an empty list to store the malformed dates in
  bad_list <- base::list()
  
  # Make the data a dataframe
  df <- base::as.data.frame(data)

  # For each column the column vector...
  for(j in 1:length(col)) {
    
    # Identify a specific column option
    col_opt <- col[j]
    
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
  return(bad_list) }
