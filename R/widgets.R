wd.pickerInput <- function(
    inputId
    ,label = "Species name (scientific | vernacular)"
    ,multiple = FALSE
    ,choices = NULL
    ,selected = "All"
    ,width = "100%"
    ,liveSearchPlaceholder = "Type to search for species"
) {
  shinyWidgets::pickerInput(
    inputId = inputId
    ,label = label
    ,choices = choices
    ,selected = selected
    ,multiple = multiple
    ,width = width
    ,options =
      pickerOptions(
        actionsBox = FALSE
        ,liveSearch = TRUE
        ,liveSearchPlaceholder = liveSearchPlaceholder
        ,liveSearchNormalize = TRUE
        ,liveSearchStyle = "contains"
        ,dropupAuto = FALSE
        ,countSelectedText = "count > 3"
        ,showTick = TRUE
        ,virtualScroll = 200
        ,container = "body"
        ,dropdownAlignRight = TRUE
        ,size = 4
      )
  )
}

wd.sliderInput <- function(
    inputId
    ,label = "Select Year:"
    ,min = 1976
    ,max = 2024
    ,value = c(1976, 2024)
    ,step = 1
    ,sep = ""
    ,width = "95%"
) {
  sliderInput(
    inputId = inputId
    ,label = label
    ,min = min
    ,max = max
    ,value = value
    ,step = step
    ,sep = sep
    ,width = width
  )
}

wd.title <- function(
    title
    ,subtitle = NULL
    ,title_color = "#333"
    ,title_font_size = "22px"
    ,subtitle_color = "#c46479"
    ,subtitle_font_size = "14px"
) {
  tags$div(
    style = "margin: 0;"
    ,tags$div(
      style = "display: flex; align-items: center; justify-content: space-between;"
      ,tags$div(
        style = glue("color: {title_color}; font-weight: bold; font-size: {title_font_size}; line-height: 1.2;")
        ,title
      )
    )
    ,if (!is.null(subtitle)) {
      tags$div(
        style = glue("color: {subtitle_color}; font-size: {subtitle_font_size}; line-height: 1.2; margin-top: 0.2rem;")
        ,subtitle
      )
    }
    ,tags$hr(style = "margin: 0.1rem 0;")
  )
}
