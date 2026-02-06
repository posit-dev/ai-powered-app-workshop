# 6. Add a summary table

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
    plotOutput("hist"),
    verbatimTextOutput("table")
)

server <- function(input, output) {

  output$hist <- renderPlot({
    hist(rnorm(100), xlim = c(-4, 4), ylim = c(0, 30))
  })

  output$table <- renderPrint({
    summary(rnorm(100))
  })
  
}

shinyApp(ui, server)