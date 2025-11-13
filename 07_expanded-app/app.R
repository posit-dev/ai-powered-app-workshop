library(shiny)
library(bslib)
library(leaflet)

ui <- page_sidebar(
  sidebar = sidebar(
    numericInput( 
      "latitude", 
      "Latitude", 
      value = 39.09973, 
      min = 18.9, 
      max = 71.5 
    ), 
    numericInput( 
      "longitude", 
      "Longitude", 
      value = -94.57857, 
      min = -180, 
      max = 180 
    ),
    actionButton("button", "Update")
  ),
  leafletOutput("map") 
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({ 
    leaflet() |> 
      addTiles() |> 
      setView(-94.57857, 39.09973, zoom = 10) 
  }) 

  update_map <- function(lat, lng) {
    leafletProxy("map", session) %>%
        setView(lat = lat, lng = lng, zoom = 10)
  }

  observeEvent(input$button, {
    update_map(input$latitude, input$longitude)
  })
}

shinyApp(ui = ui, server = server)