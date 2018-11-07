defmodule Breadcrumbs do
  @moduledoc false

  @doc false
  def render(tickets, module \\ Breadcrumbs.BasicRenderer) do
    apply(module, :render, [tickets])
  end
end
