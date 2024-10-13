defmodule AnonChatWeb.ChatLive do
  use AnonChatWeb, :live_view

  alias AnonChat.Chat

  def mount(_params, _session, socket) do
    if connected?(socket), do: Chat.subscribe()

    messages = Chat.list_recent_messages()
    {:ok, assign(socket, messages: messages, message: "")}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    message = String.trim(message)

    if message == "" do
      {:noreply, socket}
    else
      case Chat.create_message(%{content: message}) do
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
    |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime)
  end
end
