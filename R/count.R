#' @title Count Occurrences of Unique Vector Elements
#' 
#' @description Counts the number of occurrences of each element in the provided vector. Counting of NAs in addition to non-NA values is supported.
#' 
#' @param vec (vector) vector containing elements to count
#' 
#' @return (dataframe) two-column dataframe with as many rows as there are unique elements in the provided vector. First column is named "value" and includes the unique elements of the vector, second column is named "count" and includes the number of occurrences of each vector element.
#' 
#' @export
#' 
#' @examples
#' # Count instances of vector elements
#' count(vec = c(1, 1, NA, "a", 1, "a", NA, "x"))
#' 
count <- function(vec = NULL){
  
  # Error out for missing vector
  if(is.null(vec) == TRUE)
    stop("'vec' must be specified")
  
  # Error out for non-vector
  if(is.vector(vec) != TRUE)
    stop("'vec' must be a vector")
  
  # Identify unique bits
  unique_vec <- unique(vec)
  
  # Make a dataframe to store counts
  count_df <- data.frame("value" = unique_vec,
                         "count" = NA)
  
  # Count number of occurrences of each unique element
  for(bit in unique_vec){
    
    # Handle instances of NA in original vector
    if(is.na(bit) == TRUE){
      
      # Actual bit counting
      bit_ct <- sum(is.na(vec))
      
      # Add to dataframe
      count_df[is.na(count_df$value), ]$count <- bit_ct
      
      # If not NA...
    } else {
      
      no_empty_vec <- vec[!is.na(vec)]
      
      # Count occurrences
      bit_ct <- length(no_empty_vec[no_empty_vec == bit])
      
      # Add to dataframe
      count_df[(count_df$value == bit & !is.na(count_df$value)), ]$count <- bit_ct
      
    } # Close conditional
  } # Close loop
  
  # Return that dataframe
  return(count_df) }
