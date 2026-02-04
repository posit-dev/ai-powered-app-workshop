# 10. Make it querychat

library(shiny)
library(bslib)
library(DT)
library(querychat)

source("mortality_map.R")
georgia_mortality <- read.csv("data/georgia_mortality.csv")
georgia_population <- read.csv("data/georgia_population.csv")

# Step 1: Initialize QueryChat
qc <- QueryChat$new(georgia_mortality, greeting = "How can I help you explore cancer mortality in Georgia?")


ui <- page_sidebar(
  sidebar = qc$sidebar(), # Step 2: Add a chat to the sidebar
    leafletOutput("map", height = "500px"),
    DTOutput("table")
)
# Step 3: Use reactive values in server
server <- function(input, output) {
  qc_vals <- qc$server()

  dataset <- reactive(
    qc_vals$df()
  )

  output$map <- renderLeaflet({
    create_mortality_map(dataset(), georgia_population)
  })

  output$table <- DT::renderDT({
    datatable(dataset(), options = list(pageLength = 20, scrollY = "800px"))
  })

}

shinyApp(ui, server)