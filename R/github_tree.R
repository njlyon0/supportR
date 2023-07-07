#' @title Create File Tree of a GitHub Repository
#' 
#' @description Recursively identifies all files in a GitHub repository and creates a file tree using the `data.tree` package to create a simple, human-readable visualization of the folder hierarchy. Folders can be specified for exclusion in which case the number of elements within them is listed but not the names of those objects. This function only works on repositories (public or private) to which you have access. 
#' 
#' @param repo (character) full URL for a github repository (including "github.com")
#' @param exclude (character) vector of folder names to exclude from the file tree (defaults to "docs" folder)
#' @param quiet (logical) whether to print an informative message as the contents of each folder is being listed and as the tree is prepared from that information
#' 
#' @return (node / R6) `data.tree` package object class
#' 
#' @importFrom magrittr %>%
#' @export
#' 
#' @examples
#' \dontrun{
#' # Create a file tree for the `supportR` package GitHub repository
#' github_tree(repo = "github.com/njlyon0/supportR", exclude = c("man", "docs", ".github"))
#' }
#' 
github_tree <- function(repo = NULL, exclude = c("docs"), quiet = FALSE){
  # Squelch visible bindings NOTE
  depth <- exclude_logi <- exclude_num <- exclude_parent <- NULL
  path <- pathString <- shallowest <- type <- name <- NULL
  
  # Run that on a repository
  repo_conts <- github_ls(repo = repo, folder = NULL, quiet = quiet) %>%
    # Complete the path by adding each file to the end of its path
    dplyr::mutate(path = paste0(path, "/", name)) %>%
    # Calculate the 'depth' (i.e., number of folders) of each path
    dplyr::group_by(path) %>%
    dplyr::mutate(depth = max(stringr::str_count(string = path, pattern = "/"))) %>%
    dplyr::ungroup()
  
  # Add some empty diagnostic columns and assign to a new object
  conts_v2 <- dplyr::mutate(repo_conts,
                            exclude_logi = FALSE,
                            exclude_parent = NA,
                            exclude_num = 0)
  
  # Identify all rows where excluded files are part of the path
  for(j in 1:length(exclude)){
    
    # Identify all contents of folders that are marked for exclusion
    conts_v2 %<>%
      # Identify whether the item is in the file path of an excluded folder
      dplyr::mutate(
        exclude_logi = ifelse(
          test = stringr::str_detect(string = path, pattern = exclude[j]) == T,
          yes = TRUE, no = exclude_logi)) %>%
      # Now count the number of files in that excluded folder
      dplyr::mutate(
        exclude_num = ifelse(
          test = stringr::str_detect(string = path, pattern = exclude[j]) == T,
          yes = sum(stringr::str_detect(string = path, pattern = exclude[j]) == T), 
          no = exclude_num),
        # And which excluded folder they belong to
        exclude_parent = ifelse(
          test = stringr::str_detect(string = path, pattern = exclude[j]) == T,
          yes = exclude[j], 
          no = exclude_parent))
    
  }
  
  # Identify all contents we unambiguously want to retain
  conts_keep <- dplyr::filter(conts_v2, exclude_logi == F)
  
  # Now wrangle to get a revized version of the excluded contents
  conts_drop_dirs <- conts_v2 %>%
    # Pare down to only content to drop & only folders
    dplyr::filter(exclude_logi == TRUE & type == "dir") %>% 
    # Identify the shallowest directory of the excluded folders
    dplyr::group_by(exclude_parent) %>%
    dplyr::mutate(shallowest = min(depth, na.rm = T)) %>%
    dplyr::ungroup() %>%
    # And filter to only the shallowest folder in each excluded parent
    dplyr::filter(depth == shallowest)
  
  # Make a duplicate of the excluded ones where we build in the number of dropped items
  conts_drop_items <- conts_drop_dirs %>%
    dplyr::mutate(path = paste0(path, "/", paste0(exclude_num, " excluded items")))
  
  # Recombine them into one dataframe
  conts_v3 <- dplyr::bind_rows(conts_keep, conts_drop_dirs, conts_drop_items) %>%
    # Pare down to only path column
    dplyr::select(path)
  
  # Message tree processing
  if(quiet != TRUE){ message("Preparing file tree") }
  
  # Identify maximum depth of folders
  max_depth <- base::max(stringr::str_count(string = conts_v3$path, pattern = "/")) + 1
  
  # Make into a dataframe where each path is a row and each column is a folder
  path_df <- tidyr::separate_wider_delim(data = conts_v3, cols = path,
                                         delim = '/', too_few = "align_start", 
                                         names = paste0("V", 1:max_depth)) %>%
    # Also retreieve the full path string
    dplyr::mutate(pathString = conts_v3$path) %>%
    # Oder by path
    dplyr::arrange(pathString)
  
  # Strip out folder paths
  repo_tree <- data.tree::as.Node(path_df)
  
  # Return this
  return(repo_tree) }
