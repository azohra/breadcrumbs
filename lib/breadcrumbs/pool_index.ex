defmodule Breadcrumbs.PoolIndex do
  @moduledoc false
  use Agent

  def start_link(pool_size) do
    Agent.start_link(fn -> %{size: pool_size, next: 1} end, name: __MODULE__)
  end

  def next do
    Agent.get_and_update(__MODULE__,
    fn %{size: pool_size, next: next} -> 
      {next, %{size: pool_size, next: iterate(next, pool_size)}}
    end)
  end

  defp iterate(limit, limit), do: 1
  defp iterate(val, _limit), do: val + 1
end
