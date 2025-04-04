#' @title Crop a Triangle from Data Object
#'
#' @description Accepts a symmetric data object and replaces the chosen triangle with NAs. Also allows user to choose whether to keep or drop the diagonal of the data object
#'
#' @param data (dataframe, dataframe-like, or matrix) symmetric data object to remove one of the triangles from
#' @param drop_tri (character) which triangle to replace with NAs, either "upper" or "lower"
#' @param drop_diag (logical) whether to drop the diagonal of the data object (defaults to FALSE)
#'
#' @return (dataframe or dataframe-like) data object with desired triangle removed and either with or without the diagonal
#'
#' @export
#' 
#' @examples
#' # Define a simple matrix wtih symmetric dimensions
#' mat <- matrix(data = c(1:2, 2:1), nrow = 2, ncol = 2)
#' 
#' # Crop off it's lower triangle
#' supportR::crop_tri(data = mat, drop_tri = "lower", drop_diag = FALSE)
#' 
crop_tri <- function(data = NULL, drop_tri = "upper", drop_diag = FALSE){

  # Error checks for data
  if(is.null(data) || nrow(data) != ncol(data))
    stop("'data' must be provided and have same number of rows as columns (i.e., must be symmetric)")
  
  # Error checks for drop triangle argument
  if(is.null(drop_tri) || length(drop_tri) != 1 || drop_tri %in% c("upper", "lower") != TRUE)
    stop("'drop_tri' must be provided as one of either 'upper' or 'lower'")
  
  # Coerce `drop_diag` to logical if it isn't
  if(is.logical(drop_diag) != TRUE){
    warning("'drop_diag' must be logical. Defaulting to FALSE")
    drop_diag <- FALSE }

  # Duplicate data
  crop_data <- data

  # Cut triangle
  if(drop_tri == "upper"){
    crop_data[upper.tri(x = crop_data, diag = drop_diag)] <- NA
  }
  if(drop_tri == "lower"){
    crop_data[lower.tri(x = crop_data, diag = drop_diag)] <- NA
  }

  # Return it
  return(crop_data) }
