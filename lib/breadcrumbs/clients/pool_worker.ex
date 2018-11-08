defmodule Breadcrumbs.PoolWorker do
  @moduledoc false

  use GenServer

  @timeout :infinity

  import Breadcrumbs.Clients.Jira, only: [get_issue: 1]

  @doc false
  def start_link([]) do
    GenServer.start_link(__MODULE__, [], [])
  end

  @doc false
  def init(state) do
    {:ok, state}
  end

  @doc false
  def handle_call({:get, ticket_id}, _from, state) do
    {:reply, get_issue(ticket_id), state}
  end

  @doc false
  def make_request(pid, ticket_id) do
    GenServer.call(pid, {:get, ticket_id}, @timeout)
  end
end
