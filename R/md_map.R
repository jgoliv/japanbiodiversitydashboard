md.map_UI = function(id = "map") {
  ns <- NS(id)
  leafletOutput(ns("map"))
}

md.map = function(id = "map", rc.data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    bins <- c(1, 10, 50, 200, 500, 1000, 5000, 10000, Inf)
    bin_pal <- colorBin(palette = fx.palette, domain = bins[-length(bins)], bins = bins)
    radius_scale <- \(x) scales::rescale(log1p(x), to = c(10, 60))

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
          ,radius_scale = radius_scale
          ,bin_pal = bin_pal
        )

      waiter::waiter_hide()

    }) |>
      bindEvent(rc.data())

  })
}
