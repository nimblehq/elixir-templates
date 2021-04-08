defmodule NimbleTemplate.Addons.Web.CoreJS do
  @moduledoc false

  use NimbleTemplate.Addon

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

  def edit_package_json(%Project{live_project?: live_project?} = project) do
    if live_project? do
      Generator.replace_content(
        "assets/package.json",
        """
            "phoenix_html": "file:../deps/phoenix_html",
        """,
        """
            "phoenix_html": "file:../deps/phoenix_html",
            "core-js": "^3.7.0",
        """
      )
    else
      Generator.replace_content(
        "assets/package.json",
        """
            "phoenix_html": "file:../deps/phoenix_html"
        """,
        """
            "phoenix_html": "file:../deps/phoenix_html",
            "core-js": "^3.7.0"
        """
      )
    end

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
