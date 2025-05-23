#' @title Compare Difference Between Two Vectors
#'
#' @description Reflexively compares two vectors and identifies (1) elements that are found in the first but not the second (i.e., "lost" components) and (2) elements that are found in the second but not the first (i.e., "gained" components). This is particularly helpful when manipulating a dataframe and comparing what columns are lost or gained between wrangling steps. Alternately it can compare the contents of two columns to see how two dataframes differ.
#'
#' @param old (vector) starting / original object
#' @param new (vector) ending / modified object
#' @param sort (logical) whether to sort the difference between the two vectors
#' @param return (logical) whether to return the two vectors as a 2-element list
#'
#' @return No return value (unless `return = TRUE`), called for side effects. If `return = TRUE`, returns a two-element list
#'
#' @export
#'
#' @examples
#' # Make two vectors
#' vec1 <- c("x", "a", "b")
#' vec2 <- c("y", "z", "a")
#'
#' # Compare them!
#' supportR::diff_check(old = vec1, new = vec2, return = FALSE)
#'
#' # Return the difference for later use
#' diff_out <- supportR::diff_check(old = vec1, new = vec2, return = TRUE)
#' diff_out
#'
diff_check <- function(old = NULL, new = NULL,
                       sort = TRUE, return = FALSE){

  # Error check for old vector
  if(is.null(old) || is.vector(old) != TRUE)
    stop("'old' must be supplied as a vector")
  
  # Same error checks for new
  if(is.null(new) || is.vector(new) != TRUE)
    stop("'new' must be supplied as a vector")
  
  # Coerce `sort` to TRUE if not a logical
  if(is.logical(sort) != TRUE){
    warning("'sort' must be either TRUE or FALSE. Defaulting to TRUE")
    sort <- TRUE }

  # Coerce `return` to FALSE if not a logical
  if(is.logical(return) != TRUE){
    warning("'return' must be either TRUE or FALSE. Defaulting to FALSE")
    return <- FALSE }

  # Identify what is lost (i.e., in old but not new)
  lost <- setdiff(x = old, y = new)

  # Identify what is gained (i.e., in new but not old)
  gained <- setdiff(x = new, y = old)

  # If sort is TRUE, sort both vectors
  if(sort == TRUE){
    lost <- sort(x = lost)
    gained <- sort(x = gained) }

  # Message what (if anything) was lost
  if(length(lost) == 0){
    message("All elements of old object found in new") } else {
      message("Following element(s) found in old object but not new: ")
      print(lost) }

  # Do the same for what was gained
  if(length(gained) == 0){
    message("All elements of new object found in old") } else {
      message("Following element(s) found in new object but not old: ")
      print(gained) }

  # If return is TRUE, return a two-element list
  if(return == TRUE){

    # Make list
    diff_list <- list("lost" = lost,
                      "gained" = gained)

    # Return it
    return(diff_list) }

}
