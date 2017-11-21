defmodule PrestoChange.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # IO.inspect(Application.get_all_env(:presto_change), label: "CONFIG")
    # IO.inspect(System.get_env(), label: "ENV")

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(PrestoChangeWeb.Endpoint, []),
      # Start your own worker by calling: PrestoChange.Worker.start_link(arg1, arg2, arg3)
      # worker(PrestoChange.Worker, [arg1, arg2, arg3]),

      {Registry, keys: :unique, name: Registry.Presto.Page},
      Presto.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PrestoChange.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PrestoChangeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
