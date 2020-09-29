defmodule Nimble.Phx.Gen.Template.Addons.Web.Sobelow do
  use Nimble.Phx.Gen.Template.Addon

  @versions %{
    sobelow: "~> 0.8"
  }

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files
    |> edit_files
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:text, ".sobelow-conf", ".sobelow-conf"}])

    project
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency
    |> edit_mix
  end

  defp inject_mix_dependency(%Project{} = project) do
    Generator.inject_mix_dependency(
      {:sobelow, @versions.sobelow, only: [:dev, :test], runtime: false}
    )

    project
  end

  defp edit_mix(%Project{} = project) do
    Generator.replace_content(
      "mix.exs",
      """
            codebase: ["format --check-formatted", "credo"],
      """,
      """
            codebase: ["format --check-formatted", "credo", "sobelow --config"],
      """
    )

    project
  end
end
