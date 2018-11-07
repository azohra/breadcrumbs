defmodule Breadcrumbs.BasicRenderer do
  @moduledoc false
  @behaviour Breadcrumbs.Renderer

  import Breadcrumbs.BasicFormatter

  import Breadcrumbs.Utils, only: [appendln: 2]

  @base "Release Notes:"

  @doc false
  @spec render(list()) :: String.t()
  def render(tickets) do
    tickets
    |> Enum.map(fn ticket -> format(ticket) end)
    |> Enum.reduce(@base, fn ticket, message -> appendln(message, ticket) end)
  end
end
