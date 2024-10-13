defmodule AnonChatWeb.ChatLive do
  use AnonChatWeb, :live_view

  alias AnonChat.Chat
  alias AnonChat.UsernameGenerator

  def mount(_params, _session, socket) do
    if connected?(socket), do: Chat.subscribe()

    # Generate a random username and assign it to the socket
    username = UsernameGenerator.generate_username()

    messages = Chat.list_recent_messages()

    socket =
      socket
      |> assign(messages: messages)
      |> assign(message: "")
      |> assign(username: username)

    {:ok, socket}
  end

  def handle_event("send_message", %{"message" => message_content}, socket) do
    message = String.trim(message_content)

    if message == "" do
      {:noreply, socket}
    else
      # Include the username in the message attributes
      attrs = %{content: message, username: socket.assigns.username}

      case Chat.create_message(attrs) do
        {:ok, _message} ->
          {:noreply, assign(socket, message: "")}

        {:error, _changeset} ->
          {:noreply, socket}
      end
    end
  end

  def handle_info({:new_message, message}, socket) do
    socket = update(socket, :messages, fn msgs -> msgs ++ [message] end)
    {:noreply, push_event(socket, "new_message", %{})}
  end

  defp format_timestamp(timestamp) do
    timestamp
    |> Timex.to_datetime()
    |> Timex.format!("%H:%M", :strftime)
  end
end
