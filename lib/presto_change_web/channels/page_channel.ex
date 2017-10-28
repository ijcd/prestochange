defmodule PrestoChangeWeb.PageChannel do
  use PrestoChangeWeb, :channel
  alias PrestoChange.Converter


  def join("page:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("button", payload, socket) do
    %{"attrs" => %{"id" => id}} = payload

    case Converter.button(id: id) do
      nil -> nil
      rv -> push socket, "snippet", rv
    end

    {:reply, {:ok, payload}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
