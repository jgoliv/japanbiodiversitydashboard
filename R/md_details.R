md.details_UI <- function(id = "ranking") {
  ns <- NS(id)

  tagList(
    uiOutput(ns("title"))
    ,uiOutput(ns("details"))
  )

}

md.details <- function(id = "ranking", rc.data, rc.controls) {
  moduleServer(id, function(input, output, session) {

    rc.title <- reactive({
      req(rc.controls()$name)

      if(rc.controls()$name %in% "All")
        title <- "Species ranking on the period"
      else
        title <- "Scientific info"

      title
    }) |>
      bindCache(rc.controls()$name)

    output$title <- renderUI({
      req(rc.title())
      wd.title(title = rc.title())
    })

    rc.output <- reactive({
      req(rc.data(), rc.controls())

      if(rc.controls()$name %in% "All") {

        output <-
          rc.data() |>
          f.ranking() |>
          plt.ranking()

      } else {

        if(nrow(rc.data()) == 0) {
          output <- p("No data avaliable for this period", style = "font-size: 14px; text-align: center;")
        } else {
          output <-
            layout_column_wrap(
              max_height = "18vh"
              ,f.scientific_info(x = rc.data()) |> plt.info()
              ,f.distribution(x = rc.data()) |> plt.distribution()
            )
        }

      }

      output
    }) |>
      bindCache(rc.data(), rc.controls())

    output$details <- renderUI({
      req(rc.output())
      rc.output()
    })

  })
}
