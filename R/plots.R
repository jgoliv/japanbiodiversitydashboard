plt.base_reactable <- function(x, page_size = 8, col_list = NULL) {
  reactable(
    x
    ,defaultPageSize = page_size
    ,resizable = TRUE,
    ,showPageInfo = FALSE,
    ,borderless = FALSE,
    ,highlight = TRUE,
    ,compact = TRUE,
    ,theme = fx.reactable_theme
    ,language = reactableLang(noData = "No data avaliable for this period")
    ,columns = col_list
  )
}

plt.info <- function(x) {
  col_list <-
    list(
      name = colDef(style = list(fontWeight = "bolder", fontSize = "12px"))
      ,value = colDef(style = list(fontWeight = "bolder", fontSize = "12px", color = "#E87A90"))
    )
  plt.base_reactable(x = x, col_list = col_list)
}

plt.ranking <- function(x) {

  col_list <-
    list(
      observations = colDef(
        cell =
          data_bars(
            data = x
            ,fill_color = fx.palette
            ,background = 'grey90'
            ,text_size = 12
            ,text_position = 'outside-end'
            ,text_color = '#333'
            ,bold_text = FALSE
            ,round_edges = TRUE
          )
        ,align = 'center'
      )
      ,name = colDef(style = list(fontWeight = "bolder", fontSize = "12px"))
    )

  plt.base_reactable(x = x, col_list = col_list)
}

plt.distribution <- function(x) {
  x |>
    e_charts() |>
    e_boxplot(
      Count
      ,outliers = FALSE
      ,itemStyle = list(color = "#F8C3CD", borderColor = "#E87A90")
    ) |>
    e_title(
      text = "Distribution"
      ,subtext = "Non null yearly individual counts"
      ,textStyle = list(fontFamily = "FiraSans-Regular", color = "#333")
      ,subtextStyle = list(fontFamily = "FiraSans-Regular", color = "#E87A90")
    ) |>
    e_tooltip(trigger = "item", position = "inside") |>
    e_x_axis(type = "value") |>
    e_y_axis(type = "category", show = FALSE)
}

plt.timeline <- function(x) {
  x |>
    e_charts(Year) |>
    e_bar(
      Observations
      ,lineStyle = list(opacity = 0.85, width = 1.5)
      ,itemStyle = list(opacity = 1)
      ,symbol = "roundRect"
      ,legend = list(show = FALSE)
    ) |>
    e_x_axis(axisLabel = list(fontSize = 10)) |>
    e_y_axis(axisLabel = list(fontSize = 10)) |>
    e_tooltip(trigger = 'axis') |>
    e_mark_point(data = list(name = "Max", type = "max")) |>
    e_mark_line(data = list(name = "Mean", type = "average"), precision = 0) |>
    e_toolbox(emphasis = list(iconStyle = list(color = "#E87A90", borderColor = "#E87A90"))) |>
    e_toolbox_feature(feature = "magicType", type = list("line", "bar")) |>
    e_toolbox_feature(feature = "dataZoom") |>
    e_color(c("#E87A90"))
}

plt.intro <- function() {

  tagList(

    wd.title(
      title = "Biodiversity Dashboard"
      ,subtitle = "Diving into Japan's nature"
      ,title_font_size = "36px"
      ,subtitle_font_size = "20px"
    )

    ,p(
      style = "text-align: justify; line-height: 1.2; font-size: 14px;"
      ,"This dashboard displays the biodiversity data of Japan along the years of 1984 to 2020,
      including observations of over several different species, and was made using the "
      ,tags$a(
        href = "https://www.gbif.org/occurrence/search?dataset_key=8a863029-f435-446a-821e-275f4f641165"
        ,target = "_blank"
        ,"occurrence dataset"
      )
      ," from the "
      ,tags$a(href = "https://www.gbif.org/", target = "_blank", "Global Biodiversity Information Facility (GBIF), ")
      ,"an international network and data infrastructure which aims to provide open access to data about all types of life on Earth."
    )
  )

}

plt.leaflet_base_map <- function() {
  leaflet() |>
    leaflet(options = leafletOptions(minZoom = 5)) |>
    setView(lng = 138.2529, lat = 36.2048, zoom = 5) |>
    addProviderTiles(providers$CartoDB.Positron) |>
    addLegend(
      position = "topright"
      ,colors = pal
      ,labels = paste(bins[-length(bins)], bins[-1], sep = " - ")
      ,title = "Number of individuals"
      ,opacity = 1
    )
}

plt.leaflet_add_circle_markers <- function(
    map
    ,data
    ,radius_scale
    ,bin_pal
) {
  map |>
    addCircleMarkers(
      data = data
      ,lat = ~lat
      ,lng = ~lng
      ,popup = ~paste(
        "<div style='font-size: 18px; font-weight: bold; color: #c46479; margin-bottom: 10px;'>", name, "</div>",
        "<div style='display: flex; align-items: flex-start;'>",
        "<div style='flex: 1; padding-right: 10px;'>",
        "<b>Day:</b> ", day, "<br>",
        "<b>Time:</b> ", time, "<br>",
        "<b>Observations:</b> ", individual_count, "<br>",
        "<b>Life stage:</b> ", life_stage, "<br>",
        "<b>Sex:</b> ", sex, "<br>",
        "<b>Locality:</b> ", locality,
        "</div>",
        "<div style='flex: 0;'><img src='", url, "' style='max-width: 150px; height: auto;'></div>",
        "</div>"
      )
      ,radius = ~radius_scale(individual_count)
      ,fillColor = "#F8C3CD"
      ,fillOpacity = 1
      ,stroke = FALSE
      ,options = markerOptions(
        riseOnHover = TRUE
        ,individual_count = ~individual_count
      )
      ,clusterOptions = markerClusterOptions(iconCreateFunction = fx.custom_marker_clustering_js)
    )
}
