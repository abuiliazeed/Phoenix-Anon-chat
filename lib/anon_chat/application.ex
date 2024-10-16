defmodule AnonChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AnonChatWeb.Telemetry,
      # Start the Ecto repository
      AnonChat.Repo,
      # Start the DNSCluster (if used for clustering)
      {DNSCluster, query: Application.get_env(:anon_chat, :dns_cluster_query) || :ignore},
      # Start the PubSub system
      {Phoenix.PubSub, name: AnonChat.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AnonChat.Finch},
      # Start the Endpoint (http/https)
      AnonChatWeb.Endpoint,
      # Start the Scheduler for deleting old messages
      AnonChat.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AnonChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AnonChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
