defmodule Breadcrumbs.BasicFormatter do
  @moduledoc false
  @behaviour Breadcrumbs.Formatter

  @doc false
  @spec format(%Ticket{}) :: String.t()
  def format(%Ticket{} = ticket) do
    "Closed: #{ticket.key}"
  end

  @spec format(%ErrorTicket{}) :: String.t()
  def format(%ErrorTicket{} = error) do
    "Error in getting ticket: #{error.key}, Reason: #{error.reason}"
  end
end
