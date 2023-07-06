
# Load needed libraries
library(gh); library(stringr)

# Clear environment
rm(list = ls())

# Single Folder GitHub `ls` ----

# Identify all files in a single folder
github_ls_single <- function(repo, folder = NULL){
  
  # Break URL into its component parts
  url_bits <- stringr::str_split_1(string = repo, pattern = "/")
  
  # Error out if "github.com" isn't in the URL
  if(!"github.com" %in% url_bits)
    stop("`repo` must be the URL for a GitHub repository (including 'github.com')")
  
  # Drop unwanted parts of that
  repo_id <- setdiff(x = url_bits, y = c("https:", "", "github.com"))
  
  # Assemble an API query with this information
  query_raw <- paste("/repos", repo_id[1], repo_id[2], "contents", sep = "/")
  
  # Add on the folder if one was provided
  query_actual <- ifelse(test = is.null(folder) == TRUE,
                         yes = query_raw,
                         no = paste0(query_raw, "/", folder))
  
  # Make the query to the GitHub API
  repo_contents <- gh::gh(endpoint = query_actual)
  
  # Make empty vectors for later use
  repo_names <- NULL
  repo_types <- NULL
  
  # Identify files in that folder
  for(k in 1:length(repo_contents)){
    
    # Strip out vector of file/directory names and types
    repo_names <- c(repo_names, repo_contents[[k]]$name)
    repo_types <- c(repo_types, repo_contents[[k]]$type)
    
  }
  
  # Create a dataframe from this
  repo_df <- data.frame("name" = repo_names,
                        "type" = repo_types)
  
  # Return that dataframe
  return(repo_df) }

# Invoke the function
github_ls_single(repo = "https://github.com/Traneptora/grimoire")
github_ls_single(repo = "https://github.com/Traneptora/grimoire", folder = "_posts")

# Recursive file ls ----

# Clear environment again
rm(list = ls())




