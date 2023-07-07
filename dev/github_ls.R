
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
  repo_id <- setdiff(x = url_bits, y = c("https:", "", "www.", "github.com"))
  
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
rm(list = setdiff(ls(), c("github_ls_single")))

# Identify top-level contents of repo
contents <- github_ls_single(repo = "https://github.com/Traneptora/grimoire",
                             folder = NULL) %>%
  # And add some housekeeping columns we need later
  dplyr::mutate(listed = ifelse(type == "dir",
                                yes = FALSE, no = NA),
                path = ".")

# Check that out
contents

# While any folders are not identified
while(FALSE %in% contents$listed){
  
  # Loop across contents
  for(w in 1:nrow(contents)){
    
    # Only operate on unlisted directories (otherwise skip)
    if(contents[w, ]$type == "dir" & contents[w, ]$listed == FALSE){
      
      # Message start of processing
      message("Listing contents of directory '", contents[w, ]$name, "'")
      
      # Identify the full path to that folder
      sub_path <- paste0(contents[w, ]$path, "/", contents[w, ]$name)
      
      # Drop the leading "./" held to be human readable
      path_actual <- ifelse(stringr::str_sub(string = sub_path, start = 1, end = 2) == "./",
                            yes = gsub(pattern = "\\./", replacement = "", x = sub_path),
                            no = sub_path)
        
      # Identify contents of that folder
      sub_contents <- github_ls_single(repo = "https://github.com/Traneptora/grimoire",
                                   folder = path_actual) %>%
        # And add some housekeeping columns we need later
        dplyr::mutate(listed = ifelse(type == "dir",
                                      yes = FALSE, no = NA),
                      path = sub_path)
      
      # Attach it to the main contents object
      contents %<>%
        # Bind rows on the new information
        dplyr::bind_rows(y = sub_contents) %>%
        # Flip this folder's "listed" column entry to TRUE
        dplyr::mutate(listed = ifelse(test = (name == contents[w, ]$name),
                                      yes = TRUE,
                                      no = listed))
      
    } # Close conditional

  } # Close `for` loop
  
} # Close `while` loop

# Check out product of that
dplyr::glimpse(contents)

# Everything listed?
sort(unique(contents$listed))

# Wrangle that output slightly
out_actual <- dplyr::select(contents, -listed)

# Return that
# return(out_actual)


