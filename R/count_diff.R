#' @title Count Difference in Occurrences of Vector Elements
#' 
#' @description Counts the number of occurrences of each element in both provided vectors and then calculates the difference in that count between the first and second input vector. Counting of NAs in addition to non-NA values is supported.
#' 
#' @param vec1 (vector) first vector containing elements to count
#' @param vec2 (vector) second vector containing elements to count
#' @param what (vector) optional argument for what element(s) to count. If left `NULL`, defaults to all unique elements found in either vector
#' 
#' @return (dataframe) four-column dataframe with as many rows as there are unique elements across both specified vectors or as the number of elements passed to 'what'. First column is named "value" and includes the unique elements of the vector, second and third columns are named "vec1_count" and "vec2_count" respectively and include the number of occurrences of each vector element in each vector. Final column is "diff" and the difference in the count of each element between the first and second input vectors
#' 
#' @importFrom magrittr %>%
#' @export
#' 
#' @examples
#' # Define two vectors
#' x1 <- c(1, 1, NA, "a", 1, "a", NA, "x")
#' x2 <- c(1, "a", "x", "b")
#' 
#' # Count difference in number of NAs between the two vectors
#' supportR::count_diff(vec1 = x1, vec2 = x2, what = NA)
#' 
#' # Count difference in all values between the two
#' supportR::count_diff(vec1 = x1, vec2 = x2)
#' 
count_diff <- function(vec1, vec2, what = NULL){
  # Squelch visible bindings note
  count.x <- count.y <- value <- NULL
  
  # Count all items in each vector
  ## Do this first so error checks on 'vec1' and 'vec2' get done early
  n1 <- supportR::count(vec = vec1)
  n2 <- supportR::count(vec = vec2)
  
  # If 'what' is NULL, make it the unique contents of both vectors
  if(is.null(what)){ what <- unique(c(vec1, vec2)) }
  
  # Error if 'what' is not a vector
  if(is.vector(what) != TRUE || length(what) < 1)
    stop("'what' must be a vector of at least one element")
  
  # Combine these data objects
  full_n <- dplyr::full_join(x = n1, y = n2, by = "value") %>% 
    # Fill NA counts with zeros
    dplyr::mutate(dplyr::across(.cols = dplyr::starts_with("count."),
                                .fns = ~ ifelse(test = is.na(.),
                                                yes = 0, no = .))) %>% 
    # Calculate difference
    dplyr::mutate(diff = count.x - count.y) %>% 
    # Rename columns
    dplyr::rename(vec1_count = count.x,
                  vec2_count = count.y)
  
  # Subset to only desired items
  sub_n <- dplyr::filter(.data = full_n, value %in% what)
  
  # Return warning if 'what' is not found in either vector
  if(nrow(sub_n) == 0)
    warning("No values found in either vector matching 'what' specification")
  
  # Return that
  return(sub_n) }
