defmodule AnonChat.UsernameGenerator do
  @adjectives [
    "Quick",
    "Lazy",
    "Happy",
    "Sad",
    "Angry",
    "Brave",
    "Clever",
    "Witty",
    "Calm",
    "Bright"
  ]

  @nouns [
    "Fox",
    "Dog",
    "Cat",
    "Mouse",
    "Lion",
    "Tiger",
    "Bear",
    "Wolf",
    "Eagle",
    "Shark"
  ]

  def generate_username do
    adjective = Enum.random(@adjectives)
    noun = Enum.random(@nouns)
    number = :rand.uniform(9999)

    "#{adjective}#{noun}#{number}"
  end
end
