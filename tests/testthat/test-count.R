# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-count.R"))

# Error testing
test_that("Errors work as desired", {
  expect_error(count(vec = NULL))
  expect_error(count(vec = data.frame("x" = 1:5)))
})

# Warning testing
# test_that("Warnings work as desired", {
#   # No warnings in this function
#   expect_warning()
# })

# Message testing
# test_that("Messages work as desired", {
#   # No messages in this function
#   expect_message()
# })

# Output testing
test_that("Outputs are as expected", {
  
  # Make a testing vector
  test_vec <- c(1, 1, NA, "a", 1, "a", NA, "x")
  
  # Count occurrences
  occ_df <- count(vec = test_vec)
  
  # Check certain aspects of output
  expect_equal(nrow(occ_df), length(unique(test_vec)))
  expect_true(class(occ_df) == "data.frame")
})