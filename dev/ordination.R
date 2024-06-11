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
str(data)

# Get a distance matrix from the data
dist <- vegan::vegdist(resp, method = 'kulczynski')

# Perform a PCoA on the distance matrix to get points for an ordination
pcoa_mod <- ape::pcoa(dist)
class(pcoa_mod)

# Actually perform multidimensional scaling
nms_mod <- vegan::metaMDS(data[-1], autotransform = FALSE, expand = FALSE, k = 2, try = 50)
class(nms_mod)

## ------------------------------------ ##
# Explore ----
## ------------------------------------ ##

# Define function
ordination <- function(
    mod = NULL,
    grps = NULL, 
    grp_colors = c('#41b6c4', '#c51b7d', '#7fbc41', '#d73027', '#4575b4',
                   '#e08214', '#8073ac', '#f1b6da', '#b8e186', '#8c96c6'), 
    grp_shapes = rep(x = 21:25, times = 2), 
    grp_lines = rep(x = 1, times = 10),
    pt_size = 1.5,
    pt_alpha = 1,
    lab_text_size = 1.25,
    axis_text_size = 1,
    leg_pos = "bottomleft",
    leg_cont = unique(grps),
    ...
){
  
  # Model-specific stuff
  # Identify axis labels (ordination type-dependent)
  ## Principal Coordinates Analysis
  if(all(class(mod) == "pcoa")){
    
    # Define actual model object (with plot-able data points)
    mod_actual <- mod$vectors
    mod_points <- mod_actual
    
    # Create informative plot labels
    xlab_actual <- paste0("PC1 (", round(mod$values$Relative_eig[1] * 100, digits = 2), "%)")
    ylab_actual <- paste0("PC2 (", round(mod$values$Relative_eig[2] * 100, digits = 2), "%)")
    leg_title <- NULL
  }
  ## Non-Metric Multidimensional Scaling
  if(all(class(mod) %in% c("metaMDS", "monoMDS"))){
    
    # Define actual model object (with plot-able data points)
    mod_actual <- mod
    mod_points <- mod$points
    
    # Create informative axis labels
    xlab_actual <- "NMS Axis 1"
    ylab_actual <- "NMS Axis 2"
    leg_title <- paste0("Stress = ", round(mod_actual$stress, digits = 3))
  }
  
  # Identify unique groups in dat
  (grp_names <- unique(grps))
  
  # Assign names to the vectors of colors/shapes/lines
  (names(grp_colors) <- grp_names)
  (names(grp_shapes) <- grp_names)
  (names(grp_lines) <- grp_names)
  
  # Crop all three vectors to the length of groups in the data
  ## Also adjust color opacity
  (colors_actual <- grp_colors[is.na(names(grp_colors)) != TRUE])
  (shapes_actual <- grp_shapes[is.na(names(grp_shapes)) != TRUE])
  (lines_actual <- grp_lines[is.na(names(grp_lines)) != TRUE])
  
  # Create blank plot
  graphics::plot(x = mod_actual, type = 'n', col = 'white', pch = 1,
                 xlab = xlab_actual, 
                 ylab = ylab_actual,
                 cex.lab = lab_text_size,
                 cex.axis = axis_text_size)
  
  # For each group in the ordination
  for(focal_grp in grp_names){
    
    # Add points
    graphics::points(x = mod_points[grp_names == focal_grp, 1],
                     y = mod_points[grp_names == focal_grp, 2],
                     pch = shapes_actual[focal_grp], 
                     bg = scales::alpha(colour = colors_actual[focal_grp], ...),
                     cex = pt_size)
    
  } # Close points loop
  
  # With all of the points plotted, add ellipses of matched colors
  # This also allows for variation in line type if desired
  vegan::ordiellipse(ord = mod_actual, groups = grps, col = colors_actual,
                     display = 'sites', kind = 'sd', lwd = 2,
                     lty = lines_actual, label = FALSE)
  
  # Finally, add a legend
  graphics::legend(x = leg_pos, legend = leg_cont, bty = "n", title = leg_title,
                   pt.cex = 1.25, pch = shapes_actual, cex = 1.15, pt.bg = colors_actual)
  
} # Close function

# Invoke function
## PCoA variant
ordination(mod = pcoa_mod, grps = data$factor_4lvl, alpha = 0.5)
## NMS variant
ordination(mod = nms_mod, grps = data$factor_4lvl, alpha = 0.2)

## ------------------------------------ ##
# Ellipsis Testing ----
## ------------------------------------ ##

# Re-clear environment
rm(list = ls())

# Define function
test_fxn <- function(...){
  
  # Extract list information
  input_list <- as.list(substitute(expr = list(...)))
  
  # Identify arguments specific to a particular sub-function
  mean_list <- input_list[which(names(input_list) %in% c("x"))]
  round_list <- input_list[which(names(input_list) %in% c("digits"))]

  # Take average
  mean_obj <- do.call(what = "mean", args = mean_list)
  
  # Round the average value
  round_obj <- do.call(what = "round", 
                       args = append(x = round_list, 
                                     values = c("x" = mean_obj)))

  # Return output
  return(round_obj) }

# Invoke function
test_fxn(x = c(1, 5, 7), digits = 2)



# Other experimentation
(test <- list("x" = 4.3333333333))

(test2 <- append(x = test, values = c("digits" = 3)))

do.call(what = round, args = test2)
do.call(what = "round", args = test2)

# End ----

