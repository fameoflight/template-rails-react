defmodule TemplatePhoenixApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TemplatePhoenixApiWeb.Telemetry,
      TemplatePhoenixApi.Repo,
      {DNSCluster, query: Application.get_env(:template_phoenix_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TemplatePhoenixApi.PubSub},
      # Start Presence for chat functionality
      TemplatePhoenixApiWeb.Presence,
      # Start Oban
      {Oban, Application.fetch_env!(:template_phoenix_api, Oban)},
      # Start a worker by calling: TemplatePhoenixApi.Worker.start_link(arg)
      # {TemplatePhoenixApi.Worker, arg},
      # Start to serve requests, typically the last entry
      TemplatePhoenixApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TemplatePhoenixApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TemplatePhoenixApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
