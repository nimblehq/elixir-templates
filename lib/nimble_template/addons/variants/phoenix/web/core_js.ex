defmodule NimbleTemplate.Addons.Phoenix.Web.CoreJS do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    edit_files(project)
  end

  defp edit_files(%Project{} = project) do
    project
    |> edit_package_json()
    |> edit_app_js()

    project
  end

  def edit_package_json(%Project{} = project) do
    Generator.replace_content(
      "assets/package.json",
      """
        "dependencies": {
      """,
      """
        "dependencies": {
          "core-js": "^3.7.0",
      """
    )

    project
  end

  def edit_app_js(project) do
    Generator.replace_content(
      "assets/js/app.js",
      """
      import "phoenix_html"
      """,
      """
      // CoreJS
      import "core-js/stable"
      import "regenerator-runtime/runtime"

      import "phoenix_html"
      """
    )

    project
  end
end
