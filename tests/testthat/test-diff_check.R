# Run all tests in this script:
## testthat::test_file(file.path("tests", "testthat", "test-diff_check.R"))

# Error testing
test_that("Errors work as desired", {
  
   # Make two vectors
   vec1 <- c("x", "a", "b")
   vec2 <- c("y", "z", "a")
  
   # Inputs testing
   expect_error(diff_check(old = NULL, new = vec2, sort = TRUE, return = TRUE))
   expect_error(diff_check(old = vec1, new = NULL, sort = TRUE, return = TRUE))
   expect_error(diff_check(old = as.data.frame(vec1), new = vec2, sort = TRUE, return = TRUE))
   expect_error(diff_check(old = vec1, new = as.data.frame(vec2), sort = TRUE, return = TRUE))
})

# Warning testing
test_that("Warnings work as desired", {
  
  # Make two vectors
  vec1 <- c("x", "a", "b")
  vec2 <- c("y", "z", "a")
  
  # Expected warning contexts
  expect_warning(diff_check(old = vec1, new = vec2, sort = "true", return = TRUE))
  expect_warning(diff_check(old = vec1, new = vec2, sort = TRUE, return = "true"))
})

# Message testing
test_that("Messages work as desired", {

  # Make two vectors
  vec1 <- c("x", "a", "b")
  vec2 <- c("y", "z", "a")
  
  # Expected message contexts
  expect_message(diff_check(old = vec1, new = vec2, sort = FALSE, return = FALSE))
})

# Output testing
test_that("Outputs are as expected", {
  
  # Make two vectors
  vec1 <- c("x", "a", "b")
  vec2 <- c("y", "z", "a")
  
  # Compare
  diff_out <- diff_check(old = vec1, new = vec2, sort = FALSE, return = TRUE)
  
  # Expected outputs
  expect_equal(class(diff_out), "list")
})