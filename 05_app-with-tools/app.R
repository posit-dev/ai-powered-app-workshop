library(shiny)
library(bslib)
library(ellmer)
library(shinychat)
library(readr)

get_weather <- _______(      # Use the correct function
  function(lat, lon) weathR::point_tomorrow(lat, lon),
  name = "point_forecast",
  description = _________,   # Provide a description
  arguments = list(
    lat = type_number("Latitude of the location."),
    lon = type_number("Longitude of the location.")
  )
)

ui <- page_fillable(
  "Hello, I'm weatherbot. May I help you check the forecast for a location in the United States?",
  chat_mod_ui("chat")
)

server <- function(input, output, session) {
  client <- ellmer::chat_anthropic(
    system_prompt = readr::read_file("05_system-prompt/prompt.md")
  )
  client$______________(get_weather) ## Register the tool

  chat_mod_server("chat", client)
}

shinyApp(ui, server)



