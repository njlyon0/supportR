#' @title Replace Non-ASCII Characters with ASCII Equivalents
#' 
#' @description Finds all non-ASCII (American Standard Code for Information Interchange) characters in a character vector and replaces them with their ASCII equivalents. For example, vowels with umlauts over them are returned as the vowel without accent marks. The function will return a warning if it finds any non-ASCII characters for which it does not have a hard-coded fix. Please open a [GitHub Issue](https://github.com/njlyon0/supportR/issues) if you encounter this warning but know what the replacement character should be for that particular character.
#' 
#' @param x (character) vector in which to fix non-ASCII characters
#' 
#' @return (character) vector where all non-ASCII characters have been replaced by ASCII equivalents
#' 
#' @export
#' 
#' @examples
#' # Make a vector of several non-ASCII characters
#' (bad_vec <- c("’", "“", "×", "ﬁ", "ö", "ü"))
#' 
#' # Invoke function
#' (good_vec <- fix_non_ascii(x = bad_vec))
#' 
#' # Check to see if that worked
#' good_vec[stringr::str_detect(string = good_vec, pattern = "[^[:ascii:]]") == TRUE]
#' 
fix_non_ascii <- function(x = NULL){
  
  # Error out if x isn't supplied
  if(is.null(x) == TRUE)
    stop("'x' must be specified")
  
  # Error out if x isn't a character
  if(is.character(x) != TRUE)
    stop("'x' must be a character")
  
  # Make a new object so we can make all find/replace steps identical
  q <- x
  
  # Do actual fixing
  ## Symbols ----
  q <- gsub(pattern = "\u00A1", replacement = "!", x = q) # inverted !
  q <- gsub(pattern = "\u00A2", replacement = "c", x = q) # cents
  q <- gsub(pattern = "\u00A3", replacement = "L", x = q) # pounds
  q <- gsub(pattern = "\u00A4", replacement = "ox", x = q) # "currency symbol"
  q <- gsub(pattern = "\u00A5", replacement = "Y", x = q) # yen
  q <- gsub(pattern = "\u00A6", replacement = "|", x = q) # "broken bar"
  q <- gsub(pattern = "\u00A7", replacement = "S", x = q) # section sign
  q <- gsub(pattern = "\u00A8", replacement = "..", x = q) # spacing diaresis
  q <- gsub(pattern = "\u00A9", replacement = "(C)", x = q) # copyright
  q <- gsub(pattern = "\u00AA", replacement = "a", x = q) # "feminine ordinal indicator"
  q <- gsub(pattern = "\u00AB", replacement = "<<", x = q) # 
  q <- gsub(pattern = "\u00AC", replacement = "-", x = q)
  
  
  
  
  stringi::stri_escape_unicode("¬")
  
  q <- gsub(pattern = "\u00", replacement = "", x = q)
  
  
  # Letters ----
  q <- gsub(pattern = "\u00FC", replacement = "u", x = q)
  
  
  stringi::stri_escape_unicode("ü")
  
  q <- gsub(pattern = "\u00", replacement = "", x = q)
  
  
  
  
  ## Quotes / apostrophes
  q <- gsub(pattern = "’|`", replacement = "'", x = q)
  q <- gsub(pattern = "“|”", replacement = '"', x = q)
  ## Dashes / symbols
  q <- gsub(pattern = "—|−|–", replacement = "-", x = q)
  q <- gsub(pattern = "×", replacement = "*", x = q)
  q <- gsub(pattern = "·", replacement = ".", x = q)
  q <- gsub(pattern = "…", replacement = "...", x = q)
  ## Spaces
  q <- gsub(pattern = "­", replacement = " ", x = q)
  ## Letters
  q <- gsub(pattern = "ﬁ", replacement = "fi", x = q)
  q <- gsub(pattern = "ö|ó|ò", replacement = "o", x = q)
  q <- gsub(pattern = "ë|é|è", replacement = "e", x = q)
  q <- gsub(pattern = "ä|á|à|å", replacement = "a", x = q)
  q <- gsub(pattern = "ü|ú|ù", replacement = "u", x = q)
  
  # See if any are not fixed manually above
  unfixed <- q[stringr::str_detect(string = q, pattern = "[^[:ascii:]]") == TRUE]
  
  # Give a warning if any are found
  if(length(unfixed) != 0){
    warning("Failed to fix following non-ASCII characters: ", 
            paste0("'", unfixed, "'", collapse = "', '"), 
            "\nPlease open a GitHub Issue if you'd like this function to support a particular fix for this character") }
  
  # Return that fixed vector
  return(q) }




stringi::stri_escape_unicode("£")

sprintf("%X", as.integer(charToRaw("£")))



gsub(pattern = "\u00a3", replacement = "xx", x = "£")
stringr::str_detect(string = "\u00A3", pattern = "[[:ascii:]]")



