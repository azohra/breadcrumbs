defmodule Breadcrumbs do
  @moduledoc false

  import Breadcrumbs.Clients.Jira, only: [get_issues: 1]

  @doc false
  def render(ticket_ids, module \\ Breadcrumbs.BasicRenderer) do
    tickets = get_issues(ticket_ids)

    apply(module, :render, [tickets])
  end
end
