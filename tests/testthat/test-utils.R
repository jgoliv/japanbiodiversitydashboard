library(japanbiodiversitydashboard)
library(testthat)
library(dplyr)

test_that("utils.get_max_obs calculates correct maximum observations", {

  test_data <- tibble(
    category = c("A", "A", "A", "B", "B", "C")
  )

  result <- utils.get_max_obs(test_data, "category")

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 1)
  expect_equal(ncol(result), 4)

  expect_equal(result$category, "A")
  expect_equal(result$n, 3)
  expect_equal(result$pct, 50)
})

test_that("utils.get_max_obs handles ties correctly", {

  tied_data <- tibble(
    category = c("A", "A", "B", "B", "C")
  )

  result <- utils.get_max_obs(tied_data, "category")

  expect_equal(nrow(result), 1)
  expect_true(result$category %in% c("A", "B"))
  expect_equal(result$n, 2)
  expect_equal(result$pct, 40)
})

test_that("utils.get_max_obs handles edge cases", {

  single_category <- tibble(
    category = c("A", "A", "A")
  )

  result <- utils.get_max_obs(single_category, "category")
  expect_equal(result$category, "A")
  expect_equal(result$pct, 100)

  single_row <- tibble(
    category = "A"
  )

  result <- utils.get_max_obs(single_row, "category")
  expect_equal(result$category, "A")
  expect_equal(result$pct, 100)

  empty_data <- tibble(
    category = character()
  )

  result <- utils.get_max_obs(empty_data, "category")

  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
  expect_true(all(c("category", "n", "sum", "pct") %in% names(result)))

  invalid_data <- tibble(
    category = c("A", "B", "C")
  )

  utils.get_max_obs(invalid_data, "non_existent_col") |>
    expect_error()
})
