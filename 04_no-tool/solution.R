# ---- LLMs do not know current events ----
library(ellmer)

chat_session <- chat_anthropic(echo = "output")

chat_session$chat("What is the weather today in Brooklyn, New York?")
