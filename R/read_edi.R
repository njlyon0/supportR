
# Housekeeping ----

# Link to my bee data on EDI
# https://portal.edirepository.org/nis/codeGeneration?packageId=edi.1210.1&statisticalFileType=r

# Load library
library(tidyverse); library(XML); library(methods)

# Clear environment
rm(list = ls())

# Non-function workflow ----

# Identify URL
pasta_link  <- "https://pasta.lternet.edu/package/eml/edi/1210/1"

# Make tempfile to read in
temp_dest <- tempfile()

# Attempt the download
try(download.file(url = pasta_link, destfile = temp_dest,
                  method = "auto", quiet = TRUE))

# Read that in
pasta_sub_ids <- read.csv(file = temp_dest)
pasta_sub_ids

# Rip needed parts
first_obj <- data.frame("data_name" = names(pasta_sub_ids))
other_obj <- pasta_sub_ids[1]
names(other_obj) <- "data_name"

# Bind 'em together
data_objects <- dplyr::bind_rows(first_obj, other_obj)
data_objects

# Prep a template value to fix the first object
url_prefix <- paste0(gsub(pattern = "package/eml/edi",
                          replacement = "package/data/eml/edi",
                          x = data_objects[nrow(data_objects),]), "/")

# Make a dumber version of the prefix
prefix_simp <- gsub(pattern = "/|:", replacement = ".", x = url_prefix)
prefix_simp

# Tweak the object IDs
object_ids <- data_objects %>%
  # Strip out good and bad data prefixes
  dplyr::mutate(data_name_mod = ifelse(
    test = stringr::str_detect(string = data_name, pattern = prefix_simp),
    yes = gsub(pattern = prefix_simp, replacement = "", x = data_name),
    no = data_name)) %>%
  # Replace with the correct template
  dplyr::mutate(identifier = ifelse(
    test = stringr::str_detect(string = data_name_mod, pattern = "https://"),
    yes = data_name_mod,
    no = paste0(url_prefix, data_name_mod))) %>%
  # Retain only fixed identifiers
  dplyr::select(identifier) %>%
  # Identify the XML files included with the data
  dplyr::mutate(data_type = dplyr::case_when(
    stringr::str_detect(string = identifier, pattern = url_prefix) ~
      "data",
    stringr::str_detect(string = identifier, pattern = "metadata") ~ "xml",
    TRUE ~ 'xxx')) %>%
  # Drop unidentified file types
  dplyr::filter(data_type != "xxx")

object_ids

# Now make an empty list
edi_list <- list()

# And assign each file in the fixed PASTA identifier to that list
for(id in object_ids$identifier[1:3]){

  # Make a tempfile
  new_temp <- tempfile()

  # Attempt the download
  try(download.file(url = id, destfile = new_temp,
                    method = "curl", quiet = TRUE))

  # If that doesn't work, try reading in a different way
  if (is.na(file.size(new_temp)))
    try(download.file(url = id, destfile = new_temp,
                      method = "auto", quiet = TRUE))

  # Read in data objects
  if(object_ids$data_type[object_ids$identifier == id] == "data"){
    data <- read.csv(file = new_temp) }

  # If XML, parse the XML instead
  if(object_ids$data_type[object_ids$identifier == id] == "xml"){
    data <- XML::xmlParse(file = new_temp) }

  # Whatever they are, add 'em to the list
  edi_list[[id]] <- data

}


str(edi_list)


# Function v2 ----

# Clear environment
rm(list = ls())

# Define function
read_edi <- function(pasta_id = NULL, data_type = "csv"){

  # Error out if URL isn't provided
  if(is.null(pasta_id)) stop("EDI URL must be provided")

  # Error out if data isn't a CSV
  if(data_type != "csv") stop("Data must be CSV format")

  # Warning/errors for malformatted pasta_ids?

# Make tempfile to read in
temp_dest <- tempfile()

# Attempt the download
try(download.file(url = pasta_id, destfile = temp_dest,
                  method = "auto", quiet = TRUE))

# Read that in
pasta_sub_ids <- read.csv(file = temp_dest)

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
    test = stringr::str_detect(string = data_name_mod, pattern = "https://"),
    yes = data_name_mod,
    no = paste0(url_prefix, data_name_mod))) %>%
  # Retain only fixed identifiers
  dplyr::select(identifier) %>%
  # Identify the XML files included with the data
  dplyr::mutate(data_type = dplyr::case_when(
    stringr::str_detect(string = identifier, pattern = url_prefix) ~
      "data",
    stringr::str_detect(string = identifier, pattern = "metadata") ~ "xml",
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
  try(download.file(url = id, destfile = new_temp,
                    method = "curl", quiet = TRUE))

  # If that doesn't work, try reading in a different way
  if (is.na(file.size(new_temp)))
    try(download.file(url = id, destfile = new_temp,
                      method = "auto", quiet = TRUE))

  # Read in data objects
  if(object_ids$data_type[object_ids$identifier == id] == "data"){
    data <- read.csv(file = new_temp) }

  # If XML, parse the XML instead
  if(object_ids$data_type[object_ids$identifier == id] == "xml"){
    data <- XML::xmlParse(file = new_temp) }

  # Whatever they are, add 'em to the list
  edi_list[[id]] <- data

}

# Return the now filled list
return(edi_list) }

# Invoke function
test <- read_edi(pasta_id = "https://pasta.lternet.edu/package/eml/edi/1210/1")

names(test)
str(test)

# Function v1 ----

rm(list = ls())

# Function equivalent
read_edi <- function(pasta_id = NULL, data_type = "csv"){

  # Error out if URL isn't provided
  if(is.null(pasta_id)) stop("EDI URL must be provided")

  # Error out if data isn't a CSV
  if(data_type != "csv") stop("Data must be CSV format")

  # Warning/errors for malformatted pasta_ids?


  # Create a temporary file
  destination <- tempfile()

  # Attempt the download
  # try(download.file(url = pasta_id, destfile = destination,
  #                   method = "curl", quiet = TRUE))

  # If that doesn't work, try reading in a different way
  # if (is.na(file.size(destination)))
  try(download.file(url = pasta_id, destfile = destination,
                    method = "auto", quiet = TRUE))

  # Read that in
  data <- read.csv(file = destination)

  # Return the data object
  return(data)

}


# Test it
test <- read_edi("https://pasta.lternet.edu/package/data/eml/edi/1210/1/c71bb3c137607da2d03d06342f9f1cad")

str(test)


# Test it again
test2 <- read_edi("https://pasta.lternet.edu/package/eml/edi/189/2")
test2



  # dplyr::mutate(data_name = gsub(pattern = "https...",
  #                                replacement = "https://",
  #                                x = data_name)) %>%
  # dplyr::mutate(data_name = gsub(pattern = ".edu.package.data.eml.edi.",
  #                                replacement = ".edu/package/data/eml/edi/",
  #                                x = data_name))



# dplyr::mutate(data_name = gsub(pattern = "",
#                                replacement = "",
#                                x = data_name))

object_ids






# Tweak that object
test2_xtra <- data.frame("data_name" = test2[1])

test2_mod <- test2_xtra %>%
  dplyr::mutate(data_id = gsub(pattern = "https...", replacement = "https://", x = data_name))


test2_mod <- data.frame("data_name" =
                          gsub(pattern = "https...pasta.lternet.edu.package.data.eml.edi.1210.1.",
                               replacement = "https...pasta.lternet.edu.package.data.eml.edi.1210.1.",
                               x = test2[1]))
test2_mod



