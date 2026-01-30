library(shiny)
library(bslib)
library(stringr)

ui <- page_sidebar(
  sidebar = sidebar(
    sliderInput("n", "Number of values", min = 1, max = 100, 20)
  ),
  plotOutput("hist")                
)

server <- function(input, output, session) {
  output$hist <- renderPlot({
    hist(
      rnorm(n = input$n), 
      main = str_glue("{input$n} Random Normal Values"), 
      xlab = str_glue("{input$n} values")
    )
  })
}

shinyApp(ui, server)