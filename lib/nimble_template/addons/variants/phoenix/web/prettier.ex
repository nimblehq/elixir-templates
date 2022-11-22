defmodule NimbleTemplate.Addons.Phoenix.Web.Prettier do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    project
    |> edit_files!()
    |> copy_files!()
  end

  defp edit_files!(%Project{} = project) do
    project
    |> edit_npm_dev_dependencies!()
    |> edit_mix!()

    project
  end

  defp edit_npm_dev_dependencies!(%Project{} = project) do
    Generator.replace_content!(
      "assets/package.json",
      """
        "devDependencies": {
      """,
      """
        "devDependencies": {
          "prettier": "2.6.2",
          "prettier-plugin-eex": "0.5.0"
      """
    )

    project
  end

  defp edit_mix!(%Project{} = project) do
    project
    |> add_prettier_aliases!()
    |> add_prettier_into_codebase!()
    |> add_prettier_fix_into_codebase_fix!()
  end

  defp add_prettier_aliases!(%Project{} = project) do
    Generator.inject_content!(
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

    project
  end

  defp add_prettier_into_codebase!(%Project{} = project) do
    Generator.replace_content!(
      "mix.exs",
      """
            codebase: [
      """,
      """
            codebase: [
              "prettier",
      """
    )

    project
  end

  defp add_prettier_fix_into_codebase_fix!(%Project{} = project) do
    Generator.replace_content!(
      "mix.exs",
      """
            "codebase.fix": [
      """,
      """
            "codebase.fix": [
              "prettier.fix",
      """
    )

    project
  end

  defp copy_files!(%Project{} = project) do
    Generator.copy_file!([{:text, ".prettierignore", ".prettierignore"}])
    Generator.copy_file!([{:text, ".prettierrc.yaml", ".prettierrc.yaml"}])

    project
  end
end
