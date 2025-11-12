library(ellmer)

# ---- Anthropic ----
chat_game <- chat_anthropic(
  system_prompt = "--(
We are playing a word guessing game. You are going to think of a random word.
When you do, write it in an HTML comment so that you can remember it, but the
user can't see it.

Give the user an initial clue and then only answer their questions with yes or
no. When they win, use lots of emojis.
)--"
)

# chat_game$chat(
#   "Who are you?",
# )

live_console(chat_game) # A chatbot UI in the console

rm(chat_game) # closes chat session
