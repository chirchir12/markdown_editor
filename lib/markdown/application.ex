defmodule Markdown.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MarkdownWeb.Telemetry,
      Markdown.Repo,
      {DNSCluster, query: Application.get_env(:markdown, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Markdown.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Markdown.Finch},
      # Start a worker by calling: Markdown.Worker.start_link(arg)
      # {Markdown.Worker, arg},
      # Start to serve requests, typically the last entry
      MarkdownWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Markdown.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MarkdownWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
