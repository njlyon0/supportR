
# Load libraries
library(spelling); library(magrittr)


# Check Spelling
test_df <- as.data.frame(spelling::spell_check_files(path = "index.qmd"))
test2_df <- data.frame("word" = test_df$word,
  "found_in" = unlist(test_df$found))

# Check structure
str(test2_df)
## View(test2_df)

## List files
(all_quarto <- data.frame("files" = dir(path = ".", recursive = T, pattern = "*.qmd")))

## Remove any in a folder with an underscore
rendered_quarto <- dplyr::filter(.data = all_quarto, 
  stringr::str_sub(string = files, start = 1, end = 1) != "_" &
    stringr::str_detect(string = files, pattern = "/_") != T & 
    stringr::str_detect(string = files, pattern = "\\\\_") != T)

# What was lost?
supportR::diff_check(old = unique(all_quarto$files), new = unique(rendered_quarto$files))

# What's left?
unique(rendered_quarto$files) 

# List for outputs
spell_results <- list()

# Loop across these
for(qmd in rendered_quarto$files){
  ## qmd <- "prep-steps/check_git-install_rstudio.qmd"
  
  # Progress message
  message("Checking spelling in ", qmd)

  # Check spelling 
  check_raw <- as.data.frame(spelling::spell_check_files(path = qmd))

  # Strip useful stuff
  found_word <- check_raw$word
  found_lines <- unlist(check_raw$found)

  # If there are any typos, make a nice dataframe for them
  if(length(found_word) != 0){
    check_raw <- data.frame("lines" = found_lines,
    "word" = found_word)
  } else { check_raw <- data.frame("lines" = "", "word" = "No typos found!")}
  
  # Add file name/path to that data object
  check_tidy <- dplyr::mutate(.data = check_raw,
    path = qmd,
    file = basename(path = qmd),
    .before = dplyr::everything())

  # And remove file name from the 'path' and 'lines' columns
  check_done <- dplyr::mutate(.data = check_tidy,
    path = gsub(pattern = unique(file), replacement = "", x = path),
    lines = gsub(pattern = paste0(unique(file), ":"), replacement = "", x = lines)) %>% 
    # Add a "." for empty paths that result from the above
    dplyr::mutate(path = ifelse(test = nchar(path) == 0, yes = ".", no = path))
  
  # Add to the list
  spell_results[[qmd]] <- check_done
}

# Unlist the spell check list
spell_df <- purrr::list_rbind(x = spell_results)

# Check that out
str(spell_df)
## View(spell_df)
