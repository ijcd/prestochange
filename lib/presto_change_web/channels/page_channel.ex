defmodule PrestoChangeWeb.PageChannel do
  use PrestoChangeWeb, :channel

  # TODO: turn these into a use macro that pulls this into the channel easily
  def join("page:lobby", payload, socket) do
    # %{visitor_id: visitor_id} = socket.assigns

    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # TODO: turn these into a use macro that pulls this into the channel easily
  def handle_in("presto", payload, socket) do
    %{visitor_id: visitor_id} = socket.assigns

    # send event to presto page
    {:ok, dispatch} = Presto.dispatch(PrestoChangeWeb.Presto.IndexPresto, visitor_id, payload)

    case dispatch do
      [] -> nil
      _ -> push(socket, "presto", dispatch)
    end

    {:reply, {:ok, payload}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
