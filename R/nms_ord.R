#' @title Publication-Quality Non-metric Multi-dimensional Scaling (NMS) Ordinations
#' @description Produces Non-Metric Multi-dimensional Scaling (NMS) ordinations for up to 10 groups. Assigns a unique color for each group and draws an ellipse around the standard deviation of the points. Automatically adds stress (see `vegan::metaMDS` for explanation of "stress") as legend title. Because there are only five hollow shapes (see `?graphics::pch()`) all shapes are re-used a maximum of 2 times when more than 5 groups are supplied.
#'
#' @param mod Object returned by `vegan::metaMDS`
#' @param groupcol (dataframe) column specification in the data that includes the groups (accepts either bracket or $ notation)
#' @param title (character) string to use as title for plot
#' @param colors (character) vector of colors (as hexadecimal codes) of length >= group levels (default *not* colorblind safe because of need for 10 built-in unique colors)
#' @param shapes (numeric) vector of shapes (as values accepted by `pch`) of length >= group levels
#' @param lines (numeric) vector of line types (as integers) of length >= group levels
#' @param pt_size (numeric) value for point size (controlled by character expansion i.e., `cex`)
#' @param pt_alpha (numeric) value for transparency of points (ranges from 0 to 1)
#' @param leg_pos (character or numeric) legend position, either numeric vector of x/y coordinates or shorthand accepted by `graphics::legend`
#' @param leg_cont (character) vector of desired legend entries. Defaults to `unique` entries in `groupcol` argument (this argument provided in case syntax of legend contents should differ from data contents)
#'
#' @return (base R plot) base R plot with ellipses for each group
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Use data from the vegan package
#' utils::data("varespec", package = 'vegan')
#' resp <- varespec
#'
#' # Make some columns of known number of groups
#' factor_4lvl <- c(rep.int("Trt1", (nrow(resp)/4)),
#'                  rep.int("Trt2", (nrow(resp)/4)),
#'                  rep.int("Trt3", (nrow(resp)/4)),
#'                  rep.int("Trt4", (nrow(resp)/4)))
#'
#' # And combine them into a single data object
#' data <- cbind(factor_4lvl, resp)
#'
#' # Actually perform multidimensional scaling
#' mds <- vegan::metaMDS(data[-1], autotransform = FALSE, expand = FALSE, k = 2, try = 50)
#'
#' # With the scaled object and original dataframe we can use this function
#' nms_ord(mod = mds, groupcol = data$factor_4lvl,
#'                 title = '4-Level NMS', leg_pos = 'topright',
#'                 leg_cont = as.character(1:4))
#' }
nms_ord <- function(mod = NULL, groupcol = NULL, title = NA,
                    colors = c('#41b6c4', '#c51b7d', '#7fbc41',
                               '#d73027', '#4575b4', '#e08214',
                               '#8073ac', '#f1b6da', '#b8e186',
                               '#8c96c6'),
                    shapes = rep(x = 21:25, times = 2),
                    lines = rep(x = 1, times = 10),
                    pt_size = 1.5, pt_alpha = 1,
                    leg_pos = 'bottomleft', leg_cont = unique(groupcol)) {

  # Error out if model or groupcolumn are not specified
  if(base::is.null(mod) | base::is.null(groupcol))
    stop("Model and groupcolumn must be specified")

  # Error out if the model is the wrong class
  if(base::unique(base::class(mod) %in% c("metaMDS", "monoMDS")) != TRUE)
    stop("Model must be returned by `vegan::metaMDS`")

  # Error out for inappropriate shapes / lines
  if(!is.numeric(shapes) | base::max(shapes) > 25 | base::min(shapes < 0))
    stop("`shapes` must be numeric value as defined in `?pch`")
  
  # Warn and coerce to default for inappropriate point size
  if(!is.numeric(pt_size)) {
    message("`pt_size` must be numeric. Coercing to 1.5")
    pt_size <- 1.5 }
  
  # Do the same for transparency
  if(!is.numeric(pt_alpha)) {
    message("`pt_alpha` must be numeric. Coercing to 1")
    pt_alpha <- 1 }
  
  # Warning message when attempting to plot too many groups
  if (base::length(base::unique(groupcol)) > base::min(base::length(colors),
                                                       base::length(shapes),
                                                       base::length(lines))) {
    message('Insufficient aesthetic values provided. 10 colors/shapes/lines are built into the function but you have supplied ', base::length(base::unique(groupcol)), ' groups. Please modify `colors`, `lines`, or `shapes` as needed to provide one value per category in your group column.')
  } else {

    # Before actually creating the plot we need to make sure colors/shapes/lines are correctly formatted

    # Make the provided group column into a factor
    group_col_fct <- base::as.factor(groupcol)

    # Identify the names of the groups in the data
    groups <- base::as.vector(base::levels(group_col_fct))

    # Assign names to the vectors of colors/shapes/lines
    base::names(colors) <- groups
    base::names(shapes) <- groups
    base::names(lines) <- groups

    # Crop all three vectors to the length of groups in the data
    ## Also adjust color opacity
    colors_actual <- colors[!base::is.na(base::names(colors))]
    shapes_actual <- shapes[!base::is.na(base::names(shapes))]
    lines_actual <- lines[!base::is.na(base::names(lines))]

    # Create blank plot
    graphics::plot(x = mod, display = 'sites', choice = c(1, 2), type = 'none',
         xlab = "NMS Axis 1", ylab = "NMS Axis 2", main = title,
         col = 'white', pch = 1)

    # For each group, add points of a unique color and (up to 5 groups) unique shape (only 5 hollow shapes are available so they're recycled 2x each)
    for(level in levels(group_col_fct)){
      graphics::points(x = mod$points[group_col_fct == level, 1],
                       y = mod$points[group_col_fct == level, 2],
             pch = shapes_actual[level], 
             bg = scales::alpha(colour = colors_actual[level], alpha = pt_alpha),
             cex = pt_size) }

    # With all of the points plotted, add ellipses of matched colors
    # This also allows for variation in line type if desired
    vegan::ordiellipse(ord = mod, groups = groupcol, col = colors_actual,
                       display = 'sites', kind = 'sd', lwd = 2,
                       lty = lines_actual, label = F)

    # Finally, add a legend
    graphics::legend(x = leg_pos, legend = leg_cont, bty = "n",
           # The "title" of the legend will now be the stress of the NMS
           title = paste0("Stress = ", round(mod$stress, digits = 3)),
           pt.cex = pt_size, pch = shapes_actual, cex = 1.15, pt.bg = colors_actual)
  }
}
