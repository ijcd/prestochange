defmodule PrestoChangeWeb.Plugs.UserTokenPlug do
  import Plug.Conn
  alias PrestoChangeWeb.Session

  def init(default), do: default

  def call(conn, _default) do
    if visitor_id = conn.assigns[:visitor_id] do
      user_token = Session.encode_socket_token(visitor_id)
      assign(conn, :user_token, user_token)
    else
      conn
    end
  end
end
