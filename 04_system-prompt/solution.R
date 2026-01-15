library(shiny)
library(bslib)
library(ellmer)
library(shinychat)
library(readr)

ui <- page_fillable(
  "Hello, I'm weatherbot. May I help you check the forecast for a location in the United States?",
  chat_mod_ui("chat")
)

server <- function(input, output, session) {
  client <- ellmer::chat_anthropic(
    system_prompt = ellmer::interpolate_file("04_system-prompt/prompt.md")
  )
  chat_mod_server("chat", client)
}

shinyApp(ui, server)
