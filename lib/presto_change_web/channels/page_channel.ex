defmodule PrestoChangeWeb.PageChannel do
  use PrestoChangeWeb, :channel
  alias PrestoWeb.Session

  # TODO: turn these into a use macro that pulls this into the channel easily
  def join("page:lobby", payload, socket) do
    %{visitor_id: visitor_id} = socket.assigns

    if authorized?(payload) do
      Presto.Supervisor.find_or_create_process(visitor_id)

      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # TODO: turn these into a use macro that pulls this into the channel  easily
  def handle_in("presto", payload, socket) do
    %{visitor_id: visitor_id} = socket.assigns

    # send event to presto page
    case Presto.Page.page_event(visitor_id, payload) do
      nil -> nil
      rv -> push(socket, "presto", rv)
    end

    {:reply, {:ok, payload}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
