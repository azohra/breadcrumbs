defmodule Breadcrumbs.BasicRendererTest do
  use ExUnit.Case
  doctest Breadcrumbs.BasicRenderer

  alias Breadcrumbs.BasicRenderer

  @ticket %Ticket{
    id: "1",
    self: "www.jira.example.com/rest/api/3/issue/1",
    key: "SAMPLE-1",
    fields: []
  }

  @basic_message "Release Notes:\nClosed: SAMPLE-1\nErrors:"

  test "Render using built-in basic renderer" do
    scrape_data = %ScrapeData{
      valid: [@ticket],
      errors: []
    }

    assert BasicRenderer.render(scrape_data) == @basic_message
  end
end
