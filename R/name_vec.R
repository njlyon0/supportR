#' @title Create Named Vector
#'
#' @description Create a named vector in a single line without either manually defining names at the outset (e.g., `c("name_1" = 1, "name_2" = 2, ...`) or spending a second line to assign names to an existing vector (e.g., `names(vec) <- c("name_1", "name_2", ...)`). Useful in cases where you need a named vector within a pipe and don't want to break into two pipes just to define a named vector (see `tidyr::separate_wider_position`)
#' 
#' @param content (vector) content of vector
#' @param name (vector) names to assign to vector (must be in same order)
#' 
#' @return (named vector) vector with contents from the `content` argument and names from the `name` argument
#' 
#' @export
#' 
#' @examples
#' # Create a named vector
#' name_vec(content = 1:10, name = paste0("text_", 1:10))
#' 
name_vec <- function(content, name){
  
  # Error out if content & name are not the same length
  if(length(x = content) != length(x = name))
    stop("Vector content and names must be the same length")
  
  # Construct the named vector
  names(content) <- name
  
  # Return that
  return(content) }
