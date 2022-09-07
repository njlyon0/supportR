#' @title Read Data Package from Environmental Data Initiative by PASTA Identifier
#'
#' @description Reads in the data files and metadata (as an XML) stored on the Environmental Data Initiative's (EDI) data portal based on their PASTA identifier. Returns a list of the dataframes and this singular metadata file.
#'
#' @param pasta_id (character) PASTA identifier. Can be found in the EDI page for a given data product just above the "Code Generation" buttons for various coding languages.
#' @param data_type (character) file extension of the data tables (i.e., non-metadata parts of data package). Currently only supports CSV format.
#'
#' @return (list) containing one element per table in data product and the final element is the XML metadata. List names are the PASTA identifiers for each specific object (note that these differ slightly from the PASTA identifier this function requires)
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' # Read in a data product (on bees)
#' bees <- read_edi(pasta_id = "https://pasta.lternet.edu/package/eml/edi/1210/1", data_type = "csv")
#'
#' # Check the names
#' names(bees)
#'
read_edi <- function(pasta_id = NULL, data_type = "csv"){
  # Squelch visible bindings note
  data_name <- data_name_mod <- identifier <- NULL

  # Error out if URL isn't provided
  if(is.null(pasta_id) | !is.character(pasta_id))
    stop("EDI URL must be provided as a character")

  # Error for malformed PASTA identifiers
  if(!stringr::str_detect(string = pasta_id, pattern = "package/eml"))
    stop("Malformed PASTA identifier. Should be: 'https://pasta.lternet.edu/package/eml/edi/####/#' without trailing code for specific data product within data package")

  # Error out if data isn't a CSV
  if(data_type != "csv") stop("Data must be CSV format")

  # Make tempfile to read in
  temp_dest <- tempfile()

  # Attempt the download
  utils::download.file(url = pasta_id, destfile = temp_dest,
                method = "auto", quiet = TRUE)

  # Read that in
  pasta_sub_ids <- utils::read.csv(file = temp_dest)

  # Rip needed parts
  first_obj <- data.frame("data_name" = names(pasta_sub_ids))
  other_obj <- pasta_sub_ids[1]
  names(other_obj) <- "data_name"

  # Bind 'em together
  data_objects <- dplyr::bind_rows(first_obj, other_obj)

  # Prep a template value to fix the first object
  url_prefix <- paste0(gsub(pattern = "package/eml/edi",
                            replacement = "package/data/eml/edi",
                            x = data_objects[nrow(data_objects),]), "/")

  # Make a dumber version of the prefix
  prefix_simp <- gsub(pattern = "/|:", replacement = ".", x = url_prefix)

  # Tweak the object IDs
  object_ids <- data_objects %>%
    # Strip out good and bad data prefixes
    dplyr::mutate(data_name_mod = ifelse(
      test = stringr::str_detect(string = data_name, pattern = prefix_simp),
      yes = gsub(pattern = prefix_simp, replacement = "", x = data_name),
      no = data_name)) %>%
    # Replace with the correct template
    dplyr::mutate(identifier = ifelse(
      test = stringr::str_detect(string = data_name_mod,
                                 pattern = "https://"),
      yes = data_name_mod,
      no = paste0(url_prefix, data_name_mod))) %>%
    # Retain only fixed identifiers
    dplyr::select(identifier) %>%
    # Identify the XML files included with the data
    dplyr::mutate(data_type = dplyr::case_when(
      stringr::str_detect(string = identifier,
                          pattern = url_prefix) ~ "data",
      stringr::str_detect(string = identifier,
                          pattern = "metadata") ~ "xml",
      TRUE ~ 'xxx')) %>%
    # Drop unidentified file types
    dplyr::filter(data_type != "xxx")

  # Now make an empty list
  edi_list <- list()

  # And assign each file in the fixed PASTA identifier to that list
  for(id in object_ids$identifier){

    # Make a tempfile
    new_temp <- tempfile()

    # Attempt the download
    try(utils::download.file(url = id, destfile = new_temp,
                             method = "curl", quiet = TRUE))

    # If that doesn't work, try reading in a different way
    if (is.na(file.size(new_temp)))
      try(utils::download.file(url = id, destfile = new_temp,
                               method = "auto", quiet = TRUE))

    # Read in data objects
    if(object_ids$data_type[object_ids$identifier == id] == "data"){
      data <- utils::read.csv(file = new_temp) }

    # If XML, parse the XML instead
    if(object_ids$data_type[object_ids$identifier == id] == "xml"){
      data <- XML::xmlParse(file = new_temp) }

    # Whatever they are, add 'em to the list
    edi_list[[id]] <- data }

  # Return the now filled list
  return(edi_list) }
