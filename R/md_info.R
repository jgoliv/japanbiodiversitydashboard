md.info_UI <- function(id = "info") {
  ns <- NS(id)

  tagList(
    uiOutput(ns("title"))
    ,reactableOutput(ns("info"))
  )

}

md.info <- function(id = "info", rc.data, rc.controls) {
  moduleServer(id, function(input, output, session) {

    rc.title <- reactive({
      req(rc.controls()$name)

      if(rc.controls()$name %in% "All")
        title <- "General informations"
      else
        title <- rc.controls()$name

      title
    }) |>
      bindCache(rc.controls()$name)

    output$title <- renderUI({
      req(rc.title())
      wd.title(title = rc.title())
    })

    rc.info <- reactive({
      req(rc.data())

      if(nrow(rc.data()) > 0)
        output <- f.metrics(rc.data())
      else
       output <- tibble(name = character(), value = character())

      output
    }) |>
      bindCache(rc.data())

    output$info <- renderReactable({
      req(rc.info())
      plt.info(rc.info())
    })

  })
}
