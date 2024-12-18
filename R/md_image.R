md.image_UI <- function(id = "image") {
  ns <- NS(id)
  uiOutput(ns("img"))
}

md.image <- function(id = "image", rc.data, rc.controls = rc.controls) {
  moduleServer(id, function(input, output, session) {

    rc.src <- reactive({
      req(rc.data(), rc.controls())

      src = "img/logo.svg"

      if((!rc.controls()$name %in% "All") & nrow(rc.data()) != 0) {
        url <- rc.data()$url[[1]]
        if(!is.na(url)) src = url
      }

      src
    }) |>
      bindCache(rc.data(), rc.controls()$name)

    output$img <- renderUI({
      req(rc.src())

      output <-
        tags$img(
          style = "width: 100%; height: 100%;"
          ,src = rc.src()
        )

      output
    })

  })
}
