
# Load local package contents
devtools::load_all()

# Make sure `github_ls` is part of that
?github_ls

# Load some bonus libraries
librarian::shelf(tidyverse, stringr, data.tree)

# Clear environment
rm(list = ls())

# Run that on a repository
repo_conts <- github_ls(repo = "github.com/njlyon0/supportR", folder = NULL)

# Check the structure of that
dplyr::glimpse(repo_conts)

# Create a vector of folders to exclude from the ToC
exclude_vec <- c("man", "docs")

# Process it into just the file paths
repo_paths <- repo_conts %>%
  # Complete the path by adding each file to the end of its path
  dplyr::mutate(path = paste0(path, "/", name)) %>%
  # Strip out only that path column
  dplyr::pull(var = path)

# Identify maximum depth of folders
max_depth <- base::max(stringr::str_count(string = repo_paths, pattern = "/")) + 1

# Wrangle the path object as needed for `data.tree::as.Node`
path_df <- as.data.frame(repo_paths) %>%
  # Make into a dataframe where each path is a row and each column is a folder
  tidyr::separate_wider_delim(cols = repo_paths, delim = '/', too_few = "align_start",
                              names = paste0("V", 1:max_depth)) %>%
  # Also re-gain the full path string
  dplyr::mutate(pathString = repo_paths)





# Strip out folder paths
repo_tree <- data.tree::as.Node(path_df)

# Return this
# return(repo_tree)
