defmodule Presto.Page do
  use GenServer, restart: :transient

  def start_link(page_id) do
    name = via_tuple(page_id)
    GenServer.start_link(__MODULE__, [page_id], name: name)
  end
  
  defp via_tuple(page_id) do
    {:via, Registry, {Registry.Presto.Page, page_id}}
  end

  def page_event(page_id, event) do
    GenServer.call(via_tuple(page_id), {:page_event, event})
  end

  def handle_call({:page_event, event}, _from, state) do
    %{"attrs" => %{"id" => id}} = event
    reply = PrestoChangeWeb.ConverterSPA.button(id: id)
    |> IO.inspect(label: "HANDLE")
    
    {:reply, reply, state}
  end
end
