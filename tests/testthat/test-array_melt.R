# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-array_melt.R"))

# Error testing
test_that("Errors work as desired", {
  expect_error(array_melt(array = NULL))
  expect_error(array_melt(array = data.frame("x" = 1:3)))
})

# # Warning testing
# test_that("Warnings work as desired", {
#   # No warnings in this function
#   expect_warning()
# })

# # Message testing
# test_that("Messages work as desired", {
#   # No messages in this function
#   expect_message()
# })

# Output testing
test_that("Outputs are as expected", {
  
  # Make data to fill the array
  vec1 <- c(5, 9, 3)
  vec2 <- c(10:15)
  
  # Create dimension names (x = col, y = row, z = which matrix)
  x_vals <- c("Col_1","Col_2","Col_3")
  y_vals <- c("Row_1","Row_2","Row_3")
  z_vals <- c("Mat_1","Mat_2")
  
  # Make an array from these components
  g <- array(data = c(vec1, vec2), dim = c(3, 3, 2),
             dimnames = list(x_vals, y_vals, z_vals))
  
  # "Melt" the array into a dataframe
  melted_df <- array_melt(array = g)
  
  # Test various facets of output
  expect_true(class(melted_df) == "data.frame")
})
