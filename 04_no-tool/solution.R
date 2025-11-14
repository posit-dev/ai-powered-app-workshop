# ---- LLMs do not know current events ----
library(ellmer)

chat_session <- chat_anthropic(echo = "output")

chat_session$chat("What will the weather be tomorrow in Brooklyn, New York?")
