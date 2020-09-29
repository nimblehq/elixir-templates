defmodule Nimble.Phx.Gen.Template.Addons.Credo do
  use Nimble.Phx.Gen.Template.Addon

  @versions %{
    credo: "~> 1.4"
  }

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files
    |> edit_files()
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:text, ".credo.exs", ".credo.exs"}])

    project
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency
    |> edit_mix
  end

  defp inject_mix_dependency(project) do
    Generator.inject_mix_dependency(
      {:credo, @versions.credo, only: [:dev, :test], runtime: false}
    )

    project
  end

  defp edit_mix(project) do
    Generator.inject_content(
      "mix.exs",
      """
        defp aliases do
          [
      """,
      """
            codebase: ["format --check-formatted", "credo"],
      """
    )

    project
  end
end
