defmodule Nimble.Elixir.Template.MixProject do
  use Mix.Project

  def project do
    [
      app: :nimble_elixir_template,
      version: "2.2.0",
      description: "Project repository template to set up all public Elixir/Phoenix projects at Nimble",
      elixir: "~> 1.11.3",
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
      {:phoenix, "~> 1.5.7"},
      {:jason, "~> 1.2.2"},
      {:httpoison, "~> 1.7.0"},
      {:mimic, "~> 1.3.1", only: :test},
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.23.0", only: :dev, runtime: false}
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
