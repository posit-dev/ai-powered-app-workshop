# 3. Add a drop down menu to the ui

library(shiny)
library(bslib)

ui <- page_sidebar(
  sidebar = sidebar(
    sliderInput( 
      "n", 
      "Number of observations", 
      min = 1, 
      max = 100, 
      value = 20
    )
  )
)

server <- function(input, output) {

}

shinyApp(ui, server)