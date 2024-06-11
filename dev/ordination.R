## --------------------------------------------------- ##
# General Ordination Function
## --------------------------------------------------- ##

# PURPOSE
## Dev area for a generic 'ordination' function to supersede `pcoa_ord` and `nms_ord`
## Plus explore use of `...` parameter to simplify arguments of this function

## ------------------------------------ ##
# Housekeeping ----
## ------------------------------------ ##

# Library loading
librarian::shelf(tidyverse, vegan)
devtools::load_all()

# Clear environment
rm(list = ls())

# Use data from the vegan package
utils::data("varespec", package = 'vegan')
resp <- varespec

# Make some columns of known number of groups
factor_4lvl <- c(rep.int("Trt1", (nrow(resp)/4)),
                 rep.int("Trt2", (nrow(resp)/4)),
                 rep.int("Trt3", (nrow(resp)/4)),
                 rep.int("Trt4", (nrow(resp)/4)))

# And combine them into a single data object
data <- cbind(factor_4lvl, resp)

# Get a distance matrix from the data
dist <- vegan::vegdist(resp, method = 'kulczynski')

# Perform a PCoA on the distance matrix to get points for an ordination
pcoa_mod <- ape::pcoa(dist)

# Actually perform multidimensional scaling
nms_mod <- vegan::metaMDS(data[-1], autotransform = FALSE, expand = FALSE, k = 2, try = 50)

## ------------------------------------ ##
# Explore ----
## ------------------------------------ ##




# End ----
