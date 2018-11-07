defmodule Breadcrumbs.BasicFormatter do
  @moduledoc false
  @behaviour Breadcrumbs.Formatter

  import Breadcrumbs.Utils, only: [appendln: 2]

  import Breadcrumbs.Markdown

  @doc false
  @spec format(map()) :: String.t()
  def format(ticket) do
    %{
      key: key
    } = ticket

    ""
    |> appendln("Ticket: #{key}")
  end
end
