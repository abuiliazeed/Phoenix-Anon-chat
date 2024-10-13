defmodule AnonChat.Repo do
  use Ecto.Repo,
    otp_app: :anon_chat,
    adapter: Ecto.Adapters.Postgres
end
