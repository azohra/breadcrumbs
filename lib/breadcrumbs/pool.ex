defmodule Breadcrumbs.Pool do
  @moduledoc false

  alias Breadcrumbs.PoolIndex

  @doc false
  def start_link(pool_size) do

    children = Enum.map(
      1..pool_size,
      fn x ->
        name = String.to_atom("pool_worker_#{x}")
        Supervisor.child_spec({Breadcrumbs.PoolWorker, name: name}, id: name)
      end
    )

    options = [
      strategy: :one_for_one,
      name: __MODULE__
    ]

    Supervisor.start_link(children, options)
  end

  def distribute_request(ticket_id) do
    pid = get_child()

    GenServer.call(pid, {:get, ticket_id}, :infinity)
  end

  defp get_child do
    val = PoolIndex.next() - 1

    __MODULE__
    |> Supervisor.which_children()
    |> Enum.at(val)
    |> take_pid()
  end

  defp take_pid({_id, pid, _type, _module}), do: pid

end
