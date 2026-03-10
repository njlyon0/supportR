# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-spellcheck_quarto.R"))

# Error testing
test_that("Errors work as desired", {
  expect_error(supportR::spellcheck_quarto(path = NULL, quiet = TRUE))
  expect_error(supportR::spellcheck_quarto(path = 10, quiet = TRUE))
  expect_error(supportR::spellcheck_quarto(path = c("x", "y"), quiet = TRUE))
})

# Warning testing
test_that("Warnings work as desired", {
  expect_warning(supportR::spellcheck_quarto(path = getwd(), quiet = "please"))
})

# Message testing
# test_that("Messages work as desired", {
#   # Messages only returned if Quarto files are present so hard to test in this context
#   expect_message()
# })

# Output testing
test_that("Outputs are as expected", {
  
  check_df <- supportR::spellcheck_quarto(path = getwd(), quiet = TRUE)
  
  # Test various facets of output
  expect_true(class(check_df) == "data.frame")
})
