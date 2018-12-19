defmodule Breadcrumbs.MixProject do
  use Mix.Project

  def project do
    [
      app: :breadcrumbs,
      version: "0.2.0",
      elixir: "~> 1.7",
      test_coverage: [tool: ExCoveralls],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Breadcrumbs",
      source_url: "https://github.com/azohra/Breadcrumbs"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Breadcrumbs.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:tesla, "~> 1.2"},
      {:poison, ">= 1.2.0"},
      {:credo, "~> 0.10.0", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
    ]
  end

  defp description() do
    "An elixir application that scrapes and renders release notes based on Jira tickets."
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE.md CHANGELOG.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/azohra/Breadcrumbs"}
    ]
  end
end
