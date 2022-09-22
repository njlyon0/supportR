#' @title Complete `ggplot2` Theme for Non-Data Aesthetics
#'
#' @description Custom alternative to the `ggtheme` options built into `ggplot2`. Removes gray boxes and grid lines from plot background. Increases font size of tick marks and axis labels. Removes gray box from legend background and legend key.
#'
#' @param title_size (numeric) size of font in axis titles
#' @param text_size (numeric) size of font in tick labels
#'
#' @export
#'
#' @examples
#'

lyon_theme <- function(title_size = 16, text_size = 13){

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
    axis.text = ggplot2::element_text(size = text_size, color = "black")
  )
}





library(palmerpenguins); library(tidyverse)

p <- penguins %>%
  dplyr::filter(!is.na(bill_length_mm) &
                  !is.na(bill_depth_mm) &
                  !is.na(species) ) %>%
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point() +
  geom_smooth(method = "lm", formula = 'y ~ x', se = F)

p
p + lyon_theme()



title_size <- 16
text_size <- 13

p +
  theme(
    # Customize legend stuff
    legend.title = element_blank(),
    legend.background = element_blank(),
    legend.key = element_rect(color = alpha("white", 0),
                              fill = alpha("white", 0)),
    # Customize background
    panel.grid = element_blank(),
    panel.background = element_blank(),
    # Add in a dark axis line on y & x
    axis.line = element_line(colour = "black"),
    # Increase font size
    axis.title = element_text(size = title_size),
    axis.text = element_text(size = text_size, color = "black")
    )





