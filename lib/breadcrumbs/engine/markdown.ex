defmodule Breadcrumbs.Markdown do
  @moduledoc """
  Module for the Markdown formatter
  """

  @doc """
  Header one
  """
  def h1(text) do
    "# " <> Kernel.to_string(text)
  end

  @doc """
  Header two
  """
  def h2(text) do
    "## " <> Kernel.to_string(text)
  end

  @doc """
  Header three
  """
  def h3(text) do
    "### " <> Kernel.to_string(text)
  end

  @doc """
  Header four
  """
  def h4(text) do
    "#### " <> Kernel.to_string(text)
  end

  @doc """
  Header five
  """
  def h5(text) do
    "##### " <> Kernel.to_string(text)
  end

  @doc """
  Linebreak
  """
  def linebreak do
    "---"
  end

  @doc """
  Unordered list
  """
  def list(text) do
    "* " <> Kernel.to_string(text)
  end

  @doc """
  Quote
  """
  def quote_block(text) do
    "> " <> Kernel.to_string(text)
  end

  @doc """
  Break
  """
  def break(quantity) do
    1..quantity
    |> Enum.map(fn _index -> "<br>" end)
    |> Enum.join()
  end
end
