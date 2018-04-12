defmodule PrestoChangeWeb.Plugs.VisitorIdPlug do
  import Plug.Conn

  @key :visitor_id

  def init(default), do: default

  def call(conn, _default) do
    visitor_id = get_session(conn, @key)

    if visitor_id do
      assign(conn, @key, visitor_id)
    else
      visitor_id = Base.encode64(:crypto.strong_rand_bytes(32))

      conn
      |> put_session(@key, visitor_id)
      |> assign(@key, visitor_id)
    end
  end
end
