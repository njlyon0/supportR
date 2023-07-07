
# Load local package contents
devtools::load_all()

# Make sure `github_ls` is part of that
?github_ls

# Load some bonus libraries
librarian::shelf(tidyverse, stringr, data.tree, magrittr)

# Clear environment
rm(list = ls())

# Run that on a repository
repo_conts <- github_ls(repo = "github.com/njlyon0/supportR", folder = NULL) %>%
  # Complete the path by adding each file to the end of its path
  dplyr::mutate(path = paste0(path, "/", name)) %>%
  # Calculate the 'depth' (i.e., number of folders) of each path
  dplyr::group_by(path) %>%
  dplyr::mutate(depth = max(stringr::str_count(string = path, pattern = "/"))) %>%
  dplyr::ungroup()

# Check the structure of that
dplyr::glimpse(repo_conts)

# Create a vector of folders to exclude from the ToC
exclude_vec <- c("man", "docs", ".github")

# Add some empty diagnostic columns and assign to a new object
conts_v2 <- dplyr::mutate(repo_conts,
                          exclude = FALSE,
                          exclude_parent = NA,
                          exclude_num = 0)

# Identify all rows where excluded files are part of the path
for(j in 1:length(exclude_vec)){
  
  # Identify all contents of folders that are marked for exclusion
  conts_v2 %<>%
    # Identify whether the item is in the file path of an excluded folder
    dplyr::mutate(
      exclude = ifelse(
        test = stringr::str_detect(string = path, pattern = exclude_vec[j]) == T,
        yes = TRUE, no = exclude)) %>%
  # Now count the number of files in that excluded folder
  dplyr::mutate(
      exclude_num = ifelse(
        test = stringr::str_detect(string = path, pattern = exclude_vec[j]) == T,
        yes = sum(stringr::str_detect(string = path, pattern = exclude_vec[j]) == T), 
        no = exclude_num),
      # And which excluded folder they belong to
      exclude_parent = ifelse(
        test = stringr::str_detect(string = path, pattern = exclude_vec[j]) == T,
        yes = exclude_vec[j], 
        no = exclude_parent))
  
}

# Check that out
dplyr::glimpse(conts_v2)
## view(conts_v2)

# Identify all contents we unambiguously want to retain
conts_keep <- dplyr::filter(conts_v2, exclude == F)

# Now wrangle to get a revized version of the excluded contents
conts_drop_dirs <- conts_v2 %>%
  # Pare down to only content to drop & only folders
  dplyr::filter(exclude == TRUE & type == "dir") %>% 
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

# Re-check structure
dplyr::glimpse(conts_v3)
## view(conts_v3)

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

# Check structure
dplyr::glimpse(path_df)
## view(path_df)

# Strip out folder paths
repo_tree <- data.tree::as.Node(path_df)

# Check that out
repo_tree















# Process that to remove the folders to be excluded
conts_v3 <- conts_v2 %>%
  # Group by excluded parent folder
  dplyr::group_by(exclude_parent) %>%
  # Keep only non-excluded contents OR the shallowest folders that are excluded
  dplyr::filter(exclude == FALSE | 
                  (exclude == TRUE & type == "dir" & 
                     exclude_num == min(exclude_num, na.rm = T)))
 
# Check that out
dplyr::glimpse(conts_v3)
## view(conts_v3)





# Identify maximum depth of folders
max_depth <- base::max(stringr::str_count(string = repo_conts$path, pattern = "/")) + 1



# Make into a dataframe where each path is a row and each column is a folder
path_df <- tidyr::separate_wider_delim(data = repo_conts, cols = path,
                            delim = '/', too_few = "align_start", 
                            names = paste0("V", 1:max_depth)) %>%
  # Also retreieve the full path string
  dplyr::mutate(pathString = repo_conts$path)

# Check structure
dplyr::glimpse(path_df)

# Add an empty exclude column and assign to a new object
path_v2 <- dplyr::mutate(path_df, exclude = FALSE)

# Identify all rows where excluded files are part of the path
for(j in 1:length(exclude_vec)){
  
  # Identify all contents of folders that are marked for exclusion
  path_v2 %<>%
    dplyr::mutate(exclude = ifelse(
      test = stringr::str_detect(string = pathString, pattern = exclude_vec[j]) == T,
      yes = TRUE, no = exclude))
  
}

# Check structure
dplyr::glimpse(path_v2)
## view(path_v2)

# Wrangle that object
path_v3 <- path_v2 %>%
  # Drop excluded objects
  dplyr::filter(exclude == FALSE)

# Check structure
dplyr::glimpse(path_v3)
## view(path_v3)





# 'Basement' ----


# # Process it into just the file paths
# repo_paths <- repo_conts %>%
#   dplyr::pull(var = path)
# 
# # Identify maximum depth of folders
# max_depth <- base::max(stringr::str_count(string = repo_paths, pattern = "/")) + 1

# Wrangle the path object as needed for `data.tree::as.Node`
# path_df <- as.data.frame(repo_paths) %>%
#   # Make into a dataframe where each path is a row and each column is a folder
#   tidyr::separate_wider_delim(cols = repo_paths, delim = '/', too_few = "align_start",
#                               names = paste0("V", 1:max_depth)) %>%
#   # Also re-gain the full path string
#   dplyr::mutate(pathString = repo_paths)

# Check structure of that
dplyr::glimpse(path_df)

# Add an empty exclude column and assign to a new object
path_v2 <- dplyr::mutate(path_df, exclude = FALSE)
  
# Identify all rows where excluded files are part of the path
for(j in 1:length(exclude_vec)){
  
  # Check whether that file is in a folder marked for exclusion
  path_v2 %<>%
    dplyr::mutate(exclude = ifelse(
        test = stringr::str_detect(string = pathString, pattern = exclude_vec[j]) == T,
        yes = TRUE, no = exclude))
  
}

# Check structure
dplyr::glimpse(path_v2)
## view(path_v2)

# Wrangle that object
path_v3 <- path_v2 %>%
  # Drop top-level folder 'name' (is placeholder ".")
  dplyr::select(-V1) %>%
  # Pivot to long format
  tidyr::pivot_longer(cols = dplyr::starts_with("V")) %>%
  # Drop missing values
  dplyr::filter(!is.na(value)) %>%
  # Make the name column numeric only
  dplyr::mutate(folder_num = stringr::str_sub(string = name, 
                                              start = 2, end = nchar(name))) %>%
  # Filter to only non-excluded or highest folder in hierarchy
  dplyr::group_by(value) %>%
  dplyr::filter(exclude == FALSE | (exclude == TRUE & folder_num == max(folder_num))) %>%
  dplyr::ungroup()

# Check structure
dplyr::glimpse(path_v3)
## view(path_v3)



# 
# # Wrangle that to exclude folders marked for exclusion
# path_df_actual <- path_df %>%
#   # Drop top-level folder 'name' (is placeholder ".")
#   dplyr::select(-V1) %>%
#   # Pivot to long format
#   tidyr::pivot_longer(cols = dplyr::starts_with("V")) %>%
#   # Drop NAs
#   dplyr::filter(!is.na(value)) %>%
#   # Count entries at each level of the hierarchy
#   dplyr::group_by(name, value) %>%
#   dplyr::mutate(item_count = sum(!is.na(value), na.rm = T)) %>%
#   dplyr::ungroup() %>%
#   # Drop non-unique rows
#   dplyr::distinct()
# 
# 
#   # For folders in the exclude vector, swap out the item count for the actual values
#   # dplyr::mutate(value_actual = ifelse(test = value %in% exclude_vec,
#   #                                     yes = item_count,
#   #                                     no = value))
# 
# 
# # Check structure
# dplyr::glimpse(path_df_actual)
# ## view(path_df_actual)


# Strip out folder paths
repo_tree <- data.tree::as.Node(path_df)

# Check that out
repo_tree

# Return this
# return(repo_tree)
