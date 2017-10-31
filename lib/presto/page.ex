defmodule Presto.Page do
  use GenServer, restart: :transient

  def start_link(page_id) do
    name = via_tuple(page_id)
    GenServer.start_link(__MODULE__, [page_id], name: name)
  end

  def init(arg) do
    {:ok, PrestoChangeWeb.Presto.IndexPresto.initial_state()}
  end
  
  defp via_tuple(page_id) do
    {:via, Registry, {Registry.Presto.Page, page_id}}
  end

  def initial_page(_page_name, page_id) do
    Presto.Supervisor.find_or_create_process(page_id)   # TODO: where should we make sure the page is started?
    GenServer.call(via_tuple(page_id), :initial_page)
  end

  def page_event(page_id, event) do
    GenServer.call(via_tuple(page_id), {:page_event, event})
  end
  
  def handle_call(:initial_page, _from, state) do
    safe_html = PrestoChangeWeb.Presto.IndexPresto.initial_page(state)
    {:reply, safe_html, state}
  end

  def handle_call({:page_event, event}, _from, state) do
    {reply, state} = PrestoChangeWeb.Presto.IndexPresto.handle_event(event, state)
    {:reply, reply, state}
  end
end
