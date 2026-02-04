# 2. Run the basic app template

library(shiny)
library(bslib)

ui <- page_sidebar(
  sidebar = sidebar()
)

server <- function(input, output) {
}

shinyApp(ui, server)