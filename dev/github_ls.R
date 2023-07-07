
# Load needed libraries
library(gh); library(stringr)

# Clear environment
rm(list = ls())

# Single Folder GitHub `ls` ----

# Identify all files in a single folder
github_ls_single <- function(repo = NULL, folder = NULL){
  
  # Error out for missing repo URL
  if(is.null(repo) == TRUE)
    stop("`repo` must be the URL for a GitHub repository (including 'github.com')")
  
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

# Define function
github_ls <- function(repo = NULL, folder = NULL, recursive = TRUE, quiet = FALSE){
  
  # Message top-level listing (if `quiet` is not TRUE)
  if(quiet != TRUE){ 
    message(ifelse(test = is.null(folder) == TRUE,
             yes = paste0("Listing top-level contents of ", repo),
             no = paste0("Listing contents of '", folder, "' in ", repo))) }
  
  # Identify contents of top-level / specified folder
  contents <- github_ls_single(repo = repo, folder = folder) %>%
    # And add some housekeeping columns we'll need later
    dplyr::mutate(listed = ifelse(type == "dir",
                                  yes = FALSE, no = NA),
                  path = ".")
  
  # If recursive listing is desired...
  if(recursive == TRUE){
    
    # While any folders are not identified
    while(FALSE %in% contents$listed){
      
      # Loop across contents
      for(w in 1:nrow(contents)){
        
        # Only operate on unlisted directories (otherwise skip)
        if(contents[w, ]$type == "dir" & contents[w, ]$listed == FALSE){
          
          # Message start of processing (if `quiet` is not TRUE)
          if(quiet != TRUE){ 
            message("Listing contents of directory '", contents[w, ]$name, "'") 
          }
          
          # Identify the full path to that folder
          sub_path <- paste0(contents[w, ]$path, "/", contents[w, ]$name)
          
          # Drop the leading "./" held to be human readable
          path_actual <- ifelse(stringr::str_sub(string = sub_path, 
                                                 start = 1, end = 2) == "./",
                                yes = gsub(pattern = "\\./", replacement = "", 
                                           x = sub_path),
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
          
        } # Close sublisting conditional
        
      } # Close `for` loop
      
    } # Close `while` loop
    
  } # Close recursive conditional
  
  # Wrangle that output slightly
  out_actual <- dplyr::select(contents, -listed)
  
  # Return that
  return(out_actual) }

# Invoke the function
github_ls(repo = "https://github.com/Traneptora/grimoire", recursive = T, quiet = F)

github_ls(repo = "https://github.com/Traneptora/grimoire", folder = "_posts", 
          recursive = T, quiet = F)
