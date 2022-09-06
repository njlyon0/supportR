# https://portal.edirepository.org/nis/codeGeneration?packageId=edi.1210.1&statisticalFileType=r

# Identify URL
inUrl1  <- "https://pasta.lternet.edu/package/data/eml/edi/1210/1/c71bb3c137607da2d03d06342f9f1cad"

# Make tempfile to read in
infile1 <- tempfile()

# Attempt the download
try(download.file(url = inUrl1, destfile = infile1, method = "curl"))

# If that doesn't work, try reading in a different way
if (is.na(file.size(infile1)))
  download.file(url = inUrl1, destfile = infile1, method = "auto")

# Read that in
data <- read.csv(file = infile1)
str(data)



# Function equivalent
read_edi <- function(pasta_id = NULL, data_type = "csv"){

  # Error out if URL isn't provided
  if(is.null(pasta_id)) stop("EDI URL must be provided")

  # Error out if data isn't a CSV
  if(data_type != "csv") stop("Data must be CSV format")

  # Create a temporary file
  destination <- tempfile()

  # Attempt the download
  try(download.file(url = pasta_id, destfile = destination,
                    method = "curl", quiet = TRUE))

  # If that doesn't work, try reading in a different way
  if (is.na(file.size(infile1)))
    download.file(url = pasta_id, destfile = destination,
                  method = "auto", quiet = TRUE)

  # Read that in
  data <- read.csv(file = destination)

  # Return the data object
  return(data)

}


# Test it
test <- read_edi("https://pasta.lternet.edu/package/data/eml/edi/1210/1/c71bb3c137607da2d03d06342f9f1cad")

str(test)


# Test it again
test2 <- read_edi("https://pasta.lternet.edu/package/eml/edi/1210/1")

test2

