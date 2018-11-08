defmodule Breadcrumbs.BasicRenderer do
  @moduledoc false
  @behaviour Breadcrumbs.Renderer

  import Breadcrumbs.BasicFormatter

  import Breadcrumbs.Utils, only: [appendln: 2]

  @base "Release Notes:"
  @error_base "Errors:"

  @doc false
  @spec render(%ScrapeData{}) :: String.t()
  def render(scrape_data) do
    valid =
      scrape_data.valid
      |> Enum.map(fn ticket -> format(ticket) end)
      |> Enum.reduce(@base, fn ticket, message -> appendln(message, ticket) end)

    errors =
      scrape_data.errors
      |> Enum.map(fn ticket -> format(ticket) end)
      |> Enum.reduce(@error_base, fn ticket, message -> appendln(message, ticket) end)

    appendln(valid, errors)
  end
end
