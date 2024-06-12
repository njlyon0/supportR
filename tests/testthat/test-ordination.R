# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-ordination.R"))

# Error testing
test_that("Errors work as desired", {
  
  # Necessary prep work
  # Use data from the vegan package
  utils::data("varespec", package = 'vegan')

  # Make some columns of known number of groups
  treatment <- c(rep.int("Trt1", (nrow(varespec)/4)),
                 rep.int("Trt2", (nrow(varespec)/4)),
                 rep.int("Trt3", (nrow(varespec)/4)),
                 rep.int("Trt4", (nrow(varespec)/4)))
  
  # And combine them into a single data object
  data <- cbind(treatment, varespec)
  str(data)
  
  # Get a distance matrix from the data
  dist <- vegan::vegdist(varespec, method = 'kulczynski')
  
  # Perform PCoA / NMS
  pcoa_mod <- ape::pcoa(dist)
  nms_mod <- vegan::metaMDS(data[-1], autotransform = FALSE, expand = FALSE, k = 2, try = 50)
  
  # Actual error testing
  expect_error(ordination(mod = NULL, grps = 1:5))
  expect_error(ordination(mod = nms_mod, grps = NULL))
  expect_error(ordination(mod = pcoa_mod, grps = as.data.frame(1:5)))
  expect_error(ordination(mod = pcoa_mod, grps = unique(data$treatment)))
})

# Warning testing
test_that("Warnings work as desired", {
  
  # Necessary prep work
  # Use data from the vegan package
  utils::data("varespec", package = 'vegan')
  
  # Make some columns of known number of groups
  treatment <- c(rep.int("Trt1", (nrow(varespec)/4)),
                 rep.int("Trt2", (nrow(varespec)/4)),
                 rep.int("Trt3", (nrow(varespec)/4)),
                 rep.int("Trt4", (nrow(varespec)/4)))
  
  # And combine them into a single data object
  data <- cbind(treatment, varespec)
  str(data)
  
  # Get a distance matrix from the data
  dist <- vegan::vegdist(varespec, method = 'kulczynski')
  
  # Perform PCoA / NMS
  pcoa_mod <- ape::pcoa(dist)
  nms_mod <- vegan::metaMDS(data[-1], autotransform = FALSE, expand = FALSE, k = 2, try = 50)
  
  # Actual warning testing
  expect_warning(ordination(mod = nms_mod, grps = data$treatment, bad_arg = 555))
})

# Message testing
# test_that("Messages work as desired", {
#   # No messages in function
# })

# # Output testing
# test_that("Outputs are as expected", {
#   # No output testing yet (should just make a base plot)
# })
