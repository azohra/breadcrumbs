defmodule Breadcrumbs.MixProject do
  use Mix.Project

  def project do
    [
      app: :breadcrumbs,
      version: "0.1.0",
      elixir: "~> 1.7",
      test_coverage: [tool: ExCoveralls],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Breadcrumbs.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.2"},
      {:poison, ">= 1.2.0"},
      {:poolboy, "~> 1.5"},
      {:credo, "~> 0.10.0", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
    ]
  end
end
