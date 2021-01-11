defmodule Nimble.Template.Addons.Web.Sobelow do
  use Nimble.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:text, ".sobelow-conf", ".sobelow-conf"}])

    project
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency()
    |> edit_mix()
  end

  defp inject_mix_dependency(%Project{} = project) do
    Generator.inject_mix_dependency(
      {:sobelow, latest_package_version(:sobelow), only: [:dev, :test], runtime: false}
    )

    project
  end

  defp edit_mix(%Project{} = project) do
    Generator.replace_content(
      "mix.exs",
      """
            codebase: ["deps.unlock --check-unused", "format --check-formatted", "credo --strict"],
      """,
      """
            codebase: [
              "deps.unlock --check-unused",
              "format --check-formatted",
              "credo --strict",
              "sobelow --config"
            ],
      """
    )

    project
  end
end
