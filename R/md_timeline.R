md.timeline_UI <- function(id = "timeline") {
  ns <- NS(id)
  tagList(
    wd.title(
      title = "Timeline"
      ,subtitle = "Marker: max value; Line: average value"
    )
    ,uiOutput(ns("timeline"))
  )
}

md.timeline <- function(id = "timeline", rc.data, rc.controls) {
  moduleServer(id, function(input, output, session) {

    rc.timeline <- reactive({
      req(rc.data(), rc.controls()$year, rc.controls()$name)

      data <- tibble()

      if(nrow(rc.data()) > 0) {
        data <- f.timeline(x = rc.data(), years = rc.controls()$year)
      }

      data
    }) |>
      bindCache(rc.controls()$year, rc.controls()$name)

    output$timeline <- renderUI({
      req(rc.timeline())

      output <- p("No data avaliable for this period", style = "font-size: 14px; text-align: center;")

      if(nrow(rc.data()) > 0) {
        output <- rc.timeline() |> plt.timeline()
      }

      output
    })

  })
}
