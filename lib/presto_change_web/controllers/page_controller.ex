defmodule PrestoChangeWeb.PageController do
  use PrestoChangeWeb, :controller
  alias PrestoChange.Session
    
  def index(conn, _params) do
    user_token = Session.encode_socket_token(conn.assigns[:visitor_id])
    render conn, "index.html", user_token: user_token
  end
end
