## ------------------------------------------------------- ##
# Remove Non-ASCII Characters
## ------------------------------------------------------- ##
# Script author(s): Nick Lyon

# Purpose
## A function for coercing non-ASCII characters into ASCII equivalents

## ----------------------------------- ##
# Housekeeping ----
## ----------------------------------- ##

# Load libraries
librarian::shelf(tidyverse, supportR)

# Clear environment
rm(list = ls())

## ----------------------------------- ##
# Exploration ----
## ----------------------------------- ##

# Make a vector of non-ASCII characters
(bad_vec <- c("’"))




# End ----


dplyr::mutate(dplyr::across(.cols = dplyr::where(is.character),
                            .fns = \(t){gsub(pattern = , replacement = "'",
                                             x = t)})) %>%
  # Curly quotes are an issue too
  dplyr::mutate(dplyr::across(.cols = dplyr::where(is.character),
                              .fns = \(t){gsub(pattern = "“|”", replacement = '"',
                                               x = t)})) %>%
  # Also non-hyphen dashes
  dplyr::mutate(dplyr::across(.cols = dplyr::where(is.character),
                              .fns = \(t){gsub(pattern = "—|−|-|–", replacement = "-",
                                               x = t)})) %>%
  # Multiplication symbol
  dplyr::mutate(dplyr::across(.cols = dplyr::where(is.character),
                              .fns = \(t){gsub(pattern = "×", replacement = "*",
                                               x = t)})) %>%
  # Non-ASCII letter fixes
  dplyr::mutate(dplyr::across(.cols = dplyr::where(is.character),
                              .fns = \(t){gsub(pattern = "ﬁ", replacement = "fi",
                                               x = t)})) %>%
  dplyr::mutate(dplyr::across(.cols = dplyr::where(is.character),
                              .fns = \(t){gsub(pattern = "ö", replacement = "o",
                                               x = t)})) %>%
  # Worst of all, weird spaces
  dplyr::mutate(dplyr::across(.cols = dplyr::where(is.character),
                              .fns = \(t){gsub(pattern = " |  |  |­|·", replacement = " ",
                                               x = t)})) %>%
  # Ellipses
  dplyr::mutate(dplyr::across(.cols = dplyr::where(is.character),
                              .fns = \(t){gsub(pattern = "…", replacement = "...",
                                               x = t)})) %>%
  # Re-count non-ASCII characters
  dplyr::rowwise() %>%
  dplyr::mutate(non_ascii_ct = sum(stringr::str_detect(dplyr::c_across(dplyr::where(is.character)),
                                                       pattern = "[^[:ascii:]]"),
                                   na.rm = T))