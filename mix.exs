defmodule NimbleTemplate.MixProject do
  use Mix.Project

  def project do
    [
      app: :nimble_template,
      version: "4.0.0",
      description: "Phoenix/Mix template for projects at [Nimble](https://nimblehq.co/).",
      elixir: "~> 1.13.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      source_url: "https://github.com/nimblehq/elixir-templates"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:httpoison, "~> 1.7"},
      {:jason, "~> 1.2"},
      {:mimic, "~> 1.3", only: :test},
      {:phoenix, "~> 1.6.6"}
    ]
  end

  defp aliases do
    [
      codebase: ["deps.unlock --check-unused", "format --check-formatted", "credo --strict"]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nimblehq/elixir-templates"}
    ]
  end
end
