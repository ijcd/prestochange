defmodule PrestoChangeWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :presto_change

  socket("/socket", PrestoChangeWeb.UserSocket)

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug(
    Plug.Static,
    at: "/",
    from: :presto_change,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(
    Plug.Session,
    store: :cookie,
    key: "_presto_change_key",
    signing_salt: "zhaHdufk"
  )

  plug(PrestoChangeWeb.Router)

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"

      url_host =
        System.get_env("URL_HOST") || raise "expected the URL_HOST environment variable to be set"

      url_port =
        System.get_env("URL_PORT") || raise "expected the URL_PORT environment variable to be set"

      config =
        config
        |> Keyword.put(:http, [:inet6, port: port])
        |> Keyword.put(:url, host: url_host, port: url_port)

      {:ok, config}
    else
      {:ok, config}
    end
  end
end
