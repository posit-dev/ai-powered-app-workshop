
chat_poet <- chat_anthropic(
  system_prompt = "You are a shakespearean poet. When a user gives you a topic, write a rhyming couplet about the topic in iambic pentameter."
)

chat_poet$chat(
  "New York City"
)

# Store long, important system prompts in their own file
# chat_poet <- chat_anthropic(
#  system_prompt = readr::read_file("prompt.md")
# )
