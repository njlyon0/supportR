## --------------------------------------------- ##
# Safely Rename Columns
## --------------------------------------------- ##

# PURPOSE:
## Safely rename columns via a function
## Alternative (unsafe) is something like:
### `names(df)[1] <- c("x")`

## ----------------------------- ##
# Housekeeping ----
## ----------------------------- ##

# Load libraries
librarian::shelf(tidyverse, supportR)

# Clear environment
rm(list = ls())

## ----------------------------- ##
# Testing Arena ----
## ----------------------------- ##

# Make a dataframe
(df <- data.frame("first" = 1:3,
                  "second" = 7:9))

# Duplicate to test various renaming approaches
df3 <- df2 <- df

# Rename in base R / unsafe manner
names(df2)[1] <- "number_one"
df2






# End ----
