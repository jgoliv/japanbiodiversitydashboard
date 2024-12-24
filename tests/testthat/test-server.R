library(japanbiodiversitydashboard)
library(testthat)
library(shiny)
library(dplyr)
library(lubridate)

test_that("rc.data() correctly filters data based on the reactive values returned returned by the control module", {

  static_data <<- readRDS(system.file(package = "japanbiodiversitydashboard", "extdata", "data.rds"))

  testServer(server, {

    # testing with default input values
    session$setInputs(
      "controls-year" = c(1976, 2024)
      ,"controls-name" = "All"
    )

    session$getReturned()

    controls <- rc.controls()
    data <- rc.data()

    expect_equal(controls$name, "All")
    expect_equal(controls$year, seq(as_date("1976-01-01"), as_date("2024-01-01"), by = "year"))
    expect_equal(nrow(rc.data()), nrow(static_data))

    # testing with specific input values
    session$setInputs(
      "controls-year" = c(2000, 2023)
      ,"controls-name" = "Corvus macrorhynchos Wagler, 1827 - Large-billed Crow"
    )

    session$getReturned()

    controls <- rc.controls()
    data <- rc.data()

    expected_specific_name <- "Corvus macrorhynchos Wagler, 1827 - Large-billed Crow"
    expected_specific_year <- seq(as_date("2000-01-01"), as_date("2023-01-01"), by = "year")

    expected_specific_filtered_data <-
      static_data |>
      filter(
        name %in% expected_specific_name
        ,year %in% expected_specific_year
      )

    expect_equal(controls$name, expected_specific_name)
    expect_equal(controls$year, expected_specific_year)
    expect_equal(nrow(rc.data()), nrow(expected_specific_filtered_data))
  })
})
