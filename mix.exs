defmodule NimblePhxGenTemplate.MixProject do
  use Mix.Project

  def project do
    [
      app: :nimble_phx_gen_template,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
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
      {:phoenix, "~> 1.5.5"},
      {:jason, "~> 1.2.2"},
      {:httpoison, "~> 1.7.0"},
      {:mox, "~> 1.0", only: :test},
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      codebase: ["format --check-formatted", "credo --strict"]
    ]
  end
end
