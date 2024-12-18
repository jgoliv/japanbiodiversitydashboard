server <- function(input, output, session) {

  rc.controls <- md.controls(static_data = static_data)

  rc.data <- reactive({
    req(rc.controls()$name, rc.controls()$year)

    static_data %>%
      filter(
        if(rc.controls()$name != "All") name %in% rc.controls()$name else TRUE
        ,year %in% rc.controls()$year
      )

  }) %>%
    bindCache(rc.controls()$name, rc.controls()$year)

  md.info(rc.data = rc.data, rc.controls = rc.controls)
  md.image(rc.data = rc.data, rc.controls = rc.controls)
  md.details(rc.data = rc.data, rc.controls = rc.controls)
  md.timeline(rc.data = rc.data, rc.controls = rc.controls)
  md.map(rc.data = rc.data)

}
