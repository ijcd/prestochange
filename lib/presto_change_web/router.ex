defmodule PrestoChangeWeb.Router do
  use PrestoChangeWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(PrestoChangeWeb.Plugs.VisitorIdPlug)
    plug(PrestoChangeWeb.Plugs.UserTokenPlug)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", PrestoChangeWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    # forward("/", Presto.IndexPresto)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PrestoChangeWeb do
  #   pipe_through :api
  # end
end
