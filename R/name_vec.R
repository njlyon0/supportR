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
name_vec <- function(content = NULL, name = NULL){
  
  # Error checks for content
  if(is.null(content))
    stop("'content' must be specified")
  
  # Error checks for name
  if(is.null(name) || length(name) != length(content))
    stop("'name' must be specified and have the same length as 'content'")
  
  # Construct the named vector
  names(content) <- name
  
  # Return that
  return(content) }
