# In this workshop, we'll be using the ellmer package to interact with Large
# Language Models (LLMs) like OpenAI's GPT and Anthropic's Claude.
# https://ellmer.tidyverse.org/
library(ellmer)

# ---- Anthropic ----
chat_anthropic <- chat_anthropic()
chat_anthropic$chat(
  "Who are you?"
)
