# 5. Tell the server how to build a plot named hist

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

  output$hist <- renderPlot({
    hist(rnorm(input$n), xlim = c(-4, 4))
  })

}

shinyApp(ui, server)