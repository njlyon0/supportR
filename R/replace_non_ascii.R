#' @title Replace Non-ASCII Characters with Comparable ASCII Characters
#' 
#' @description Finds all non-ASCII (American Standard Code for Information Interchange) characters in a character vector and replaces them with ASCII characters that are as visually similar as possible. For example, various special dash types (e.g., em dash, en dash, etc.) are replaced with a hyphen. The function will return a warning if it finds any non-ASCII characters for which it does not have a hard-coded replacement. Please open a [GitHub Issue](https://github.com/njlyon0/supportR/issues) if you encounter this warning and have a suggestion for what the replacement character should be for that particular character.
#' 
#' @param x (character) vector in which to replace non-ASCII characters
#' @param include_letters (logical) whether to include letters with accents (e.g., u with an umlaut, etc.). Defaults to `FALSE`
#' 
#' @return (character) vector where all non-ASCII characters have been replaced by ASCII equivalents
#' 
#' @export
#' 
#' @examples
#' # Make a vector of the hexadecimal codes for several non-ASCII characters
#' ## This function accepts the characters themselves but CRAN checks do not
#' non_ascii <- c("\u201C", "\u00AC", "\u00D7")
#' 
#' # Invoke function
#' (ascii <- replace_non_ascii(x = non_ascii))
#' 
replace_non_ascii <- function(x = NULL, include_letters = FALSE){
  
  # Error out if x isn't supplied
  if(is.null(x) == TRUE)
    stop("'x' must be specified")
  
  # Error out if x isn't a character
  if(is.character(x) != TRUE)
    stop("'x' must be a character")
  
  # Coerce `sort` to TRUE if not a logical
  if(is.logical(include_letters) != TRUE){
    warning("'include_letters' must be either TRUE or FALSE. Coercing to FALSE")
    include_letters <- FALSE }
  
  # Make a new object so we can make all find/replace steps identical
  q <- x
  
  # Spaces ----
  q <- gsub(pattern = "\u00AD|\u2002|\u2003|\u2009|\u200C|\u200D|\u200E|\u200F", 
            replacement = " ", x = q)
  
  # Punctuation ----
  q <- gsub(pattern = "\u00B4|\u2032|\u2018|\u2019", replacement = "'", x = q)
  q <- gsub(pattern = "\u2033|\u201C|\u201D", replacement = '"', x = q)
  q <- gsub(pattern = "\u201A|\u00B8", replacement = ",", x = q)
  q <- gsub(pattern = "\u201E", replacement = ",,", x = q)
  q <- gsub(pattern = "\u2022|\u22C5|\u00B7", replacement = ".", x = q)
  q <- gsub(pattern = "\u00A8", replacement = "..", x = q)
  q <- gsub(pattern = "\u2026", replacement = "...", x = q)
  q <- gsub(pattern = "\u00A1", replacement = "!", x = q)
  q <- gsub(pattern = "\u00BF", replacement = "?", x = q)
  q <- gsub(pattern = "\u00AC|\u00AF|\u2013|\u2014|\u203E|\u2212", 
            replacement = "-", x = q)
  
  ## Math ----
  q <- gsub(pattern = "\u00B1", replacement = "+/-", x = q)
  q <- gsub(pattern = "\u2217", replacement = "*", x = q)
  q <- gsub(pattern = "\u00D7", replacement = "x", x = q)
  q <- gsub(pattern = "\u00F7|\u2044|\u221A", replacement = "/", x = q)
  q <- gsub(pattern = "\u00BC", replacement = "1/4", x = q)
  q <- gsub(pattern = "\u00BD", replacement = "1/2", x = q)
  q <- gsub(pattern = "\u00BE", replacement = "3/4", x = q)
  q <- gsub(pattern = "\u223C|\u02DC", replacement = "~", x = q)
  q <- gsub(pattern = "\u2260", replacement = "=/=", x = q)
  q <- gsub(pattern = "\u27E8|\u2039", replacement = "<", x = q)
  q <- gsub(pattern = "\u2264", replacement = "<=", x = q)
  q <- gsub(pattern = "\u27E9|\u203A|\u3009", replacement = ">", x = q)
  q <- gsub(pattern = "\u2265", replacement = ">=", x = q)
  q <- gsub(pattern = "\u02C6", replacement = "^", x = q)
  q <- gsub(pattern = "\u00B9", replacement = "^1", x = q)
  q <- gsub(pattern = "\u00B2", replacement = "^2", x = q)
  q <- gsub(pattern = "\u00B3", replacement = "^3", x = q)
  q <- gsub(pattern = "\u0192", replacement = "f", x = q)
  
  # Letters ----
  if(include_letters == TRUE){
    q <- gsub(pattern = "\u00C0|\u00C1|\u00C2|\u00C3|\u00C4|\u00C5",
              replacement = "A", x = q)
    q <- gsub(pattern = "\u00E0|\u00E1|\u00E2|\u00E3|\u00E4|\u00E5",
              replacement = "a", x = q)
    q <- gsub(pattern = "\u00C6", replacement = "AE", x = q)
    q <- gsub(pattern = "\u00E6", replacement = "ae", x = q)
    q <- gsub(pattern = "\u0152", replacement = "OE", x = q)
    q <- gsub(pattern = "\u0153", replacement = "oe", x = q)
    q <- gsub(pattern = "\u00C7", replacement = "C", x = q)
    q <- gsub(pattern = "\u00E7", replacement = "c", x = q)
    q <- gsub(pattern = "\u00C8|\u00C9|\u00CA|\u00CB", replacement = "E", x = q)
    q <- gsub(pattern = "\u00E8|\u00E9|\u00EA|\u00EB", replacement = "e", x = q)
    q <- gsub(pattern = "\u00CC|\u00CD|\u00CE|\u00CF", replacement = "I", x = q)
    q <- gsub(pattern = "\u00EC|\u00ED|\u00EE|\u00EF", replacement = "i", x = q)
    q <- gsub(pattern = "\u00D0", replacement = "D", x = q)
    q <- gsub(pattern = "\u00F0|\u2202|\u03D1", replacement = "d", x = q)
    q <- gsub(pattern = "\u00D1", replacement = "N", x = q)
    q <- gsub(pattern = "\u00F1|\u2229", replacement = "n", x = q)
    q <- gsub(pattern = "\u00D2|\u00D3|\u00D4|\u00D5|\u00D6", replacement = "O", x = q)
    q <- gsub(pattern = "\u00F2|\u00F3|\u00F4|\u00F5|\u00F6", replacement = "o", x = q)
    q <- gsub(pattern = "\u00D8", replacement = "O", x = q)
    q <- gsub(pattern = "\u00F8", replacement = "o", x = q)
    q <- gsub(pattern = "\u00D9|\u00DA|\u00DB|\u00DC", replacement = "U", x = q)
    q <- gsub(pattern = "\u00F9|\u00FA|\u00FB|\u00FC|\u222A", replacement = "u", x = q)
    q <- gsub(pattern = "\u00DD|\u0178", replacement = "Y", x = q)
    q <- gsub(pattern = "\u00FD|\u00FF", replacement = "y", x = q)
    q <- gsub(pattern = "\u00DE", replacement = "P", x = q)
    q <- gsub(pattern = "\u00FE", replacement = "p", x = q)
    q <- gsub(pattern = "\u00DF", replacement = "B", x = q)
    q <- gsub(pattern = "\u0160", replacement = "S", x = q)
    q <- gsub(pattern = "\u0161", replacement = "s", x = q)  
    q <- gsub(pattern = "\uFB01", replacement = "fi", x = q)
  }
  
  # Other Symbols ----
  q <- gsub(pattern = "\u00A9", replacement = "(C)", x = q)
  q <- gsub(pattern = "\u00AE", replacement = "(R)", x = q)
  q <- gsub(pattern = "\u2122", replacement = "^TM", x = q)
  q <- gsub(pattern = "\u00A6", replacement = "|", x = q)
  q <- gsub(pattern = "\u00A7", replacement = "S", x = q)
  q <- gsub(pattern = "\u00AA", replacement = "^a", x = q)
  q <- gsub(pattern = "\u00BA", replacement = "^o", x = q)
  q <- gsub(pattern = "\u00AB", replacement = "<<", x = q) 
  q <- gsub(pattern = "\u00BB", replacement = ">>", x = q) 
  q <- gsub(pattern = "\u00B0", replacement = "o", x = q)
  q <- gsub(pattern = "\u00B6", replacement = "P", x = q) 
  q <- gsub(pattern = "\u2118", replacement = "*P*", x = q)
  q <- gsub(pattern = "\u2111", replacement = "*I*", x = q)
  q <- gsub(pattern = "\u211C", replacement = "*R*", x = q)
  q <- gsub(pattern = "\u2135", replacement = "alef", x = q)
  q <- gsub(pattern = "\u2190", replacement = "<-", x = q)
  q <- gsub(pattern = "\u21D0", replacement = "<=", x = q)
  q <- gsub(pattern = "\u2191|\u2227", replacement = "^", x = q)
  q <- gsub(pattern = "\u2192", replacement = "->", x = q)
  q <- gsub(pattern = "\u21D2", replacement = "=>", x = q)
  q <- gsub(pattern = "\u2193|\u2228", replacement = "v", x = q)
  q <- gsub(pattern = "\u2194", replacement = "<->", x = q)
  q <- gsub(pattern = "\u21D4", replacement = "<=>", x = q)
  q <- gsub(pattern = "\u2020", replacement = "t", x = q)
  q <- gsub(pattern = "\u2660", replacement = "spade", x = q)
  q <- gsub(pattern = "\u2663", replacement = "club", x = q)
  q <- gsub(pattern = "\u2665", replacement = "heart", x = q)
  q <- gsub(pattern = "\u2666", replacement = "diamond", x = q)
  q <- gsub(pattern = "\u2030", replacement = "o/oo", x = q)
  
  ## Currency ----
  q <- gsub(pattern = "\u00A2", replacement = "c", x = q)
  q <- gsub(pattern = "\u00A3", replacement = "L", x = q)
  q <- gsub(pattern = "\u00A5", replacement = "Y", x = q)
  q <- gsub(pattern = "\u20AC", replacement = "E", x = q)
  q <- gsub(pattern = "\u00A4", replacement = "ox", x = q)
  
  # Greek ----
  q <- gsub(pattern = "\u0391", replacement = "ALPHA", x = q)
  q <- gsub(pattern = "\u03B1", replacement = "alpha", x = q)
  q <- gsub(pattern = "\u0392", replacement = "BETA", x = q)
  q <- gsub(pattern = "\u03B2", replacement = "beta", x = q)
  q <- gsub(pattern = "\u0393", replacement = "GAMMA", x = q)
  q <- gsub(pattern = "\u03B3", replacement = "gamma", x = q)
  q <- gsub(pattern = "\u0394", replacement = "DELTA", x = q)
  q <- gsub(pattern = "\u03B4", replacement = "delta", x = q)
  q <- gsub(pattern = "\u0395", replacement = "EPSILON", x = q)
  q <- gsub(pattern = "\u03B5", replacement = "epsilon", x = q)
  q <- gsub(pattern = "\u0396", replacement = "ZETA", x = q)
  q <- gsub(pattern = "\u03B6|\u03C2", replacement = "zeta", x = q)
  q <- gsub(pattern = "\u0397", replacement = "ETA", x = q)
  q <- gsub(pattern = "\u03B7", replacement = "eta", x = q)
  q <- gsub(pattern = "\u0398", replacement = "THETA", x = q)
  q <- gsub(pattern = "\u03B8", replacement = "theta", x = q)
  q <- gsub(pattern = "\u0399", replacement = "IOTA", x = q)
  q <- gsub(pattern = "\u03B9", replacement = "iota", x = q)
  q <- gsub(pattern = "\u039A", replacement = "KAPPA", x = q)
  q <- gsub(pattern = "\u03BA", replacement = "kappa", x = q)
  q <- gsub(pattern = "\u039B", replacement = "LAMBDA", x = q)
  q <- gsub(pattern = "\u03BB", replacement = "lamda", x = q)
  q <- gsub(pattern = "\u039C", replacement = "MU", x = q)
  q <- gsub(pattern = "\u03BC|\u00B5", replacement = "mu", x = q)
  q <- gsub(pattern = "\u039D", replacement = "NU", x = q)
  q <- gsub(pattern = "\u03BD", replacement = "nu", x = q)
  q <- gsub(pattern = "\u039E", replacement = "XI", x = q)
  q <- gsub(pattern = "\u03BE", replacement = "xi", x = q)
  q <- gsub(pattern = "\u039F", replacement = "OMICRON", x = q)
  q <- gsub(pattern = "\u03BF", replacement = "omicron", x = q)
  q <- gsub(pattern = "\u03A0|\u220F", replacement = "PI", x = q)
  q <- gsub(pattern = "\u03C0|\u03D6", replacement = "pi", x = q)
  q <- gsub(pattern = "\u03A1", replacement = "RHO", x = q)
  q <- gsub(pattern = "\u03C1", replacement = "rho", x = q)
  q <- gsub(pattern = "\u03A3|\u2211", replacement = "SIGMA", x = q)
  q <- gsub(pattern = "\u03C3", replacement = "sigma", x = q)
  q <- gsub(pattern = "\u03A4", replacement = "TAU", x = q)
  q <- gsub(pattern = "\u03C4", replacement = "tau", x = q)
  q <- gsub(pattern = "\u03A5", replacement = "UPSILON", x = q)
  q <- gsub(pattern = "\u03C5|\u03D2", replacement = "upsilon", x = q)
  q <- gsub(pattern = "\u03A6", replacement = "PHI", x = q)
  q <- gsub(pattern = "\u03C6", replacement = "phi", x = q)
  q <- gsub(pattern = "\u03A7", replacement = "CHI", x = q)
  q <- gsub(pattern = "\u03C7", replacement = "chi", x = q)
  q <- gsub(pattern = "\u03A8", replacement = "PSI", x = q)
  q <- gsub(pattern = "\u03C8", replacement = "psi", x = q)
  q <- gsub(pattern = "\u03A9", replacement = "OMEGA", x = q)
  q <- gsub(pattern = "\u03C9", replacement = "omega", x = q)
  
  # See if any are not replaced manually above
  remaining <- q[stringr::str_detect(string = q, pattern = "[^[:ascii:]]") == TRUE]
  
  # Remove letters from this vector if the user doesn't want them replaced
  if(include_letters != TRUE){

    # Vector of all uxxx escapes for non-ASCII letter characters
    non_ascii_letters <- c("\u00C0", "\u00C1", "\u00C2", "\u00C3", "\u00C4",
                           "\u00C5", "\u00E0", "\u00E1", "\u00E2", "\u00E3",
                           "\u00E4", "\u00E5", "\u00C6", "\u00E6", "\u0152",
                           "\u0153", "\u00C7", "\u00E7", "\u00C8", "\u00C9",
                           "\u00CA", "\u00CB", "\u00E8", "\u00E9", "\u00EA",
                           "\u00EB", "\u00CC", "\u00CD", "\u00CE", "\u00CF",
                           "\u00EC", "\u00ED", "\u00EE", "\u00EF", "\u00D0",
                           "\u00F0", "\u2202", "\u03D1", "\u00D1", "\u00F1",
                           "\u2229", "\u00D2", "\u00D3", "\u00D4", "\u00D5",
                           "\u00D6", "\u00F2", "\u00F3", "\u00F4", "\u00F5",
                           "\u00F6", "\u00D8", "\u00F8", "\u00D9", "\u00DA",
                           "\u00DB", "\u00DC", "\u00F9", "\u00FA", "\u00FB",
                           "\u00FC", "\u222A", "\u00DD", "\u0178", "\u00FD",
                           "\u00FF", "\u00DE", "\u00FE", "\u00DF", "\u0160",
                           "\u0161", "\u2020", "\uFB01")

    # Remove the hexadecimal escapes for these letters from the 'remaining' vector
    remaining <- setdiff(x = remaining, y = non_ascii_letters) }
  
  # Give a warning if any are found
  if(length(remaining) != 0){
    warning("Failed to replace the following non-ASCII characters: ", 
            paste0("'", remaining, "'", collapse = ", "),
            "\nHexadecimal codes for these characters are as follows: ",
            paste0("'", stringi::stri_escape_unicode(remaining), "'", collapse = ", "),
            "\n\nPlease open a GitHub Issue if you'd like this function to support a particular replacement for this character") }
  
  # Return that final vector
  return(q) }
