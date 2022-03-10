#' @title Publication-Quality Principal Coordinates Analysis (PCoA) Ordinations
#' @description Produces Principal Coordinates Analysis (PCoA) ordinations for up to 10 groups. Assigns a unique color for each group and draws an ellipse around the standard deviation of the points. Automatically adds percent of variation explained by first two principal component axes parenthetically to axis labels. Because there are only five hollow shapes (see `?graphics::pch()`) all shapes are re-used a maximum of 2 times when more than 5 groups are supplied.
#'
#' @param mod Object returned by `ape::pcoa()`
#' @param groupcol Column in the data that includes the groups
#' @param title Character string to use as title for plot
#' @param colors Vector of colors (as hexadecimal codes) of length >= group levels (currently *not* colorblind safe because of need for 10 built-in unique colors)
#' @param lines Vector of line types (as integers) of length >= group levels
#' @param leg_pos Legend position, either numeric vector of x/y coordinates or shorthand accepted by `graphics::legend()`
#' @param leg_cont Concatenated vector of desired legend entries. Defaults to unique entries in "groupcol" argument (this argument provided in case syntax of legend contents should differ from data contents)
#'
#' @export
#'
#' @examples
#'
#'
#' # Use data from the vegan package
#' utils::data("varespec", package = 'vegan')
#' resp <- varespec
#'
#' # Make some columns of known number of groups
#' factor_2lvl <- c(rep.int("Trt1", (nrow(resp)/2)),
#'                  rep.int("Trt2", (nrow(resp)/2)))
#' factor_4lvl <- c(rep.int("Trt1", (nrow(resp)/4)),
#'                  rep.int("Trt2", (nrow(resp)/4)),
#'                  rep.int("Trt3", (nrow(resp)/4)),
#'                  rep.int("Trt4", (nrow(resp)/4)))
#' factor_6lvl = c(rep.int("Trt1", (nrow(resp)/6)),
#'                 rep.int("Trt2", (nrow(resp)/6)),
#'                 rep.int("Trt3", (nrow(resp)/6)),
#'                 rep.int("Trt4", (nrow(resp)/6)),
#'                 rep.int("Trt5", (nrow(resp)/6)),
#'                 rep.int("Trt6", (nrow(resp)/6)))
#' factor_over <- (1:nrow(resp))
#'
#' # And combine them into a single data object
#' data <- cbind(factor_over, factor_2lvl, factor_4lvl, factor_6lvl, resp)
#'
#' # Get a distance matrix from the data
#' dist <- vegan::vegdist(resp, method = 'kulczynski')
#'
#' # Perform a PCoA on the distance matrix to get points for an ordination
#' pnts <- ape::pcoa(dist)
#'
#' # Test the function for 4 groups
#' helpR::pcoa_ord(pnts, data$factor_4lvl)
#'
#' # Look what happens if you go over the supported number of groups:
#' helpR::pcoa_ord(pnts, data$factor_over)
#'
pcoa_ord <- function(mod, groupcol, title = NA,
                    colors = c('#c51b7d', '#7fbc41', '#d73027', '#4575b4',
                               '#e08214', '#8073ac', '#f1b6da', '#b8e186',
                               '#8c96c6', '#41b6c4'),
                    lines = rep(1, 10),
                    leg_pos = 'bottomleft', leg_cont = unique(groupcol)) {
  # Limiting (for now) to only 10 groups
  if (length(unique(groupcol)) > 10) {
        print('Plotting >10 groups is not supported. Run `unique` on your factor column if you believe there are fewer than 10 groups')
  } else {

    # Before actually creating the plot we need to make sure our colors/shapes/lines are correctly formatted

    # Create vector of shapes
    shapes <- c(21, 22, 23, 24, 25, 21, 22, 23, 24, 25)

    # Identify the names of the groups in the data
    groups <- as.vector(unique(groupcol))

    # Assign names to the vectors of colors/shapes/lines
    names(colors) <- groups
    names(shapes) <- groups
    names(lines) <- groups

    # Crop all three vectors to the length of groups in the data
    colors_actual <- colors[!is.na(names(colors))]
    shapes_actual <- shapes[!is.na(names(shapes))]
    lines_actual <- lines[!is.na(names(lines))]

    # Continue on to the actual plot creation

    # Create blank plot
    graphics::plot(mod$vectors,
         # display = 'sites', choice = c(1, 2), type = 'none',
         main = title,
         xlab = paste0("PC1 (", round(mod$values$Relative_eig[1] * 100, digits = 2), "%)"),
         ylab = paste0("PC2 (", round(mod$values$Relative_eig[2] * 100, digits = 2), "%)"))

    # Create a counter set to 1 (we'll need it in a moment)
    k <- 1

    # For each group, add points of a unique color and (up to 5 groups) unique shape (only 5 hollow shapes are available so they're recycled 2x each)
    for(level in unique(groupcol)){
      graphics::points(mod$vectors[groupcol == level, 1], mod$vectors[groupcol == level, 2],
             pch = shapes_actual[k], bg = colors_actual[k])

      # After each group's points are created, advance the counter by 1 to move the earlier part of the loop to a new color/shape
      k <- k + 1 }

    # With all of the points plotted, add ellipses of matched colors
    # This also allows for variation in line type if desired
    vegan::ordiellipse(mod$vectors, groupcol, col = colors_actual,
                       display = 'sites', kind = 'sd', lwd = 2,
                       lty = lines_actual, label = F)

    # Finally, add a legend
    graphics::legend(leg_pos, legend = leg_cont, bty = "n", title = NULL,
           pch = shapes_actual, cex = 1.15, pt.bg = colors_actual)
  }
}
