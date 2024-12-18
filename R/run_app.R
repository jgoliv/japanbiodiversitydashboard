run_app <- function() {

  addResourcePath(prefix = "css", system.file(package = "japanbiodiversitydashboard", "www", "css"))
  addResourcePath(prefix = "fonts", system.file(package = "japanbiodiversitydashboard", "www", "fonts"))
  addResourcePath(prefix = "img", system.file(package = "japanbiodiversitydashboard", "www", "images"))

  static_data <<- readRDS(system.file(package = "japanbiodiversitydashboard", "extdata", "data.rds"))

  shinyApp(
    ui = ui()
    ,server = server
    ,options = list(launch.browser = TRUE)
  )
}
