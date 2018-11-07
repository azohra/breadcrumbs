defmodule Breadcrumbs.Renderer do
  @callback render(map()) :: list()
end
