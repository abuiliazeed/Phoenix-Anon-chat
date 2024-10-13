defmodule AnonChat.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AnonChat.Chat` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> AnonChat.Chat.create_message()

    message
  end
end
