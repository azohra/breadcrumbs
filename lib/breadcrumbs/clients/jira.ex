defmodule Breadcrumbs.Clients.Jira do
  @moduledoc false

  use Tesla

  use Task, restart: :transient

  import Breadcrumbs.Pool, only: [distribute_request: 1]

  @pool_size Application.get_env(:breadcrumbs, :pool_size)

  plug(Tesla.Middleware.BaseUrl, Application.get_env(:breadcrumbs, :jira_api_url))

  plug(Tesla.Middleware.Headers, [
    {"content-type", "application/json"},
    Application.get_env(:breadcrumbs, :jira_api_auth)
  ])

  @doc false
  def get_issues(ids) do
    ids
    |> Enum.chunk_every(@pool_size)
    |> Enum.map(fn list -> pmap(list, &distribute_request/1) end)
    |> List.flatten()
    |> Enum.reduce(%ScrapeData{valid: [], errors: []}, fn resp, acc -> organize(resp, acc) end)
  end

  @doc false
  def get_issue(issue) do
    case get("/issue/#{issue}") do
      {:error, reason} ->
        {:error, %ErrorTicket{key: issue, reason: reason}}

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
        {:error, %ErrorTicket{key: issue_id, reason: "not found"}}

      502 ->
        {:error, %ErrorTicket{key: issue_id, reason: "rate limit exceeded"}}

      code ->
        {:error, %ErrorTicket{key: issue_id, reason: "code #{code}"}}
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

  def pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await(&1, :infinity))
  end
end
