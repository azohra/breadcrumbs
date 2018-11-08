defmodule Breadcrumbs.Pool do
  @moduledoc false

  alias Breadcrumbs.PoolWorker

  @doc false
  def start_link(pool_size) do
    poolboy_config = [
      {:name, {:local, :pool}},
      {:worker_module, PoolWorker},
      {:size, pool_size},
      {:max_overflow, 0}
    ]

    children = [
      :poolboy.child_spec(:pool, poolboy_config, [])
    ]

    options = [
      strategy: :one_for_one,
      name: __MODULE__
    ]

    Supervisor.start_link(children, options)
  end

  @doc false
  def distribute_request(params) do
    case :poolboy.checkout(:pool, false) do
      :full ->
        :timer.sleep(10)
        distribute_request(params)

      worker_pid ->
        resp = PoolWorker.make_request(worker_pid, params)
        :poolboy.checkin(:pool, worker_pid)
        resp
    end
  end
end
