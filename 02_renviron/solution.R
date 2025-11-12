# In this workshop, we'll be using the ellmer package to interact with Large
# Language Models (LLMs) like OpenAI's GPT and Anthropic's Claude.
# https://ellmer.tidyverse.org/
library(ellmer)

# ---- Anthropic ----
chat_session <- chat_anthropic()
chat_session$chat(
  "Who are you?"
)

rm(chat_session) # closes chat


# Add the code below to your .Renviron file, e.g. with usethis::edit_r_environ().
# Paste your API Key between the quotes.
# ANTHROPIC_API_KEY=""
