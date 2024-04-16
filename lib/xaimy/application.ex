defmodule Xaimy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      XaimyWeb.Telemetry,
      Xaimy.Repo,
      {DNSCluster, query: Application.get_env(:xaimy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Xaimy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Xaimy.Finch},
      # Start a worker by calling: Xaimy.Worker.start_link(arg)
      # {Xaimy.Worker, arg},
      # Start to serve requests, typically the last entry
      XaimyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Xaimy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    XaimyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
