# 7. Add a table

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
    hist(rnorm(input$n), xlim = c(-4, 4))
  })

    output$table <- renderPrint({
    summary(rnorm(input$n))
  })
  
}

shinyApp(ui, server)