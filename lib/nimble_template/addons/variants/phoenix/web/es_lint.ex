defmodule NimbleTemplate.Addons.Phoenix.Web.EsLint do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> edit_files()
    |> copy_files()
  end

  defp edit_files(%Project{} = project) do
    project
    |> edit_assets_package()
    |> edit_mix()
    |> edit_app_js()

    project
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:text, "assets/.eslintrc.json", "assets/.eslintrc.json"}])

    project
  end

  defp edit_assets_package(%Project{} = project) do
    Generator.replace_content(
      "assets/package.json",
      """
        "scripts": {
      """,
      """
        "scripts": {
          "eslint": "eslint --color ./",
          "eslint.fix": "eslint --color --fix ./"
      """
    )

    Generator.replace_content(
      "assets/package.json",
      """
        "devDependencies": {
      """,
      """
        "devDependencies": {
          "eslint": "8.14.0",
          "eslint-config-prettier": "8.5.0",
          "eslint-plugin-prettier": "4.0.0",
      """
    )

    project
  end

  defp edit_mix(%Project{} = project) do
    Generator.replace_content(
      "mix.exs",
      """
            codebase: [
      """,
      """
            codebase: [
              "cmd npm run eslint --prefix assets",
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
            "codebase.fix": [
      """,
      """
            "codebase.fix": [
              "cmd npm run eslint.fix --prefix assets",
      """
    )

    project
  end

  def edit_app_js(%Project{live_project?: true} = project) do
    Generator.replace_content(
      "assets/js/app.js",
      "window.addEventListener(\"phx:page-loading-start\", info => topbar.show())",
      "window.addEventListener(\"phx:page-loading-start\", _info => topbar.show())"
    )

    Generator.replace_content(
      "assets/js/app.js",
      "window.addEventListener(\"phx:page-loading-stop\", info => topbar.hide())",
      "window.addEventListener(\"phx:page-loading-stop\", _info => topbar.hide())"
    )

    project
  end

  def edit_app_js(project), do: project
end
