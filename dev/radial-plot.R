# Libraries
librarian::shelf(tidyverse, supportR)

# Faux data
(df <- data.frame(gp = rep(x = "x", times = 4),
  cat = LETTERS[1:4],
  val = c(9, 9, 2, 0),
  val_x = c(-10, 10, 10, -10)) )

# Plot
ggplot2::ggplot(df, ggplot2::aes(x = val_x, y = val)) +
  ggplot2::geom_path(aes(group = gp), lwd = 0.15) +
  ggplot2::geom_point(aes(fill = cat), pch = 21, size = 3) +
  ggplot2::geom_vline(xintercept = 0) +
  ggplot2::geom_hline(yintercept = 1) +
  ggplot2::xlim(-10, 10) + 
  ggplot2::ylim(-10, 10) +
  # coord_polar(start = 4.7) +
  ggplot2::scale_fill_manual(values = c("A" = "blue", "B" = "green", "C" = "red", "D" = "gold")) +
  ggplot2::theme(legend.position = "none",
    axis.title = ggplot2::element_blank(),
    axis.text = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank(),
    panel.background = ggplot2::element_blank())

# End ----
