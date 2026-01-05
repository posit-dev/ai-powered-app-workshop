# ---- ✦ I can get the weather with R! ✦ ----
library(weathR)

posit_conf <- list(lat = 33.761627, lon = -84.386963)

weathR::point_forecast(posit_conf$lat, posit_conf$lon)

# ---- ⚒️ Let's turn this into a tool 🛠️ ----
library(ellmer)

ellmer::create_tool_def(
  weathR::point_forecast,
  chat = chat_anthropic(), 
  verbose = TRUE
)

get_weather <- tool(
  function(lat, lon) weathR::point_tomorrow(lat, lon),
  name = "point_forecast",
  description = "Get forecast data for a specific latitude and longitude.",
  arguments = list(
    lat = type_number("Latitude of the location."),
    lon = type_number("Longitude of the location.")
  )
)

# The tool is callable!
get_weather(posit_conf$lat, posit_conf$lon)

# ---- 🧰 Teach an LLM that we have this tool ----
chat_weather <- chat_anthropic(echo = "output")

# Register the tool with the chatbot
chat_weather$register_tool(get_weather)

chat_weather$chat("What will the weather be tomorrow in Brooklyn, New York?")