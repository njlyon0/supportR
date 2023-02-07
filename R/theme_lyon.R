#' @title Complete `ggplot2` Theme for Non-Data Aesthetics
#'
#' @description Custom alternative to the `ggtheme` options built into `ggplot2`. Removes gray boxes and grid lines from plot background. Increases font size of tick marks and axis labels. Removes gray box from legend background and legend key. Removes legend title.
#'
#' @param title_size (numeric) size of font in axis titles
#' @param text_size (numeric) size of font in tick labels
#'
#' @return (ggplot theme) list of ggplot2 theme elements
#'
#' @export
#'
theme_lyon <- function(title_size = 16, text_size = 13){

  # Error out if font sizes aren't numeric
  if(!is.numeric(title_size) | !is.numeric(text_size))
    stop("Font sizes must be specified by numeric values")

  # Actually run the function
  ggplot2::theme(
    # Customize legend stuff
    legend.title = ggplot2::element_blank(),
    legend.background = ggplot2::element_blank(),
    legend.key = ggplot2::element_rect(
      color = ggplot2::alpha("white", 0),
      fill = ggplot2::alpha("white", 0)),
    # Customize background
    panel.grid = ggplot2::element_blank(),
    panel.background = ggplot2::element_blank(),
    # Add in a dark axis line on y & x
    axis.line = ggplot2::element_line(colour = "black"),
    # Increase font size
    axis.title = ggplot2::element_text(size = title_size),
    axis.text = ggplot2::element_text(size = text_size,
                                      color = "black") )
  }
