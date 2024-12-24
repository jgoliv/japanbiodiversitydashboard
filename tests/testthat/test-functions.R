library(japanbiodiversitydashboard)
library(testthat)
library(dplyr)

test_that("f.ranking calculates correct top 5", {

  test_data <- tibble(
    name = c(
      "Species A", "Species B", "Species A", "Species C",
      "Species B", "Species D", "Species E", "Species A"
    )
    ,individual_count = c(3, 2, 1, 5, 3, 1, 4, 2)
  )

  result <- f.ranking(test_data)

  expect_s3_class(result, "tbl_df")
  expect_equal(ncol(result), 2)
  expect_lte(nrow(result), 5)
  expect_equal(result$name[1], "Species A")
  expect_equal(result$observations[1], 6)
  expect_true(all(diff(result$observations) <= 0)) # descending order
})

test_that("f.ranking handles edge cases", {

  small_data <- tibble(
    name = c("Species A", "Species B", "Species A")
    ,individual_count = c(1, 2, 3)
  )

  result_small <- f.ranking(small_data)
  expect_equal(nrow(result_small), 2)

  tied_data <- tibble(
    name = c("Species A", "Species B", "Species C")
    ,individual_count = c(5, 5, 5)
  )

  result_tied <- f.ranking(tied_data)
  expect_equal(nrow(result_tied), 3)
  expect_equal(unique(result_tied$observations), 5)

  single_data <- tibble(
    name = c("Species A", "Species A")
    ,individual_count = c(1, 2)
  )

  result_single <- f.ranking(single_data)
  expect_equal(nrow(result_single), 1)
  expect_equal(result_single$observations, 3)

  empty_data <- tibble(
    name = character(0)
    ,individual_count = numeric(0)
  )

  result_empty <- f.ranking(empty_data)
  expect_equal(nrow(result_empty), 0)
  expect_s3_class(result_empty, "tbl_df")

  invalid_data <- tibble(
    wrong_column = c("A", "B")
    ,individual_count = c(1, 2)
  )

  expect_error(f.ranking(invalid_data))

  na_data <- tibble(
    name = c("Species A", "Species B", NA)
    ,individual_count = c(1, 2, 3)
  )

  result_na <- f.ranking(na_data)
  expect_true(all(!is.na(result_na$name)))
})

test_that("f.timeline calculates correct yearly observations", {

  test_data <- tibble(
    year = c(2020, 2020, 2021, 2022, 2022, 2022)
    ,individual_count = c(3, 2, 1, 5, 3, 1)
  )

  years <- 2020:2023  # including a year with no observations

  result <- f.timeline(test_data, years)

  expect_s3_class(result, "tbl_df")
  expect_equal(ncol(result), 2)
  expect_named(result, c("Year", "Observations"))
  expect_equal(nrow(result), length(years))

  expected_results <- tibble(
    Year = 2020:2023,
    Observations = c(5, 1, 9, 0)
  )

  expect_equal(result, expected_results)
})

test_that("f.timeline handles edge cases", {

  single_year_data <- tibble(
    year = c(2020, 2020)
    ,individual_count = c(1, 2)
  )

  years_single <- 2020

  result_single <- f.timeline(single_year_data, years_single)

  expect_equal(nrow(result_single), 1)
  expect_equal(result_single$Observations, 3)

  empty_years_data <- tibble(
    year = c(2018, 2018)
    ,individual_count = c(1, 2)
  )

  years_empty <- 2020:2021

  result_empty_years <- f.timeline(empty_years_data, years_empty)

  expect_equal(nrow(result_empty_years), 3) # the complete should work

  result_empty_years_obs <-
    result_empty_years |>
    filter(Year %in% years_empty)

  expect_true(all(result_empty_years_obs$Observations == 0)) # the completed data should have 0 observations

  empty_data <- tibble(
    year = numeric()
    ,individual_count = numeric()
  )

  years_empty_data <- 2020:2021

  result_empty_data <- f.timeline(empty_data, years_empty_data)

  expect_equal(nrow(result_empty_data), 2) # the complete should work on empty data
  expect_true(all(result_empty_data$Observations == 0))
})

test_that("f.metrics calculates correct summary metrics", {

  test_data <- tibble(
    individual_count = c(2, 3, 1)
    ,day = as_date(c("2019-01-15", "2018-06-20", "1998-05-08"))
    ,life_stage = c("adult", "adult", "unknown")
    ,sex = c("female", "male", "undefined")
    ,locality = c("place 1", "place 2", "place 2")
  )

  result <- f.metrics(test_data)

  expect_s3_class(result, "tbl_df")
  expect_equal(ncol(result), 2)
  expect_named(result, c("name", "value"))
  expect_equal(nrow(result), 5)

  expect_equal(
    result |> filter(name %in% "Observations:") |>  pull(value)
    ,"6"
  )

  expect_equal(
    result |> filter(name %in% "Observed period:") |> pull(value)
    ,"from 05/1998 to 01/2019"
  )

  expect_match(
    result |> filter(name %in% "Most observed life stage:") |> pull(value)
    ,"adult \\(66.7%\\)"
  )

  expect_match(
    result |> filter(name %in% "Most observed sex:") |> pull(value)
    ,"female \\(33.3%\\)"
  )

  expect_match(
    result |> filter(name %in% "Most frequent locality:") |> pull(value)
    ,"place 2 \\(66.7%\\)"
  )
})

test_that("f.metrics handles edge cases", {

  single_data <- tibble(
    individual_count = 1
    ,day = as_date("2013-01-15")
    ,life_stage = "adult"
    ,sex = "female"
    ,locality = "place 1"
  )

  result_single <- f.metrics(single_data)

  expect_equal(
    result_single |> filter(name %in% "Observations:") |> pull(value)
    ,"1"
  )

  expect_equal(
    result_single |> filter(name %in% "Observed period:") |> pull(value)
    ,"from 01/2013 to 01/2013"
  )

  expect_match(
    result_single |> filter(name %in% "Most observed life stage:") |> pull(value)
    ,"adult \\(100%\\)"
  )

  expect_match(
    result_single |> filter(name %in% "Most observed sex:") |> pull(value)
    ,"female \\(100%\\)"
  )

  expect_match(
    result_single |> filter(name %in% "Most frequent locality:") |> pull(value)
    ,"place 1 \\(100%\\)"
  )

  same_day_data <- tibble(
    individual_count = c(1, 2)
    ,day = as_date(c("2018-01-15", "2018-01-15"))
    ,life_stage = c("adult", "adult")
    ,sex = c("female", "female")
    ,locality = c("place 1", "place 1")
  )

  result_same_day <- f.metrics(same_day_data)

  expect_equal(
    result_same_day |> filter(name %in% "Observed period:") |> pull(value)
    ,"from 01/2018 to 01/2018"
  )
})

test_that("f.scientific_info returns correct structure", {

  test_data <- tibble(
    scientific_name = "Panthera onca"
    ,vernacular_name = "Jaguar"
    ,taxon_rank = "species"
    ,kingdom = "Animalia"
    ,family = "Felidae"
  )

  result <- f.scientific_info(test_data)

  expect_s3_class(result, "tbl_df")
  expect_equal(ncol(result), 2)
  expect_named(result, c("name", "value"))
  expect_equal(nrow(result), 4)
})

test_that("f.scientific_info handles edge cases", {

  dup_data <- tibble(
    scientific_name = c("Panthera onca", "Panthera onca")
    ,vernacular_name = c("Jaguar", "Jaguar")
    ,taxon_rank = c("species", "species")
    ,kingdom = c("Animalia", "Animalia")
    ,family = c("Felidae", "Felidae")
  )

  result_dup <- f.scientific_info(dup_data)
  expect_equal(nrow(result_dup), 4)
  expect_equal(ncol(result_dup), 2)

  na_data <- tibble(
    scientific_name = "Panthera onca"
    ,vernacular_name = NA_character_
    ,taxon_rank = "species"
    ,kingdom = NA_character_
    ,family = "Felidae"
  )

  result_na <- f.scientific_info(na_data)

  na_count <- result_na |> filter(is.na(value)) |> nrow()
  expect_equal(na_count, 2)

  empty_data <- tibble(
    scientific_name = "Panthera onca"
    ,vernacular_name = ""
    ,kingdom = ""
    ,family = "Felidae"
  )

  result_empty <- f.scientific_info(empty_data)

  empty_value <-
    result_empty |>
    filter(name %in% c("Vernacular name:", "Kingdom:")) |>
    pull(value) |>
    unique()

  expect_equal(empty_value, "")
})

# f.distribuction() is just a summarise, so we'll not perform tests on it
