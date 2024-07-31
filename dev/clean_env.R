


# Testing 'clean_env' function


# Make some objects
x <- list()
y <- "Aaa"
z <- 123

# Define function
clean_env <- function(except, collect_garbage = TRUE){
  
  # Error for supplied 'except' that is not a character vector
  if(length(except) != 0){
    if(is.character(except) != TRUE)
      stop("'except' values must be provided as a character vector")
  }
  
  # Warning for malformed garbage collect entry
  if(is.logical(collect_garbage) != TRUE){
    warning("'collect_garbage' must be logical. Defaulting to FALSE")
    collect_garbage <- FALSE }
  
  # Identify objects to remove (all of them if no exceptions are specified)
  if(length(except) != 0){ 
    
    # Identify non-exception objects
    trash <- generics::setdiff(x = ls(), y = except)
    
    # Otherwise flag all object names for removal
  } else { trash <- ls() }
  
  # Clear environment (except for the other argument of the function)
  rm(list = generics::setdiff(x = trash, y = "collect_garbage"))
  
  # If indicated, collect garbage
  if(collect_garbage == TRUE){ gc(verbose = FALSE) }
}

clean_env(except = c("clean_env", "x"), collect_garbage = T)

