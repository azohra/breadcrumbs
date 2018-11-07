defmodule BreadcrumbsTest do
  use ExUnit.Case
  doctest Breadcrumbs

  @ticket %Issue{
    id: "1",
    self: "www.jira.example.com/rest/api/3/issue/1",
    key: "SAMPLE-1",
    fields: []
  }

  @basic_message "Release Notes:\nTicket: SAMPLE-1"

  test "Render using built-in basic renderer" do
    assert Breadcrumbs.render([@ticket]) == @basic_message
  end
end
