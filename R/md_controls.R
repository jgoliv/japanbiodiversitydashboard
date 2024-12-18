md.controls_UI <- function(id = "controls") {
  ns <- NS(id)

  tagList(
    wd.pickerInput(inputId = ns("name"))
    ,wd.sliderInput(inputId = ns("year"))
  )

}

md.controls <- function(id = "controls", static_data) {
  moduleServer(id, function(input, output, session) {

    observe({
      req(static_data)
      updatePickerInput(session, inputId = "name", choices = c("All", unique(static_data$name)))
    }) |>
      bindEvent(static_data)

    return(
      reactive({

        y_init <- input$year[[1]] |> paste0("-01-01") |> as_date() |> floor_date(unit = "years")
        y_end <- input$year[[2]] |> paste0("-01-01") |> as_date() |> floor_date(unit = "years")

        list(
          year = seq(y_init, y_end, by = "year")
          ,name = input$name
        )

      })
    )

  })
}
