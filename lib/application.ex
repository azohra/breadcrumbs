defmodule Breadcrumbs.Application do
  @moduledoc false
  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec

    pool_size = get_config()

    IO.inspect("\n\n#{pool_size}\n\n")

    children = [
      worker(Breadcrumbs.Pool, [pool_size])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp get_config do
    specified = Application.get_env(:breadcrumbs, :pool_size)

    case specified do
      nil -> 10
      val -> val
    end
  end
end
