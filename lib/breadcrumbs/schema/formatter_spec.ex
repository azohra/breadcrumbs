defmodule Breadcrumbs.Formatter do
  @moduledoc false
  @callback format(map()) :: list()
end
