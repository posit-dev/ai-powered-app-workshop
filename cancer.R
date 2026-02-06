# Loads Georgia datasets
georgia_mortality <- read.csv("data/georgia_mortality.csv")
georgia_population <- read.csv("data/georgia_population.csv")

# A drop down menu that displays each type of cancer in georgia_mortality
selectInput( 
  "site", 
  "Cancer type:", 
  sort(unique(georgia_mortality$Site))
)

# A reactive expression 
dataset <- reactive({
  georgia_mortality |> 
    filter(Site == input$site)
})

# Components to make a leaflet map
source("mortality_map.R") # defines create_mortality_map() function
leafletOutput("map", height = "500px")
output$map <- renderLeaflet({
  create_mortality_map(dataset(), georgia_population)
})

# Components to make a DT table
library(DT)
DTOutput("table")
output$table <- DT::renderDT({
    datatable(dataset(), options = list(pageLength = 20, scrollY = "800px"))
})
