#' @title Create an Ordination with Ellipses for Groups
#' 
#' @description Produces a Nonmetric Multidimensional Scaling (NMS) or Principal Coordinate Analysis (PCoA) for up to 10 groups. Draws an ellipse around the standard deviation of the points in each group. By default, assigns a unique color (colorblind-safe) and point shape for each group. If the user supplies colors/shapes then the function can support more than 10 groups. For NMS ordinations, includes the stress as the legend title (see `?vegan::metaMDS` for explanation of "stress"). For PCoA ordinations includes the percent variation explained parenthetically in the axis labels.
#' 
#' @param mod (pcoa | monoMDS/metaMDS) object returned by `ape::pcoa` or `vegan::metaMDS`
#' @param grps (vector) vector of categorical groups for data. Must be same length as number of rows in original data object
#' @param ... additional arguments passed to `graphics::plot`, `graphics::points`, `scales::alpha`, `vegan::ordiellipse`, or `graphics::legend`. Open a GitHub Issue if function must support additional arguments
#' 
#' @return (plot) base R ordination with an ellipse for each group
#' 
#' @export
#' 
#' @examples
#' \donttest{
#' # Use data from the vegan package
#' utils::data("varespec", package = 'vegan')
#' 
#' # Make some columns of known number of groups
#' treatment <- c(rep.int("Trt1", (nrow(varespec)/4)),
#'                rep.int("Trt2", (nrow(varespec)/4)),
#'                rep.int("Trt3", (nrow(varespec)/4)),
#'                rep.int("Trt4", (nrow(varespec)/4)))
#' 
#' # And combine them into a single data object
#' data <- cbind(treatment, varespec)
#' 
#' # Get a distance matrix from the data
#' dist <- vegan::vegdist(varespec, method = 'kulczynski')
#' 
#' # Perform PCoA / NMS
#' pcoa_mod <- ape::pcoa(dist)
#' nms_mod <- vegan::metaMDS(data[-1], autotransform = FALSE, expand = FALSE, k = 2, try = 50)
#' 
#' # Create PCoA ordination (with optional agruments)
#' ordination(mod = pcoa_mod, grps = data$treatment, 
#'            bg = c("red", "blue", "purple", "orange"),
#'            lty = 2, col = "black")
#' 
#' # Create NMS ordination
#' ordination(mod = nms_mod, grps = data$treatment, alpha = 0.3, 
#'            x = "topright", legend = LETTERS[1:4])
#' }
#' 
ordination <- function(mod = NULL, grps = NULL, ...){
  
  # Error out for missing (required) arguments
  if(is.null(mod) == TRUE)
    stop("Model must be provided")
  if(is.null(grps) == TRUE)
    stop("Categorical groups must be specified")
  
  # Error out for unsupported model type
  if(all(class(mod) %in% c("pcoa", "metaMDS", "monoMDS")) != TRUE)
    stop("Model must be returned by 'ape::pcoa' or 'vegan::metaMDS'")
  
  # Error out for unsupported group type
  if(is.vector(grps) != TRUE)
    stop("Groups must be provided as a vector")
  
  # Identify group names
  grp_names <- unique(grps)
  
  # Model-specific stuff
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
    mod_points <- mod_actual$points
    
    # Create informative axis labels
    xlab_actual <- "NMS Axis 1"
    ylab_actual <- "NMS Axis 2"
    leg_title <- paste0("Stress = ", round(mod_actual$stress, digits = 3))
  }
  
  # Error out for mismatch in ordination data and group vector
  if(nrow(mod_points) != length(grps))
    stop("Incorrect number of groups provided relative to model.",
         "\n  ", length(grps), " groups specified but model has ", 
         nrow(mod_points), " rows")
  
  # Identify arguments in `...` argument
  bonus_args <- as.list(substitute(expr = list(...)))
  
  # Add in defaults for each supported argument if they are absent
  if("cex.lab" %in% names(bonus_args) != TRUE){
    bonus_args <- append(x = bonus_args, values = list("cex.lab" = 1.25))
  }
  if("cex.axis" %in% names(bonus_args) != TRUE){
    bonus_args <- append(x = bonus_args, values = list("cex.axis" = 1))
  }
  if("cex" %in% names(bonus_args) != TRUE){
    bonus_args <- append(x = bonus_args, values = list("cex" = 1.5))
  }
  if("alpha" %in% names(bonus_args) != TRUE){
    bonus_args <- append(x = bonus_args, values = list("alpha" = 0.99))
  }
  if("lty" %in% names(bonus_args) != TRUE){
    bonus_args <- append(x = bonus_args, values = list("lty" = 1))
  }
  if("x" %in% names(bonus_args) != TRUE){
    bonus_args <- append(x = bonus_args, values = list("x" = "bottomleft"))
  }
  if("legend" %in% names(bonus_args) != TRUE){
    bonus_args <- append(x = bonus_args, values = list("legend" = grp_names))
  }
  
  # Certain aesthetics need to be handled separately
  ## Point / line color
  if("col" %in% names(bonus_args) != TRUE & 
     "bg" %in% names(bonus_args) != TRUE){
    
    # Define default colors
    default_line_cols <- c('#41b6c4', '#c51b7d', '#7fbc41', '#d73027', '#4575b4',
                           '#e08214', '#8073ac', '#f1b6da', '#b8e186', '#8c96c6')
    
    # Crop to desired length
    needed_line_cols <- default_line_cols[1:length(grp_names)]
    
    # Make it a named vector
    colors_line_actual <- supportR::name_vec(content = needed_line_cols, 
                                             name = grp_names)
  } else if ("col" %in% names(bonus_args) != TRUE & 
             "bg" %in% names(bonus_args) == TRUE) {
    
    # Identify colors (from bg)
    user_line_cols <- eval(bonus_args$bg)
    
    # Crop to desired length
    needed_line_cols <- user_line_cols[1:length(grp_names)]
    
    # Make it a named vector
    colors_line_actual <- supportR::name_vec(content = needed_line_cols, 
                                             name = grp_names)    
  } else {
    
    # Identify colors
    user_line_cols <- eval(bonus_args$col)
    
    # Crop to desired length
    needed_line_cols <- user_line_cols[1:length(grp_names)]
    
    # Make it a named vector
    colors_line_actual <- supportR::name_vec(content = needed_line_cols, 
                                             name = grp_names)
    
    # Remove the user-supplied value from the argument list
    bonus_args <- bonus_args[names(bonus_args) != "col"]
  }
  if("bg" %in% names(bonus_args) != TRUE){
    
    # Define default colors
    default_pt_cols <- c('#41b6c4', '#c51b7d', '#7fbc41', '#d73027', '#4575b4',
                         '#e08214', '#8073ac', '#f1b6da', '#b8e186', '#8c96c6')
    
    # Crop to desired length
    needed_pt_cols <- default_pt_cols[1:length(grp_names)]
    
    # Make it a named vector
    colors_pt_actual <- supportR::name_vec(content = needed_pt_cols, 
                                           name = grp_names)
  } else {
    
    # Identify colors
    user_pt_cols <- eval(bonus_args$bg)
    
    # Crop to desired length
    needed_pt_cols <- user_pt_cols[1:length(grp_names)]
    
    # Make it a named vector
    colors_pt_actual <- supportR::name_vec(content = needed_pt_cols, 
                                           name = grp_names)
    
    # Remove the user-supplied value from the argument list
    bonus_args <- bonus_args[names(bonus_args) != "bg"]
  }
  ## Point shapes
  if("pch" %in% names(bonus_args) != TRUE){
    
    # Define default shapes
    default_shps <- rep(x = 21:25, times = 2)
    
    # Crop to desired length
    needed_shps <- default_shps[1:length(grp_names)]
    
    # Make it a named vector
    shapes_actual <- supportR::name_vec(content = needed_shps, 
                                        name = grp_names)
  } else {
    
    # Identify shapes
    user_shps <- eval(bonus_args$pch)
    
    # Crop to desired length
    if(length(user_shps) >= length(grp_names)){ 
      needed_shps <- user_shps[1:length(grp_names)] 
    } else {
      needed_shps <- rep(x = user_shps, times = 30)[1:length(grp_names)]
    }
    
    # Make it a named vector
    shapes_actual <- supportR::name_vec(content = needed_shps, 
                                        name = grp_names)
    
    # Remove the user-supplied value from the argument list
    bonus_args <- bonus_args[names(bonus_args) != "pch"]
  }
  
  # Separate them based on which sub-function they belong with
  graphics.plot_args <- bonus_args[which(names(bonus_args) %in% c("cex.lab", "cex.axis"))]
  graphics.points_args <- bonus_args[which(names(bonus_args) %in% c("cex"))]
  scales.alpha_args <- bonus_args[which(names(bonus_args) %in% c("alpha"))]
  vegan.ordiellipse_args <- bonus_args[which(names(bonus_args) %in% c("lty"))]
  graphics.legend_args <- bonus_args[which(names(bonus_args) %in% c("x", "legend"))]
  
  # Identify any named bonus arguments that aren't identified above
  missing_args <- setdiff(x = names(bonus_args), 
                          y = c("", "cex.lab", "cex.axis", "cex",
                                "alpha", "lty", "x", "legend"))
  
  # Warning if any are found
  if(length(missing_args) != 0){
    warning("Unknown additional arguments detected: '",
            paste(missing_args, collapse = "', '"), "'",
            "\nThose arguments are ignored.",
            "\nPlease open a GitHub issue to expand function behavior.") }
  
  # Create blank plot
  do.call(what = graphics::plot, 
          args = append(x = graphics.plot_args,
                        values = list("x" = mod_points, "type" = "n", "col" = "white",
                                      "pch" = 1, "xlab" = xlab_actual, "ylab" = ylab_actual)))
  
  # For each group in the ordination
  for(focal_grp in grp_names){
    
    # Apply desired transparency to chosen color
    focal_color <- do.call(what = scales::alpha,
                           args = append(x = scales.alpha_args,
                                         values = list("colour" = colors_pt_actual[focal_grp])))
    
    # Actually add points
    do.call(what = graphics::points,
            args = append(x = graphics.points_args,
                          values = list("x" = mod_points[grp_names == focal_grp, 1],
                                        "y" = mod_points[grp_names == focal_grp, 2],
                                        "pch" = shapes_actual[focal_grp], 
                                        "bg" = focal_color)))

  } # Close points loop
  
  # With all of the points plotted, add ellipses of matched colors
  do.call(what = vegan::ordiellipse,
          args = append(x = vegan.ordiellipse_args,
                        values = list("ord" = mod_actual, 
                                      "groups" = grps, 
                                      "col" = colors_line_actual,
                                      "display" = "sites", 
                                      "kind" = "sd", 
                                      "lwd" = 2, "label" = FALSE)))
  
  # Finally, add a legend
  do.call(what = graphics::legend,
          args = append(x = graphics.legend_args,
                        values = list("bty" = "n", 
                                      "title" = leg_title,
                                      "pt.cex" = 1.25, "cex" = 1.15,
                                      "pch" = shapes_actual, 
                                      "pt.bg" = colors_pt_actual)))

  }
