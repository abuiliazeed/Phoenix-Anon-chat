defmodule AnonChat.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias AnonChat.Repo

  alias AnonChat.Chat.Message
  alias AnonChatWeb.Endpoint

  @doc """
  Returns the list of all messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Returns the list of messages from the last 24 hours.

  ## Examples

      iex> list_recent_messages()
      [%Message{}, ...]

  """
  def list_recent_messages do
    cutoff = DateTime.utc_now() |> DateTime.add(-86_400, :second)

    Message
    |> where([m], m.inserted_at > ^cutoff)
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message and notifies subscribers.

  ## Examples

      iex> create_message(%{content: "Hello"})
      {:ok, %Message{}}

      iex> create_message(%{content: ""})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{content: "Updated"})
      {:ok, %Message{}}

      iex> update_message(message, %{content: ""})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  @doc """
  Subscribes to the "messages" topic for real-time updates.

  ## Examples

      iex> subscribe()
      :ok

  """
  def subscribe do
    Phoenix.PubSub.subscribe(AnonChat.PubSub, "messages")
  end

  @doc """
  Notifies subscribers of a new message.
  """
  defp notify_subscribers({:ok, message} = result) do
    Phoenix.PubSub.broadcast(AnonChat.PubSub, "messages", {:new_message, message})
    result
  end

  defp notify_subscribers(result), do: result

  @doc """
  Deletes messages older than 24 hours.

  ## Examples

      iex> delete_old_messages()
      {number_of_deleted_records, nil}

  """
  def delete_old_messages do
    cutoff = DateTime.utc_now() |> DateTime.add(-86_400, :second)

    from(m in Message, where: m.inserted_at < ^cutoff)
    |> Repo.delete_all()
  end
end
