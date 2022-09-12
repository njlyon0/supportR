#' @title Compare Difference Between two Vectors
#'
#' @description Reflexively compares two vectors and identifies (1) elements that are found in the first but not the second (i.e., "lost" components) and (2) elements that are found in the second but not the first (i.e., "gained" components). This is particularly helpful when manipulating a dataframe and comparing what columns are lost or gained between wrangling steps. Alternately it can compare the contents of two columns to see how two dataframes differ.
#'
#' @param old (vector) starting / original object
#' @param new (vector) ending / modified object
#'
#' @export
#'
diff_chk <- function(old = NULL, new = NULL){

  # Error out if either is null
  if(is.null(old) | is.null(new))
    stop("Both arguments must be specified")

  # Error out if either is not a vector
  if(!is.vector(old) | !is.vector(new))
    stop("Both arguments must be vectors")

  # Identify what is lost (i.e., in old but not new)
  lost <- base::setdiff(x = old, y = new)

  # Identify what is gained (i.e., in new but not old)
  gained <- base::setdiff(x = new, y = old)

  # Message what (if anything) was lost
  if(length(lost) == 0){
    message("All elements of of old object found in new") } else {
    message("Following element(s) found in old object but not new: ")
    print(lost) }

  # Do the same for what was gained
  if(length(gained) == 0){
    message("All elements of of new object found in old") } else {
      message("Following element(s) found in new object but not old: ")
      print(gained) }
  }
