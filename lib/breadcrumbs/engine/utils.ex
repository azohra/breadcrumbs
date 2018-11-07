defmodule Breadcrumbs.Utils do
  @moduledoc false

  @doc """
  Append one string to another
  """
  @spec append(String.t(), String.t()) :: String.t()
  def append("", b), do: b
  def append(a, ""), do: a
  def append(a, b), do: a <> b

  @doc """
  Append one string to another, if the first one is non-empty it will add a newline between the strings
  """
  @spec appendln(String.t(), String.t()) :: String.t()
  def appendln("", b), do: b
  def appendln(a, ""), do: a <> "\n"
  def appendln(a, b), do: a <> "\n" <> b
end
