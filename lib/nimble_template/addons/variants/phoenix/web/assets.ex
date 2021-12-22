defmodule NimbleTemplate.Addons.Phoenix.Web.Assets do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    edit_files(project)
  end

  defp edit_files(%Project{} = project) do
    project
    |> edit_mix()
    |> edit_assets_package()

    project
  end

  defp edit_mix(%Project{} = project) do
    Generator.inject_content(
      "mix.exs",
      """
        defp aliases do
          [
      """,
      """
            "assets.compile": &compile_assets/1,
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
        end
      end
      """,
      """
        end

        defp compile_assets(_) do
          Mix.shell().cmd("npm run --prefix assets build:dev", quiet: true)
        end
      end
      """
    )

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
              "cmd npm run eslint --prefix assets",
              "cmd npm run stylelint --prefix assets"
            ],
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
            "codebase.fix": ["deps.clean --unlock --unused", "format"],
      """,
      """
            "codebase.fix": [
              "deps.clean --unlock --unused",
              "format",
              "cmd npm run eslint.fix --prefix assets",
              "cmd npm run stylelint.fix --prefix assets"
            ],
      """
    )

    project
  end

  defp edit_assets_package(%Project{} = project) do
    Generator.replace_content(
      "assets/package.json",
      """
          "watch": "webpack --mode development --watch"
      """,
      """
          "watch": "webpack --mode development --watch",
          "build:dev": "webpack --mode development"
      """
    )

    project
  end
end
