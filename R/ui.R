ui <- function() {

  page_fillable(

    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/appstyle.css")
      ,tags$link(rel = "stylesheet", type = "text/css", href = "css/map.css")
      ,tags$link(rel = "stylesheet", type = "text/css", href = "css/preloader.css")
    )

    ,waiter::use_waiter()
    ,waiter::waiter_show_on_load(html = fx.preloader, color = "#ffeef0")

    ,title = "japanbiodiversitydashboard"
    ,theme = fx.bslib_theme

    ,layout_columns(
      col_widths = c(3, 9)

      ,tagList(
        card(
          class = "custom-card"
          ,height = "48vh"
          ,plt.intro()
          ,md.controls_UI()
        )

        ,card(
          class = "custom-card"
          ,height = "52vh"
          ,md.timeline_UI()
        )
      )

      ,tagList(
        layout_columns(
          col_widths = c(2, 4, 6)
          ,height = "33vh"

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

          ,card(
            class = "custom-card"
            ,md.details_UI()
          )
        )

        ,card(
          class = "custom-card"
          ,height = "67vh"
          ,card_body(
            padding = 0
            ,md.map_UI()
          )
        )
      )

    )

  )
}
