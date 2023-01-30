#' @title Read Data Package Metadata from Environmental Data Initiative (EDI) by PASTA Identifier
#'
#' @description Reads in only the metadata (as an XML) stored on the Environmental Data Initiative's (EDI) data portal based on the data package's PASTA identifier. Returns only the metadata file. To read in the data and metadata, see `helpR::read_edi`.
#'
#' @param pasta_id (character) PASTA identifier. Can be found in the EDI page for a given data product just above the "Code Generation" buttons for various coding languages.
#'
#' @return (list) containing one element per table in data product and the final element is the XML metadata. List names are the PASTA identifiers for each specific object (note that these differ slightly from the PASTA identifier this function requires)
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' # Read in a data product (on bees)
#' bees_meta <- read_edi_meta(pasta_id = "https://pasta.lternet.edu/package/eml/edi/1210/1")
#'
#' # Check the structure
#' str(bees_meta)
#'
read_edi_meta <- function(pasta_id = NULL){
  # Squelch visible bindings note
  . <- NULL

  # Error out if URL isn't provided
  if(is.null(pasta_id) | !is.character(pasta_id))
    stop("EDI URL must be provided as a character")

  # Error for malformed PASTA identifiers
  if(!stringr::str_detect(string = pasta_id, pattern = "package/eml"))
    stop("Malformed PASTA identifier. Should be: 'https://pasta.lternet.edu/package/eml/edi/####/#' without trailing code for specific data product within data package")

  # Make tempfile to read in
  temp_dest <- tempfile()

  # Attempt the download
  utils::download.file(url = pasta_id, destfile = temp_dest,
                method = "auto", quiet = TRUE)

  # Read that in
  pasta_sub_ids <- utils::read.csv(file = temp_dest)

  # Retrieve the relevant PASTA identifier
  meta_pasta <- pasta_sub_ids %>%
    # Rename this column (it defaults to the first data objects' name)
    dplyr::rename(pasta_id = names(.)) %>%
    # Filter to only metadata
    dplyr::filter(stringr::str_detect(string = pasta_id,
                                      pattern = "metadata"))

  # Make a tempfile
  new_temp <- tempfile()

  # Attempt the download
  try(utils::download.file(url = meta_pasta[,1], destfile = new_temp,
                           method = "curl", quiet = TRUE))

  # If that doesn't work, try reading in a different way
  if (is.na(file.size(new_temp))){
    try(utils::download.file(url = meta_pasta[,1], destfile = new_temp,
                             method = "auto", quiet = TRUE)) }

  # Parse the downloaded XML back into R
  metadata <- XML::xmlParse(file = new_temp)

  # Return that
  return(metadata) }
