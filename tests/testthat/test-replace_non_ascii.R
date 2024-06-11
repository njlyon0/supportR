# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-replace_non_ascii.R"))

# Error testing
test_that("Errors work as desired", {
  expect_error(replace_non_ascii(x = NULL, include_letters = FALSE))
  expect_error(replace_non_ascii(x = 10, include_letters = FALSE))
})

# Warning testing
test_that("Warnings work as desired", {
  expect_warning(replace_non_ascii(x = "aaa", include_letters = "false"))
})

# Message testing
# test_that("Messages work as desired", {
#   # None in function
# })

# # Output testing
# test_that("Outputs are as expected", {
#   # Skipping (for now)
# })
