#' @title Check Columns for Non-Numbers
#' 
#' @description Identifies any elements in the column(s) that would be changed to NA if `as.numeric` is used on the column(s). This is useful for quickly identifying only the "problem" entries of ostensibly numeric column(s) that is/are read in as a character.
#'
#' @param data (dataframe) object containing at least one column of supposed numbers
#' @param col (character or numeric) name(s) or column number(s) of the column(s) containing putative numbers in the data object
#'
#' @return (list) malformed numbers from each supplied column in separate list elements
#' @export
#'
#' @examples
#' # Create dataframe with a numeric column where some entries would be coerced into NA
#' spp <- c("salmon", "bass", "halibut", "eel")
#' ct <- c(1, "14x", "_23", 12)
#' ct2 <- c("a", "2", "4", "0")
#' ct3 <- c(NA, "Y", "typo", "2")
#' fish <- data.frame("species" = spp, "count" = ct, "num_col2" = ct2, "third_count" = ct3)
#'
#' # Use `num_check()` to return only the entries that would be lost
#' num_check(data = fish, col = c("count", "num_col2", "third_count"))
#' 
num_check <- function(data = NULL, col = NULL) {

  # Error out if anything is missing
  if(is.null(data) == TRUE)
    stop("Data object name must be provided")
  
  # Error out if column(s) is/are missing
  if(is.null(col) == TRUE)
    stop("Column name(s) must be provided")
  
  # Error out for non-dataframe data
  if(any(class(data) == "data.frame") != TRUE)
    stop("Data object must be dataframe-like")
  
  # Make an empty list to store the malformed dates in
  bad_list <- base::list()
  
  # Make data a dataframe
  df <- base::as.data.frame(data)

  # For each supplied column...
  for(k in 1:length(col)) {
    
    # Identify the specific column option
    col_opt <- col[k]
    
    # Remove NA entries
    not_na <- base::subset(df, !base::is.na(df[, col_opt]))
    
    # Identify rows that would be lost if `as.numeric()` is used
    bad_df <- base::subset(not_na,
                           base::is.na(supportR::force_num(x = not_na[, col_opt])))
    
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
  return(bad_list) }
