#' @title Publication-Quality Principal Coordinates Analysis (PCoA) Ordinations
#' 
#' @description
#' `r lifecycle::badge("superseded")`
#' 
#' This function has been superseded by `ordination` because this is just a special case of that function. Additionally, `ordination` provides users much more control over the internal `graphics` functions used to create the fundamental elements of the graph
#' 
#' Produces Principal Coordinates Analysis (PCoA) ordinations for up to 10 groups. Assigns a unique color for each group and draws an ellipse around the standard deviation of the points. Automatically adds percent of variation explained by first two principal component axes parenthetically to axis labels. Because there are only five hollow shapes (see `?graphics::pch`) all shapes are re-used a maximum of 2 times when more than 5 groups are supplied.
#'
#' @param mod (pcoa) object returned by `ape::pcoa`
#' @param groupcol (dataframe) column specification in the data that includes the groups (accepts either bracket or $ notation)
#' @param title (character) string to use as title for plot
#' @param colors (character) vector of colors (as hexadecimal codes) of length >= group levels (default *not* colorblind safe because of need for 10 built-in unique colors)
#' @param shapes (numeric) vector of shapes (as values accepted by `pch`) of length >= group levels
#' @param lines (numeric) vector of line types (as integers) of length >= group levels
#' @param pt_size (numeric) value for point size (controlled by character expansion i.e., `cex`)
#' @param pt_alpha (numeric) value for transparency of points (ranges from 0 to 1)
#' @param lab_text_size (numeric) value for axis label text size
#' @param axis_text_size (numeric) value for axis tick text size
#' @param leg_pos (character or numeric) legend position, either numeric vector of x/y coordinates or shorthand accepted by `graphics::legend`
#' @param leg_cont (character) vector of desired legend entries. Defaults to `unique` entries in `groupcol` argument (this argument provided in case syntax of legend contents should differ from data contents)
#'
#' @return (plot) base R ordination with an ellipse for each group
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Use data from the vegan package
#' data("varespec", package = 'vegan')
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
#' # Get a distance matrix from the data
#' dist <- vegan::vegdist(resp, method = 'kulczynski')
#'
#' # Perform a PCoA on the distance matrix to get points for an ordination
#' pnts <- ape::pcoa(dist)
#'
#' # Test the function for 4 groups
#' pcoa_ord(mod = pnts, groupcol = data$factor_4lvl)
#' }
pcoa_ord <- function(mod = NULL, groupcol = NULL, title = NA,
                     colors = c('#41b6c4', '#c51b7d', '#7fbc41', '#d73027',
                                '#4575b4', '#e08214', '#8073ac', '#f1b6da',
                                '#b8e186', '#8c96c6'),
                     shapes = rep(x = 21:25, times = 2),
                     lines = rep(x = 1, times = 10),
                     pt_size = 1.5, pt_alpha = 1,
                     lab_text_size = 1.25, axis_text_size = 1,
                     leg_pos = 'bottomleft', leg_cont = unique(groupcol)) {

  # Error out if model or groupcolumn are not specified
  if(base::is.null(mod) | base::is.null(groupcol))
    stop("Model and groupcolumn must be specified")

  # Error out if the model is the wrong class
  if(base::class(mod) != "pcoa")
    stop("Model must be returned by 'ape::pcoa'")

  # Error out for inappropriate shapes / lines
  if(!is.numeric(shapes) | base::max(shapes) > 25 | base::min(shapes < 0))
    stop("'shapes' must be numeric value as defined in '?pch'")

  # Warn and coerce to default for inappropriate point size
  if(!is.numeric(pt_size)) {
    warning("'pt_size' must be numeric. Coercing to 1.5")
    pt_size <- 1.5 }
  
  # Do the same for transparency
  if(!is.numeric(pt_alpha)) {
    warning("'pt_alpha' must be numeric. Coercing to 1")
    pt_alpha <- 1 }
  
  # Warning label size
  if(!is.numeric(lab_text_size)){
    warning("'lab_text_size' must be numeric. Coercing to 1.25")
    lab_text_size <- 1.25 }
  
  # And axis text size
  if(!is.numeric(axis_text_size)){
    warning("'axis_text_size' must be numeric. Coercing to 1")
    axis_text_size <- 1 }
  
  # Warning message when attempting to plot too many groups
  if (base::length(base::unique(groupcol)) > base::min(base::length(colors),
                                                       base::length(shapes),
                                                       base::length(lines))) {
    warning("Insufficient aesthetic values provided. 10 colors/shapes/lines are built into the function but you have supplied ", length(unique(groupcol)), " groups. Please modify 'colors', 'lines', or 'shapes' as needed to provide one value per category in your group column.")
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
    colors_actual <- colors[!base::is.na(base::names(colors))]
    shapes_actual <- shapes[!base::is.na(base::names(shapes))]
    lines_actual <- lines[!base::is.na(base::names(lines))]

    # Continue on to the actual plot creation

    # Create blank plot
    graphics::plot(x = mod$vectors,
         # display = 'sites', choice = c(1, 2), type = 'none',
         main = title,
         xlab = base::paste0("PC1 (",
                             base::round(mod$values$Relative_eig[1] * 100,
                                         digits = 2), "%)"),
         ylab = base::paste0("PC2 (",
                             base::round(mod$values$Relative_eig[2] * 100,
                                         digits = 2), "%)"),
         col = 'white', pch = 1, cex.lab = lab_text_size, cex.axis = axis_text_size)

    # For each group, add points of a unique color and (up to 5 groups) unique shape (only 5 hollow shapes are available so they're recycled 2x each)
    for(level in levels(group_col_fct)){
      graphics::points(x = mod$vectors[group_col_fct == level, 1],
                       y = mod$vectors[group_col_fct == level, 2],
             pch = shapes_actual[level], 
             bg = scales::alpha(colour = colors_actual[level], alpha = pt_alpha),
             cex = pt_size) }

    # With all of the points plotted, add ellipses of matched colors
    # This also allows for variation in line type if desired
    vegan::ordiellipse(ord = mod$vectors, groups = groupcol,
                       col = colors_actual, display = 'sites',
                       kind = 'sd', lwd = 2,
                       lty = lines_actual, label = F)

    # Finally, add a legend
    graphics::legend(x = leg_pos, legend = leg_cont, bty = "n", title = NULL,
           pt.cex = pt_size, pch = shapes_actual, cex = 1.15, pt.bg = colors_actual)
  }
}
