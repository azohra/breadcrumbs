defmodule Breadcrumbs.Clients.Jira do
  @moduledoc false

  use Tesla

  @jira_base_url Application.get_env(:breadcrumbs, :jira_base_url)
  @jira_headers Application.get_env(:breadcrumbs, :jira_headers)

  plug(Tesla.Middleware.BaseUrl, @jira_base_url)
  plug(Tesla.Middleware.Headers, @jira_headers)

  @doc false
  def get_issues(ids) do
    ids
    |> Enum.map(fn id -> get_issue(id) end)
    |> Enum.reduce(%ScrapeData{valid: [], errors: []}, fn resp, acc -> organize(resp, acc) end)
  end

  @doc false
  def get_issue(issue) do
    case get("/issue/#{issue}") do
      {:error, reason} ->
        {:error, %{issue: issue, reason: reason}}

      {:ok, resp} ->
        parse_resp(resp, issue)
    end
  end

  defp parse_resp(resp, issue_id) do
    case resp.status do
      200 ->
        ticket =
          resp.body
          |> Poison.decode!()
          |> cast_to_ticket

        {:ok, ticket}

      404 ->
        {:error, %ErrorTicket{ticket: issue_id, reason: "not found"}}
    end
  end

  defp cast_to_ticket(body) do
    %Ticket{
      id: body["id"],
      self: body["self"],
      key: body["key"],
      fields: body["fields"]
    }
  end

  defp organize({:ok, %Ticket{} = ticket}, %ScrapeData{valid: valid, errors: errors}),
    do: %ScrapeData{valid: [ticket | valid], errors: errors}

  defp organize({:error, error}, %ScrapeData{valid: valid, errors: errors}),
    do: %ScrapeData{valid: valid, errors: [error | errors]}
end
