# 4. Add space for a plot named hist to the ui 

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
  ), 
    plotOutput("hist")
)

server <- function(input, output) {

}

shinyApp(ui, server)