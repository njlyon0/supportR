# Publication-Quality Non-metric Multi-dimensional Scaling (NMS) Ordinations

**\[superseded\]**

This function has been superseded by `ordination` because this is just a
special case of that function. Additionally, `ordination` provides users
much more control over the internal `graphics` functions used to create
the fundamental elements of the graph

Produces Non-Metric Multi-dimensional Scaling (NMS) ordinations for up
to 10 groups. Assigns a unique color for each group and draws an ellipse
around the standard deviation of the points. Automatically adds stress
(see
[`vegan::metaMDS`](https://vegandevs.github.io/vegan/reference/metaMDS.html)
for explanation of "stress") as legend title. Because there are only
five hollow shapes (see `?graphics::pch()`) all shapes are re-used a
maximum of 2 times when more than 5 groups are supplied.

## Usage

``` r
nms_ord(
  mod = NULL,
  groupcol = NULL,
  title = NA,
  colors = c("#41b6c4", "#c51b7d", "#7fbc41", "#d73027", "#4575b4", "#e08214", "#8073ac",
    "#f1b6da", "#b8e186", "#8c96c6"),
  shapes = rep(x = 21:25, times = 2),
  lines = rep(x = 1, times = 10),
  pt_size = 1.5,
  pt_alpha = 1,
  lab_text_size = 1.25,
  axis_text_size = 1,
  leg_pos = "bottomleft",
  leg_cont = unique(groupcol)
)
```

## Arguments

- mod:

  (metaMDS/monoMDS) object returned by
  [`vegan::metaMDS`](https://vegandevs.github.io/vegan/reference/metaMDS.html)

- groupcol:

  (dataframe) column specification in the data that includes the groups
  (accepts either bracket or \$ notation)

- title:

  (character) string to use as title for plot

- colors:

  (character) vector of colors (as hexadecimal codes) of length \>=
  group levels (default *not* colorblind safe because of need for 10
  built-in unique colors)

- shapes:

  (numeric) vector of shapes (as values accepted by `pch`) of length \>=
  group levels

- lines:

  (numeric) vector of line types (as integers) of length \>= group
  levels

- pt_size:

  (numeric) value for point size (controlled by character expansion
  i.e., `cex`)

- pt_alpha:

  (numeric) value for transparency of points (ranges from 0 to 1)

- lab_text_size:

  (numeric) value for axis label text size

- axis_text_size:

  (numeric) value for axis tick text size

- leg_pos:

  (character or numeric) legend position, either numeric vector of x/y
  coordinates or shorthand accepted by
  [`graphics::legend`](https://rdrr.io/r/graphics/legend.html)

- leg_cont:

  (character) vector of desired legend entries. Defaults to `unique`
  entries in `groupcol` argument (this argument provided in case syntax
  of legend contents should differ from data contents)

## Value

(plot) base R ordination with an ellipse for each group

## Examples

``` r
# \donttest{
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

# Actually perform multidimensional scaling
mds <- vegan::metaMDS(data[-1], autotransform = FALSE, expand = FALSE, k = 2, try = 50)
#> Run 0 stress 0.1000211 
#> Run 1 stress 0.2180884 
#> Run 2 stress 0.2155121 
#> Run 3 stress 0.1000211 
#> ... Procrustes: rmse 6.851937e-06  max resid 2.606731e-05 
#> ... Similar to previous best
#> Run 4 stress 0.1000211 
#> ... Procrustes: rmse 9.391727e-06  max resid 4.046547e-05 
#> ... Similar to previous best
#> Run 5 stress 0.1000211 
#> ... Procrustes: rmse 1.647936e-05  max resid 7.008866e-05 
#> ... Similar to previous best
#> Run 6 stress 0.1000211 
#> ... New best solution
#> ... Procrustes: rmse 1.272124e-05  max resid 5.523123e-05 
#> ... Similar to previous best
#> Run 7 stress 0.1000211 
#> ... New best solution
#> ... Procrustes: rmse 8.107585e-06  max resid 3.504136e-05 
#> ... Similar to previous best
#> Run 8 stress 0.1000211 
#> ... Procrustes: rmse 1.575297e-06  max resid 6.04963e-06 
#> ... Similar to previous best
#> Run 9 stress 0.1532704 
#> Run 10 stress 0.1000211 
#> ... Procrustes: rmse 1.364599e-06  max resid 5.158543e-06 
#> ... Similar to previous best
#> Run 11 stress 0.1000211 
#> ... Procrustes: rmse 8.31051e-06  max resid 3.558966e-05 
#> ... Similar to previous best
#> Run 12 stress 0.1000211 
#> ... Procrustes: rmse 8.346248e-06  max resid 3.61699e-05 
#> ... Similar to previous best
#> Run 13 stress 0.2148754 
#> Run 14 stress 0.1000211 
#> ... Procrustes: rmse 7.371706e-06  max resid 3.185899e-05 
#> ... Similar to previous best
#> Run 15 stress 0.1607505 
#> Run 16 stress 0.1715395 
#> Run 17 stress 0.1532704 
#> Run 18 stress 0.1000211 
#> ... New best solution
#> ... Procrustes: rmse 2.669231e-06  max resid 1.102027e-05 
#> ... Similar to previous best
#> Run 19 stress 0.2106241 
#> Run 20 stress 0.1613105 
#> *** Best solution repeated 1 times

# With the scaled object and original dataframe we can use this function
nms_ord(mod = mds, groupcol = data$factor_4lvl,
                title = '4-Level NMS', leg_pos = 'topright',
                leg_cont = as.character(1:4))

# }
```
