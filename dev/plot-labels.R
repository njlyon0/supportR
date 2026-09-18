# Load library
library(cowplot)

# Try without italics
plot_labels <- c("Thunnus obesus", "Thunnus alalunga", "Thunnus albacares")

# Make plot
cowplot::ggdraw() + 
  cowplot::draw_plot_label(label = plot_labels, 
    x = c(0, 0.33, 0.66), 
    y = 1, hjust = 0, fontface = "italic")


