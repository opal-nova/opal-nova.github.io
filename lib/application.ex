defmodule StaticSite.Application do
  use Application

  def start(_type, _args) do
    children = [
      # FileWatcher, #TODO: watch and build files
      {Plug.Cowboy, scheme: :http, plug: StaticSite.HttpHandler, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: StaticSite.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
