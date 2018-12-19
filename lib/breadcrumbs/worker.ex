defmodule Breadcrumbs.PoolWorker do
  @moduledoc false

  use GenServer

  import Breadcrumbs.Clients.Jira, only: [get_issue: 1]

  @doc false
  def start_link(args) do
    GenServer.start_link(__MODULE__, [], args)
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
  def handle_call(:ping, _from, state) do
    {:reply, "pong", state}
  end
end
