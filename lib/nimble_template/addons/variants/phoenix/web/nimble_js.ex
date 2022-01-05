defmodule NimbleTemplate.Addons.Phoenix.Web.NimbleJS do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_nimble_structure()
    |> edit_app_js()
  end

  defp copy_nimble_structure(project) do
    Generator.copy_directory("assets/js")

    project
  end

  defp edit_app_js(project) do
    Generator.append_content(
      "assets/js/app.js",
      """

      // Application
      import "./initializers/";

      import "./screens/";

      """
    )

    project
  end
end
