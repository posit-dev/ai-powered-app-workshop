# 9. An app that explores cancer data

library(shiny)
library(bslib)
library(DT)

source("mortality_map.R")
georgia_mortality <- read.csv("data/georgia_mortality.csv")
georgia_population <- read.csv("data/georgia_population.csv")

ui <- page_sidebar(
  sidebar = sidebar(
    selectInput( 
      "site", 
      "Cancer type:", 
      sort(unique(georgia_mortality$Site))
    )
  ), 
    leafletOutput("map", height = "500px"),
    DTOutput("table")
)

server <- function(input, output) {

  dataset <- reactive({
    georgia_mortality |> 
      filter(Site == input$site)
  })

  output$map <- renderLeaflet({
    create_mortality_map(dataset(), georgia_population)
  })

  output$table <- DT::renderDT({
    datatable(dataset(), options = list(pageLength = 20, scrollY = "800px"))
  })

}

shinyApp(ui, server)