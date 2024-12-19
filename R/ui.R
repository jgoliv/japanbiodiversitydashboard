ui <- function() {

  page_fillable(

    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/appstyle.css")
      ,tags$link(rel = "stylesheet", type = "text/css", href = "css/map.css")
      ,tags$link(rel = "stylesheet", type = "text/css", href = "css/preloader.css")
    )

    ,waiter::use_waiter()
    ,waiter::waiter_show_on_load(html = fx.preloader, color = "#FCFAF2")

    ,title = "japanbiodiversitydashboard"
    ,theme = fx.bslib_theme

    ,layout_columns(
      col_widths = c(8, 4)
      ,gap = "0.5rem"

      ,layout_columns(
        col_widths = 12
        ,gap = "0.5rem"

        ,layout_columns(
          col_widths = c(4, 8)
          ,gap = "0.5rem"

          ,card(
            class = "custom-card"
            ,plt.intro()
            ,md.controls_UI()
          )

          ,layout_columns(
            col_widths = 12
            ,gap = "0.5rem"

            ,layout_columns(
              col_widths = c(4, 8)
              ,gap = "0.5rem"

              ,card(
                class = "custom-card"
                ,full_screen = TRUE
                ,card_body(
                  padding = 0
                  ,md.image_UI()
                )
              )

              ,card(
                class = "custom-card"
                ,md.info_UI()
              )
            )

            ,card(
              class = "custom-card"
              ,md.details_UI()
            )
          )
        )

        ,card(
          class = "custom-card"
          ,height = "38vh"
          ,md.timeline_UI()
        )
      )

      ,card(
        class = "custom-card"
        ,card_body(
          padding = 0
          ,md.map_UI()
        )
      )

    )
  )
}
