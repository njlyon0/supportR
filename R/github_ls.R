#' @title List Objects in a Single Folder of a GitHub Repository
#' 
#' @description Accepts a GitHub repository URL and identifies all files in the specified folder. If no folder is specified, lists top-level repository contents. This function only works on repositories (public or private) to which you have access.
#' 
#' @param repo (character) full URL for a GitHub repository (including "github.com")
#' @param folder (NULL/character) either `NULL` or the name of the folder to list. If `NULL`, the top-level contents of the repository will be listed
#' 
#' @return (dataframe) two-column dataframe including (1) the names of the contents and (2) the type of each content item (e.g., file/directory/etc.)
#' 
#' @examples
#' \dontrun{
#' # List contents of the top-level of the `supportR` package repository
#' github_ls_single(repo = "https://github.com/njlyon0/supportR")
#' }
#' 
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



#' @title List Objects in a GitHub Repository
#' 
#' @description Accepts a GitHub repository URL and identifies all files in the specified folder. If no folder is specified, lists top-level repository contents. Recursive listing of sub-folders is supported by an additional argument. This function only works on repositories (public or private) to which you have access.
#' 
#' @param repo (character) full URL for a GitHub repository (including "github.com")
#' @param folder (NULL/character) either `NULL` or the name of the folder to list. If `NULL`, the top-level contents of the repository will be listed
#' @param recursive (logical) whether to recursively list contents (i.e., list contents of sub-folders identified within previously identified sub-folders)
#' @param quiet (logical) whether to print an informative message as the contents of each folder is being listed
#' 
#' @return (dataframe) three-column dataframe including (1) the names of the contents, (2) the type of each content item (e.g., file/directory/etc.), and (3) the full path from the starting folder to each item
#'
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
#' @export
#'
#' @examples
#' \dontrun{
#' # List complete contents of the `supportR` package repository
#' github_ls(repo = "https://github.com/njlyon0/supportR", recursive = TRUE, quiet = FALSE)
#' }
#' 
github_ls <- function(repo = NULL, folder = NULL, recursive = TRUE, quiet = FALSE){
  # Squelch visible bindings note
  type <- name <- listed <- NULL
  
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
                  path = ifelse(test = is.null(folder),
                                yes = ".",
                                no = folder))
  
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
          
          # Drop the leading "./" (for top-level items) to be more human readable
          path_actual <- ifelse(stringr::str_sub(string = sub_path, 
                                                 start = 1, end = 2) == "./",
                                yes = gsub(pattern = "\\./", replacement = "", 
                                           x = sub_path),
                                no = sub_path)
          
          # Identify contents of that folder
          sub_contents <- github_ls_single(repo = repo, folder = path_actual) %>%
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
