#' @title Melt an Array into a Dataframe
#'
#' @description Melts an array of dimensions x, y, and z into a dataframe containing columns `x`, `y`, `z`, and `value` where `value` is whatever was stored in the array at those coordinates.
#'
#' @param array (array) array object to melt into a dataframe
#'
#' @return (dataframe) object containing the "flattened" array in dataframe format
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' # First we need to create an array to melt
#' ## Make data to fill the array
#' vec1 <- c(5, 9, 3)
#' vec2 <- c(10:15)
#'
#' ## Create dimension names (x = col, y = row, z = which matrix)
#' x_vals <- c("Col_1","Col_2","Col_3")
#' y_vals <- c("Row_1","Row_2","Row_3")
#' z_vals <- c("Mat_1","Mat_2")
#'
#' ## Make an array from these components
#' g <- array(data = c(vec1, vec2), dim = c(3, 3, 2),
#'            dimnames = list(x_vals, y_vals, z_vals))
#'
#' ## "Melt" the array into a dataframe
#' array_melt(array = g)
#'
array_melt <- function(array = NULL){

  # Squelch visible bindings note
  . <- z <- y_raw <- y <- NULL

  # Error out if `array` is null or isn't an array
  if(is.null(array) | methods::is(object = array, class2 = "array") != TRUE)
    stop("`array` must be provided and must be an array")

  df <- array %>%
    # Flatten array to a list (margin = 3 because each z should be in a separate list element)
    purrr::array_tree(margin = 3) %>%
    # Make each list element into a dataframe
    purrr::map(.f = as.data.frame) %>%
    # Bind each list element together and retain their z names
    dplyr::bind_rows(.id = "z") %>%
    # Get the column names (y) into a column (note that they are stored as rownames because of our last operation)
    dplyr::mutate("y_raw" = rownames(.), .after = z) %>%
    # Clean up the "y" column
    dplyr::mutate(
      "y" = stringr::str_sub(string = y_raw, start = 1,
                             end = (nchar(y_raw) - 4))) %>%
    # Drop the old version of the "y" column
    dplyr::select(-y_raw) %>%
    # Pivot longer
    tidyr::pivot_longer(cols = c(-z,-y),
                        names_to = "x",
                        values_to = "value") %>%
    # Make it a dataframe
    as.data.frame()

  # Return the dataframe
  return(df) }
