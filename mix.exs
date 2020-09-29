defmodule NimblePhxGenTemplate.MixProject do
  use Mix.Project

  def project do
    [
      app: :nimble_phx_gen_template,
      version: "0.1.0",
      elixir: "~> 1.10",
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

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.5.5"},
      {:jason, "~> 1.2.2"}
    ]
  end

  defp aliases do
    [
      codebase: ["format --check-formatted"]
    ]
  end
end
