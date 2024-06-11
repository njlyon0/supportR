# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-name_vec.R"))

# Error testing
test_that("Errors work as desired", {
  expect_error(name_vec(content = NULL, name = NULL))
  expect_error(name_vec(content = "x", name = NULL))
  expect_error(name_vec(content = NULL, name = "name 1"))
  expect_error(name_vec(content = "x", name = c("name 1", "name 2")))
})

# # Warning testing
# test_that("Warnings work as desired", {
#   # None in function
# })

# # Message testing
# test_that("Messages work as desired", {
#   # None in function
# })

# # Output testing
# test_that("Outputs are as expected", {
# Skipping (for now)
# })
