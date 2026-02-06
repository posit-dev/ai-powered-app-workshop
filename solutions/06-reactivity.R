# 6. Change a value to an input value to create reactivity

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
    hist(rnorm(input$n), xlim = c(-4, 4), ylim = c(0, 30))
  })

}

shinyApp(ui, server)