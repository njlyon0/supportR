# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-date_check.R"))

# Error testing
test_that("Errors work as desired", {
  
  # Make a dataframe to test the function
  sites <- data.frame("site" = c("LTR", "GIL", "PYN", "RIN"), 
                      "first_visit" = c("2021-01-01", "2021-01-0w", "1990", "2020-10-xx"), 
                      "second" = c("1880-08-08", "2021-01-02", "1992", "2049-11-01"), 
                      "third" = c("2022-10-31", "tomorrow", "1993", NA))
  
  # Inputs checking
  expect_error(date_check(data = NULL, col = "first_visit"))
  expect_error(date_check(data = sites, col = NULL))
  expect_error(date_check(data = as.matrix(sites), col = "first_visit"))
})

# # Warning testing
# test_that("Warnings work as desired", {
#   # No warnings in this function
#   expect_warning()
# })

# Message testing
test_that("Messages work as desired", {
  
  # Make a dataframe to test the function
  sites <- data.frame("site" = c("LTR", "GIL", "PYN", "RIN"), 
                      "first_visit" = c("2021-01-01", "2021-01-0w", "1990", "2020-10-xx"), 
                      "second" = c("1880-08-08", "2021-01-02", "1992", "2049-11-01"), 
                      "third" = c("2022-10-31", "tomorrow", "1993", NA))
  
  # Primary output is the message produced my malformed entries
  expect_message(date_check(data = sites, col = c("first_visit")))
})

# Output testing
test_that("Outputs are as expected", {
  
  # Make a dataframe to test the function
  sites <- data.frame("site" = c("LTR", "GIL", "PYN", "RIN"), 
                      "first_visit" = c("2021-01-01", "2021-01-0w", "1990", "2020-10-xx"), 
                      "second" = c("1880-08-08", "2021-01-02", "1992", "2049-11-01"), 
                      "third" = c("2022-10-31", "tomorrow", "1993", NA))
  
  # Identify malformed entries
  bad_values <- suppressMessages(date_check(data = sites, col = c("first_visit", "second", "third")))
  
  # Output testing
  expect_equal(class(bad_values), "list")
})
