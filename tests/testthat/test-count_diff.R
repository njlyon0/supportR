# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-count_diff.R"))

# Error testing
test_that("Errors work as desired", {
  # 'what' is supplied but is not a vector
  expect_error(supportR::count_diff(vec1 = "x", vec2 = "y", what = data.frame("a" = 1:2)))
})

# Warning testing
test_that("Warnings work as desired", {
  # 'what' is not found in either dataframe
  expect_warning(supportR::count_diff(vec1 = "x", vec2 = "y", what = "not in inputs"))
})

# # Message testing
# test_that("Messages work as desired", {
#   # No messages currently in function
# })

# Output testing
test_that("Outputs are as expected", {
  
  # Define inputs
  x1 <- c(1, 1, NA, "a", 1, "a", NA, "x")
  x2 <- c(1, "a", "x")
  
  # Count differences
  diffs <- supportR::count_diff(vec1 = x1, vec2 = x2)
  
  # Should return a dataframe
  expect_equal(class(diffs), "data.frame")
})