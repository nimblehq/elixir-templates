defmodule NimbleTemplate.Addons.Phoenix.Web.NimbleJS do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_nimble_structure()
    |> moving_js_vendor()
    |> edit_app_js()
    |> edit_es_lint_config()
  end

  defp copy_nimble_structure(project) do
    Generator.copy_directory("assets/nimble_js", "assets/js")

    project
  end

  defp moving_js_vendor(project) do
    Generator.rename_file("assets/vendor", "assets/js/vendor")

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

    Generator.replace_content("assets/js/app.js", "assets/vendor", "assets/js/vendor")

    Generator.replace_content(
      "assets/js/app.js",
      "../vendor/some-package.js",
      "./vendor/some-package.js"
    )

    Generator.replace_content("assets/js/app.js", "../vendor/topbar", "./vendor/topbar")

    project
  end

  defp edit_es_lint_config(project) do
    Generator.replace_content(
      "assets/.eslintrc.json",
      "/vendor/topbar.js",
      "/js/vendor/topbar.js"
    )

    project
  end
end
