defmodule NimbleTemplate.Addons.Credo do
  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:text, ".credo.exs", ".credo.exs"}])

    project
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency()
    |> edit_mix()
  end

  defp inject_mix_dependency(project) do
    Generator.inject_mix_dependency(
      {:credo, latest_package_version(:credo), only: [:dev, :test], runtime: false}
    )

    project
  end

  defp edit_mix(%Project{mix_project?: true} = project) do
    Generator.replace_content(
      "mix.exs",
      """
            codebase: ["deps.unlock --check-unused", "format --check-formatted"]
      """,
      """
            codebase: ["deps.unlock --check-unused", "format --check-formatted", "credo --strict"]
      """
    )

    project
  end

  defp edit_mix(project) do
    Generator.replace_content(
      "mix.exs",
      """
            codebase: ["deps.unlock --check-unused", "format --check-formatted"],
      """,
      """
            codebase: ["deps.unlock --check-unused", "format --check-formatted", "credo --strict"],
      """
    )

    project
  end
end
