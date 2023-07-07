
# Load local package contents
devtools::load_all()

# Make sure `github_ls` is part of that
?github_ls

# Load some bonus libraries
library(tidyverse)

# Run that on a repository
conts <- github_ls(repo = "github.com/njlyon0/supportR", folder = NULL,
                   recursive = T, quiet = F)

# Check the structure of that
dplyr::glimpse(conts)
