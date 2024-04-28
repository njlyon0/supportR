#' @title Force Coerce to Numeric
#' 
#' @description Coerces a vector into a numeric vector and automatically silences `NAs introduced by coercion` warning. Useful for cases where non-numbers are known to exist in vector and their coercion to NA is expected / unremarkable. Essentially just a way of forcing this coercion more succinctly than wrapping `as.numeric` in `suppressWarnings`.
#'
#' @param x (non-numeric) vector containing elements to be coerced into class numeric
#'
#' @return (numeric) vector of numeric values
#' @export
#'
#' @examples
#' # Coerce a character vector to numeric without throwing a warning
#' force_num(x = c(2, "A", 4))
force_num <- function(x = NULL){
  
  # Error out for no argument specification
  if(is.null(x))
    stop("'x' argument must be defined")
  
  # Coerce to numeric
  y <- suppressWarnings(expr = as.numeric(x = x))
  
  # Return the fixed value
  return(y) }
