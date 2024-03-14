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
                  "middle" = 4:6,
                  "second" = 7:9))

# Duplicate to test various renaming approaches
df4 <- df3 <- df2 <- df

# Rename in base R / unsafe manner
names(df2)[1] <- "number_one"
df2

# Safe-r method
## ID bad name
bad_name <- c("first", "second")

## Match and replace it in the names vector
names(df3)[names(df3) %in% bad_name] <- c("safe_first", "safe_second")
df3



# End ----
