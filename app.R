# app-template.R
# An empty Shiny app. This is a template you can use to build most Shiny apps.

library(shiny)
library(bslib)
ui <- page_sidebar(
  sidebar = sidebar(),
)
server <- function(input, output) {}
shinyApp(ui, server)


