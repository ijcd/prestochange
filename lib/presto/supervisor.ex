defmodule Presto.Supervisor do
  @moduledoc """
  Supervisor to handle the creation of dynamic
  `Presto.Page` processes using a `simple_one_for_one`
  strategy. See the `init` callback at the bottom for details on that.

  These processes will spawn for each `page_id` provided to the
  `Presto.Page.start_link` function.

  Functions contained in this supervisor module will assist in the
  creation and retrieval of new page processes.
  """

  use Supervisor
  require Logger

  @page_registry_name Registry.Presto.Page

  @doc """
  Starts the supervisor.
  """
  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @doc false
  def init(_arg) do
    Supervisor.init(
      [
        Supervisor.child_spec(Presto.Page, start: {Presto.Page, :start_link, []})
      ],
      strategy: :simple_one_for_one
    )
  end

  @doc """

  Will find the process identifier (in our case, the `page_id`) if
  it exists in the registry and is attached to a running
  `Presto.Page` process.

  If the `page_id` is not present in the registry, it will create a
  new `Presto.Page` process and add it to the registry for the given
  `page_id`.

  Returns a tuple such as `{:ok, page_id}` or `{:error, reason}`
  """
  def find_or_create_process(page_id) do
    if page_process_exists?(page_id) do
      {:ok, page_id}
    else
      create_page_process(page_id)
    end
  end

  @doc """
  Determines if a `Presto.Page` process exists, based on the `page_id`
  provided.  Returns a boolean.

  ## Example

      iex> Presto.Supervisor.page_process_exists?(6)
      false

  """
  def page_process_exists?(page_id) do
    case Registry.lookup(@page_registry_name, page_id) do
      [] -> false
      _ -> true
    end
  end

  @doc """
  Creates a new page process, based on the `page_id` integer.  Returns
  a tuple such as `{:ok, page_id}` if successful.  If there is an
  issue, an `{:error, reason}` tuple is returned.
  """
  def create_page_process(page_id) do
    case Supervisor.start_child(__MODULE__, [page_id]) do
      {:ok, _pid} -> {:ok, page_id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end

  @doc """
  Returns the count of `Presto.Page` processes managed by this supervisor.

  ## Example

      iex> Presto.Supervisor.page_process_count
      0

  """
  def page_process_count, do: Supervisor.which_children(__MODULE__) |> length

  @doc """
  Return a list of `page_id` integers known by the registry.
  ex - `[1, 23, 46]`
  """
  def page_ids do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, page_proc_pid, _, _} ->
      Registry.keys(@page_registry_name, page_proc_pid)
      |> List.first()
    end)
    |> Enum.sort()
  end
end
