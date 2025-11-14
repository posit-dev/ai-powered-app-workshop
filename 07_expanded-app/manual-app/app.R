library(shiny)
library(bslib)
library(weathR)
library(ggplot2)
library(leaflet)
source("helpers.R")

ui <- page_sidebar(
  sidebar = sidebar(
    numericInput( 
      "latitude", 
      "Latitude", 
      value = 39.09973, 
      min = 25, 
      max = 49 
    ), 
    numericInput( 
      "longitude", 
      "Longitude", 
      value = -94.57857, 
      min = -125, 
      max = -67 
    ),
    actionButton("button", "Update")
  ),
  layout_columns( 
    leafletOutput("map"),
    uiOutput("highs"),
    plotOutput("temperatures"),
    col_widths = c(9, 3, 12)
  )
)

server <- function(input, output, session) {
  get_weather_function <- function(lat, lon) {
    weathR::point_tomorrow(lat, lon) |> 
    as.data.frame()
  }
  tomorrow <- Sys.Date() + 1
  data <- reactiveVal(isolate(get_weather_function(input$latitude, input$longitude)))

  output$map <- renderLeaflet({ 
    leaflet() |> 
      addTiles() |> 
      fitBounds(-125, 49, -67, 25)
  }) 

  output$temperatures <- renderPlot({
    data() |> 
      select(time, temp) |> 
      mutate(time = as.POSIXct(time)) |> #convert time to a POSIXct object 
      ggplot(aes(x = time, y = temp)) +
        geom_line(color = "indianred") +
        geom_point(color = "brown") +
        labs(
          title = paste0("Temperature Forecast for ", tomorrow),
          y = "Temperature (Degrees Fahrenheit)",
          x = "Time"
        ) +
        scale_x_datetime(date_labels = "%H:%M") + 
        theme_minimal()
  })

  output$highs <- renderUI({
    high <- max(data()$temp)

    value_box(
      title = "",
      value = paste0(high, "° F"),
      showcase = pick_icon(data()$skies),
      p("Tomorrow's high"),
      class = "h-100",
      theme = pick_color(high)
    )
  })

  update_map <- function(lat, lng) {
    leafletProxy("map", session) |> 
      clearMarkers() |> 
      addMarkers(lng, lat)
  }

  observeEvent(input$button, {
    update_map(input$latitude, input$longitude)
    data(isolate(get_weather_function(input$latitude, input$longitude)))
  })
}

shinyApp(ui = ui, server = server)