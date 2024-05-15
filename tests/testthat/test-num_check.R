# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-num_check.R"))

# Error testing
test_that("Errors work as desired", {
  
  # Make a dataframe to test the function
  fish <- data.frame("species" = c("salmon", "bass", "halibut", "eel"), 
                     "count" = c(1, "14x", "_23", 12), 
                     "num_col2" = c("a", "2", "4", "0"), 
                     "third_count" = c(NA, "Y", "typo", "2"))
  
  # Inputs checking
  expect_error(num_check(data = NULL, col = "count"))
  expect_error(num_check(data = fish, col = NULL))
  expect_error(num_check(data = as.matrix(fish), col = "count"))
})

# # Warning testing
# test_that("Warnings work as desired", {
#   # No warnings in this function
#   expect_warning()
# })

# Message testing
test_that("Messages work as desired", {
  
  # Make a dataframe to test the function
  fish <- data.frame("species" = c("salmon", "bass", "halibut", "eel"), 
                     "count" = c(1, "14x", "_23", 12), 
                     "num_col2" = c("a", "2", "4", "0"), 
                     "third_count" = c(NA, "Y", "typo", "2"))
  
  # Primary output is the message produced my malformed entries
  expect_message(num_check(data = fish, col = c("count")))
})

# Output testing
test_that("Outputs are as expected", {
  
  # Make a dataframe to test the function
  fish <- data.frame("species" = c("salmon", "bass", "halibut", "eel"), 
                     "count" = c(1, "14x", "_23", 12), 
                     "num_col2" = c("a", "2", "4", "0"), 
                     "third_count" = c(NA, "Y", "typo", "2"))
  
  # Identify malformed entries
  bad_values <- suppressMessages(num_check(data = fish, col = c("count", "num_col2", "third_count")))
  
  # Output testing
  expect_equal(class(bad_values), "list")
})
