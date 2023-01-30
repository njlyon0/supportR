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
crop_tri <- function(data = NULL, drop_tri = "upper", drop_diag = FALSE){

  # Error out for missing data
  if(is.null(data)) stop("`data` must be provided")

  # Error out if data aren't symmetric
  if(nrow(data) != ncol(data))
    stop("`data` must be have same number of rows as columns (i.e., must be symmetric")

  # Error out if triangle argument isn't supported
  if(!drop_tri %in% c("upper", "lower"))
    stop("`drop_tri` must be one of 'upper' or 'lower'")

  # Coerce `drop_diag` to logical if it isn't
  if(methods::is(object = drop_diag, class2 = "logical") != TRUE){
    drop_diag <- FALSE
    message("`drop_diag` must be logical. Defaulting to FALSE") }

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
