
# Load libraries
library(spelling); library(magrittr)


# Define function
spellcheck_quarto <- function(path = getwd(), quiet = FALSE){

  # Warning for bad value to 'quiet'
  if(is.logical(quiet) != TRUE){
    warning("'quiet' must be a logical. Defaulting to FALSE")
    quiet <- FALSE }

  # List files
  all_quarto <- data.frame("files" = dir(path = path, recursive = TRUE,
    pattern = "*.qmd"))

  # Remove any files in a folder with a pre-pended underscore
  ## These folders are not rendered
  rendered_quarto <- dplyr::filter(.data = all_quarto, 
    stringr::str_sub(string = files, start = 1, end = 1) != "_" &
      stringr::str_detect(string = files, pattern = "/_") != T & 
      stringr::str_detect(string = files, pattern = "\\\\_") != T)

  # List for spellcheck outputs
  spell_results <- list()

  # Loop across these
  for(qmd in rendered_quarto$files){
    
    # Progress message if not supposed to be quiet
    if(quiet != TRUE){ message("Checking spelling in ", qmd) }

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
    
    # Add file name/path as columns to that data object
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

  # Return that
  return(spell_df) }

# Invoke function
spellcheck_quarto(quiet = F)
