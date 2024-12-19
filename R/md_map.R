md.map_UI <- function(id = "map") {
  ns <- NS(id)
  leafletOutput(ns("map"))
}

md.map <- function(id = "map", rc.data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$map <- renderLeaflet({
      plt.leaflet_base_map()
    })

    observe({
      req(rc.data())

      leafletProxy(ns("map")) |>
        clearMarkerClusters() |>
        clearMarkers() |>
        plt.leaflet_add_circle_markers(
          map = _
          ,data = rc.data()
        )

      waiter::waiter_hide()

    }) |>
      bindEvent(rc.data())

  })
}
