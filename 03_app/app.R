library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

ui <- page_fillable(
  "Hello, I'm weatherbot. May I help you check the forecast for a location in the United States?",
  # Do you want the ui or server function?
  # Select a name/id for your chat component
  chat_mod______("______") 
                           
)

server <- function(input, output, session) {
  client <- ellmer::chat_anthropic()
  # Do you want the ui or server function?
  # What is the name/id of the ui component this updates?
  # What is the ellmer session object that powers this chat window?
  chat_mod_______("_______", ________)
}

shinyApp(ui, server)