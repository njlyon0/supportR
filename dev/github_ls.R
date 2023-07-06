
# Load needed libraries
library(gh); library(stringr)


# Identify a repo URL
repo_url <- "https://github.com/Traneptora/grimoire"
folder <- "_includes"

# Strip out owner and repo name
repo_bits <- stringr::str_split_1(string = gsub(x = repo_url,
                                                pattern = "https\\:\\/\\/github.com\\/",
                                                replacement = ""),
                                  pattern = "/")

# Build first query
repo_query_raw <- paste("/repos", repo_bits[1], repo_bits[2], "contents", sep = "/")

# Assemble API query
repo_query <- ifelse(nchar(folder) > 0,
                     yes = paste0(repo_query_raw, "/", folder),
                     no = repo_query_raw)

# Process GitHub URL into GitHub API query format
repo_conts <- gh::gh(endpoint = repo_query)

# Make empty vectors for later use
repo_values <- NULL
repo_types <- NULL

# Identify files in that folder
for(k in 1:length(repo_conts)){
  
  # Strip out vector of file/directory names and types
  repo_values <- c(repo_values, repo_conts[[k]]$name)
  repo_types <- c(repo_types, repo_conts[[k]]$type)
  
}

# Create a dataframe from this
repo_df <- data.frame("name" = repo_values,
                      "type" = repo_types)

