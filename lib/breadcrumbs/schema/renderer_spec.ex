defmodule Breadcrumbs.Renderer do
  @moduledoc false

  @callback render(map()) :: list()
end
