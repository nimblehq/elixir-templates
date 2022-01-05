defmodule NimbleTemplate.Addons.Phoenix.Web.NimbleCSS do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> remove_default_phoenix_structure()
    |> copy_nimble_structure()
    |> edit_app_js()
  end

  defp remove_default_phoenix_structure(project) do
    File.rm_rf!("assets/css")

    project
  end

  defp copy_nimble_structure(project) do
    Generator.copy_directory("assets/css")

    project
  end

  defp edit_app_js(project) do
    Generator.replace_content(
      "assets/js/app.js",
      "/css/app.css",
      "/css/app.scss"
    )

    project
  end
end
