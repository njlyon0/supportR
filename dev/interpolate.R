# Load libraries
librarian::shelf(tidyverse, supportR)

# Clear environment
rm(list = ls())

# Simulate data
df <- data.frame(
  "year" = 2001:2025,
  "group" = c(rep(x = "pre-blank", times = 10),
    rep(x = "blank", times = 7),
    rep(x = "post-blank", times = 8)),
  "value" = c(sample(x = 6:10, size = 10, replace = TRUE),
    rep(x = NA, times = 7),
    sample(x = 1:4, size = 8, replace = TRUE)))

# Plot this
ggplot2::ggplot(df, ggplot2::aes(x = year, y = value, color = group)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm", se = TRUE) +
  supportR::theme_lyon() +
  ggplot2::theme(
    axis.text.x = ggplot2::element_text(angle = 35, hjust = 1))

# End ----
