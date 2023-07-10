

# Make a function that creates a named vector from two vectors instead of first defining an unnamed vector and then coercing its names via `names(vec) <- c(...manual names...)
name_vec <- function(content, name){
  
  # Error out if content & name are not the same length
  if(length(x = content) != length(x = name))
    stop("Vector content and names must be the same length")
  
  # Construct the named vector
  names(content) <- name
  
  # Return that
  return(content) }

# Test function
name_vec(content = 1:10, name = paste0("text_", 1:10))






