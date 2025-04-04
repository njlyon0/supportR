#' @title Safely Rename Columns in a Dataframe
#' 
#' @description Replaces specified column names with user-defined vector of new column name(s). This operation is done "safely" because it specifically matches each 'bad' name with its corresponding 'good' name and thus minimizes the risk of accidentally replacing the wrong column name.
#' 
#' @param data (dataframe or dataframe-like) object with column names that match the values passed to the `bad_names` argument
#' @param bad_names (character) vector of column names to replace in original data object. Order does not need to match data column order but *must* match the `good_names` vector order
#' @param good_names (character) vector of column names to use as replacements for data object. Order does not need to match data column order but *must* match the `good_names` vector order
#' 
#' @return (dataframe or dataframe-like) with renamed columns
#' 
#' @export
#' 
#' @examples
#' # Make a dataframe to demonstrate
#' df <- data.frame("first" = 1:3, "middle" = 4:6, "second" = 7:9)
#' 
#' # Invoke the function
#' safe_rename(data = df, bad_names = c("second", "middle"),
#'             good_names = c("third", "second"))
#' 
safe_rename <- function(data = NULL, bad_names = NULL, good_names = NULL){
  
  # Error check for data object
  if(is.null(data))
    stop("'data' must be specified")
  
  # Error check for bad names
  if(is.null(bad_names) || is.character(bad_names) != TRUE || all(bad_names %in% names(data)) != TRUE)
    stop("'bad_names' must be a character vector of names that all exist in 'data'")
  
  # Similar check for good names
  if(is.null(good_names) || is.character(good_names) != TRUE || length(good_names) != length(bad_names))
    stop("'good_names' must be a character vector with the same number of elements as 'bad_names'")
  
  # Duplicate data
  renamed_data <- data
  
  # Loop across provided bad names
  for(k in 1:length(bad_names)){
    
    # Identify single bad name and corresponding good name
    single_bad <- bad_names[k]
    single_good <- good_names[k]
    
    # Replace that bad name
    names(renamed_data)[names(renamed_data) == single_bad] <- single_good
    
  } # Close loop
  
  # Return the renamed data object
  return(renamed_data) }
