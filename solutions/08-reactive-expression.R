# 8. Make one dataset and share it with the table and plot 

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

  dataset <- reactive({
    rnorm(input$n)
  })

  output$table <- renderPrint({
    summary(dataset())
  })

  output$hist <- renderPlot({
    hist(dataset(), xlim = c(-4, 4))
  })
}

shinyApp(ui, server)