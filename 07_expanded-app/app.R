library(shiny)
library(bslib)
library(weathR)
library(ggplot2)
library(leaflet)
library(shinychat)
library(ellmer)
source("helpers.R")



ui <- page_sidebar(
  sidebar = sidebar(
    "Hello, I'm weatherbot. Can I help you look up the weather for a location in the United States?",
    chat_mod_ui("chat")
  ),
  layout_columns( 
    leafletOutput("map"),
    uiOutput("highs"),
    plotOutput("temperatures"),
    col_widths = c(9, 3, 12)
  )
)

server <- function(input, output, session) {  

  # create reactive objects to hare data created by AI with Shiny
  data <- reactiveVal()
  latitude <- reactiveVal()
  longitude <- reactiveVal()
  city <- reactiveVal()

  # Define function within server() so it can access data()
  get_weather_function <- function(lat, lon, city) {
    weather_data <- 
      weathR::point_tomorrow(lat, lon) |> 
      as.data.frame()

    # update reactive objects to share data with Shiny app
    data(weather_data)
    latitude(lat)
    longitude(lon)
    city(city)
    
    # return data (for LLM to use)
    weather_data
  }
  
  # Make tool
  get_weather <- tool(
    get_weather_function,
    name = "get_weather",
    description = "Get forecast data for a specific latitude and longitude.",
    arguments = list(
      lat = type_number("Latitude of the location."),
      lon = type_number("Longitude of the location."),
      city = type_string("The name of the location.")
    )
  )

  client <- ellmer::chat_anthropic(
    system_prompt = interpolate_file("prompt.md"),
    echo = "all"
  )
  client$register_tool(get_weather)
  chat_mod_server("chat", client)

  output$map <- renderLeaflet({ 
    validate(need(data(), message = "Talk to the chatbot in the sidebar to begin."))
    req(data())
    leaflet() |> 
      addTiles() |> 
      fitBounds(-125, 49, -67, 25)
  }) 

  output$temperatures <- renderPlot({
    req(data())
    data() |> 
      select(time, temp) |> 
      mutate(time = as.POSIXct(time)) |> #convert time to a POSIXct object 
      ggplot(aes(x = time, y = temp)) +
        geom_line(color = "indianred") +
        geom_point(color = "brown") +
        labs(
          title = paste0("Tomorrow's temperatures in ", city()),
          y = "Temperature (Degrees Fahrenheit)",
          x = "Time"
        ) +
        scale_x_datetime(date_labels = "%H:%M") + 
        theme_minimal()
  })

  output$highs <- renderUI({
    req(data())
    high <- max(data()$temp)

    value_box(
      title = "",
      value = paste0(high, "° F"),
      showcase = pick_icon(data()$skies),
      p(paste("Tomorrow's high in", city())),
      class = "h-100",
      theme = pick_color(high)
    )
  })

  update_map <- function(lat, lng) {
    leafletProxy("map", session) |> 
      clearMarkers() |> 
      addMarkers(lng, lat)
  }

  observeEvent(c(latitude(), longitude()), {
    leafletProxy("map", session) |> 
      clearMarkers() |> 
      addMarkers(longitude(), latitude())
  })

}

shinyApp(ui = ui, server = server)