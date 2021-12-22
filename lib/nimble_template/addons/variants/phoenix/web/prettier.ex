defmodule NimbleTemplate.Addons.Phoenix.Web.Prettier do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> edit_files()
    |> copy_files()
  end

  defp edit_files(%Project{} = project) do
    project
    |> edit_npm_dev_dependencies()
    |> edit_mix()

    project
  end

  defp edit_npm_dev_dependencies(%Project{} = project) do
    Generator.replace_content(
      "assets/package.json",
      """
          "webpack-cli": "^3.3.2"
      """,
      """
          "webpack-cli": "^3.3.2",
          "prettier": "2.2.1",
          "prettier-plugin-eex": "^0.5.0"
      """
    )

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
            prettier: "cmd ./assets/node_modules/.bin/prettier --check . --color",
            "prettier.fix": "cmd ./assets/node_modules/.bin/prettier --write . --color",
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
              "prettier"
            ],
      """
    )

    project
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:text, ".prettierignore", ".prettierignore"}])
    Generator.copy_file([{:eex, ".prettierrc.eex", ".prettierrc"}])

    project
  end
end
