defmodule PrestoChangeWeb.Session do
  def encode_socket_token(visitor_id) do
    Phoenix.Token.sign(PrestoChangeWeb.Endpoint, "user", visitor_id)
  end

  def decode_socket_token(token) do
    Phoenix.Token.verify(PrestoChangeWeb.Endpoint, "user", token, max_age: 86400 * 14)
  end
end
