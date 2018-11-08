defmodule Breadcrumbs.BasicFormatterTest do
  use ExUnit.Case
  doctest Breadcrumbs.BasicFormatter

  import Breadcrumbs.BasicFormatter

  @valid_issue %Ticket{
    id: "1",
    self: "www.jira.example.com/rest/api/3/issue/1",
    key: "SAMPLE-1",
    fields: []
  }

  @error_issue %ErrorTicket{
    key: "SAMPLE-2",
    reason: "not found"
  }

  test "format valid ticket" do
    assert format(@valid_issue) == "Closed: SAMPLE-1"
  end

  test "format error ticket" do
    assert format(@error_issue) == "Error in getting ticket: SAMPLE-2, Reason: not found"
  end
end
