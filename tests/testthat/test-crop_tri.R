# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-crop_tri.R"))

# Error testing
test_that("Errors work as desired", {
  expect_error(crop_tri(data = NULL))
  
  # Make a testing matrix
  mat <- matrix(data = c(1:2, 2:1), nrow = 2, ncol = 2)
  
  # More testing
  expect_error(crop_tri(data = mat, drop_tri = NULL, drop_diag = FALSE))
  expect_error(crop_tri(data = mat, drop_tri = c("upper", "lower"), drop_diag = FALSE))
  expect_error(crop_tri(data = mat, drop_tri = "both", drop_diag = FALSE))
})

# Warning testing
test_that("Warnings work as desired", {
  
  # Make a testing matrix
  mat <- matrix(data = c(1:2, 2:1), nrow = 2, ncol = 2)
  
  # Malformed logical warning
  expect_warning(crop_tri(data = mat, drop_tri = "upper", drop_diag = "true"))
})

# # Message testing
# test_that("Messages work as desired", {
#   # No messages in this function
#   expect_message()
# })

# Output testing
test_that("Outputs are as expected", {
  
  # Make a testing matrix
  mat <- matrix(data = c(1:2, 2:1), nrow = 2, ncol = 2)
  
  # Crop to one triangle
  cropped_mat <- crop_tri(data = mat, drop_tri = "upper", drop_diag = TRUE)
  
  # Simple outputs testing
  expect_equal(class(mat), class(cropped_mat))
})