# Create an Ordination with Ellipses for Groups

Produces a Nonmetric Multidimensional Scaling (NMS) or Principal
Coordinate Analysis (PCoA) for up to 10 groups. Draws an ellipse around
the standard deviation of the points in each group. By default, assigns
a unique color (colorblind-safe) and point shape for each group. If the
user supplies colors/shapes then the function can support more than 10
groups. For NMS ordinations, includes the stress as the legend title
(see
[`?vegan::metaMDS`](https://vegandevs.github.io/vegan/reference/metaMDS.html)
for explanation of "stress"). For PCoA ordinations includes the percent
variation explained parenthetically in the axis labels.

## Usage

``` r
ordination(mod = NULL, grps = NULL, ...)
```

## Arguments

- mod:

  (pcoa \| monoMDS/metaMDS) object returned by
  [`ape::pcoa`](https://rdrr.io/pkg/ape/man/pcoa.html) or
  [`vegan::metaMDS`](https://vegandevs.github.io/vegan/reference/metaMDS.html)

- grps:

  (vector) vector of categorical groups for data. Must be same length as
  number of rows in original data object

- ...:

  additional arguments passed to
  [`graphics::plot`](https://rdrr.io/r/graphics/plot.default.html),
  [`graphics::points`](https://rdrr.io/r/graphics/points.html),
  [`scales::alpha`](https://scales.r-lib.org/reference/alpha.html),
  [`vegan::ordiellipse`](https://vegandevs.github.io/vegan/reference/ordihull.html),
  or [`graphics::legend`](https://rdrr.io/r/graphics/legend.html). Open
  a GitHub Issue if function must support additional arguments

## Value

(plot) base R ordination with an ellipse for each group

## Examples

``` r
# \donttest{
# Use data from the vegan package
utils::data("varespec", package = 'vegan')

# Make some columns of known number of groups
treatment <- c(rep.int("Trt1", (nrow(varespec)/4)),
               rep.int("Trt2", (nrow(varespec)/4)),
               rep.int("Trt3", (nrow(varespec)/4)),
               rep.int("Trt4", (nrow(varespec)/4)))

# And combine them into a single data object
data <- cbind(treatment, varespec)

# Get a distance matrix from the data
dist <- vegan::vegdist(varespec, method = 'kulczynski')

# Perform PCoA / NMS
pcoa_mod <- ape::pcoa(dist)
nms_mod <- vegan::metaMDS(data[-1], autotransform = FALSE, expand = FALSE, k = 2, try = 50)
#> Run 0 stress 0.1000211 
#> Run 1 stress 0.1532704 
#> Run 2 stress 0.1000211 
#> ... New best solution
#> ... Procrustes: rmse 4.862844e-06  max resid 2.072724e-05 
#> ... Similar to previous best
#> Run 3 stress 0.219329 
#> Run 4 stress 0.1000211 
#> ... New best solution
#> ... Procrustes: rmse 3.752602e-06  max resid 1.597952e-05 
#> ... Similar to previous best
#> Run 5 stress 0.1000211 
#> ... Procrustes: rmse 1.470922e-06  max resid 3.396291e-06 
#> ... Similar to previous best
#> Run 6 stress 0.1000211 
#> ... New best solution
#> ... Procrustes: rmse 2.930966e-06  max resid 1.243619e-05 
#> ... Similar to previous best
#> Run 7 stress 0.1000211 
#> ... Procrustes: rmse 1.303887e-06  max resid 4.282714e-06 
#> ... Similar to previous best
#> Run 8 stress 0.1000211 
#> ... Procrustes: rmse 5.381752e-06  max resid 2.331603e-05 
#> ... Similar to previous best
#> Run 9 stress 0.1000211 
#> ... Procrustes: rmse 1.118468e-06  max resid 4.587455e-06 
#> ... Similar to previous best
#> Run 10 stress 0.1605745 
#> Run 11 stress 0.1607501 
#> Run 12 stress 0.1000211 
#> ... Procrustes: rmse 2.2104e-06  max resid 8.730585e-06 
#> ... Similar to previous best
#> Run 13 stress 0.1715395 
#> Run 14 stress 0.1616352 
#> Run 15 stress 0.1607506 
#> Run 16 stress 0.1532704 
#> Run 17 stress 0.1000211 
#> ... Procrustes: rmse 6.781741e-06  max resid 2.931507e-05 
#> ... Similar to previous best
#> Run 18 stress 0.1605745 
#> Run 19 stress 0.1613105 
#> Run 20 stress 0.1000211 
#> ... Procrustes: rmse 3.037287e-06  max resid 1.315775e-05 
#> ... Similar to previous best
#> *** Best solution repeated 7 times

# Create PCoA ordination (with optional agruments)
supportR::ordination(mod = pcoa_mod, grps = data$treatment, 
                     bg = c("red", "blue", "purple", "orange"),
                     lty = 2, col = "black")


# Create NMS ordination
supportR::ordination(mod = nms_mod, grps = data$treatment, alpha = 0.3, 
                     x = "topright", legend = LETTERS[1:4])

# }
```
