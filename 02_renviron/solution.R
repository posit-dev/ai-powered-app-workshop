# Add the code below to your .Renviron file, e.g. with usethis::edit_r_environ().
# Paste your API Key between the quotes.
# ANTHROPIC_API_KEY=""

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
chat_poet <- chat_anthropic(
  system_prompt = "You are a shakespearean poet. When a user gives you a topic, write a rhyming couplet about the topic in iambic pentameter."
)

chat_poet$chat(
  "New York City"
)

chat_poet <- chat_anthropic(
 system_prompt = readr::read_file(“prompt.md”)
)

weathR::point_tomorrow(lat = 40.71, lon = -74)

ellmer::create_tool_def(weathR::point_tomorrow)