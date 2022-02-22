defmodule NimbleTemplate.Addons.Phoenix.Web.Bootstrap do
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
    |> edit_app_js()
    |> edit_app_scss()

    project
  end

  defp copy_files(%Project{} = project) do
    project
    |> copy_bootstrap()

    project
  end

  defp edit_assets_package(%Project{} = project) do
    Generator.replace_content(
      "assets/package.json",
      """
        "devDependencies": {
      """,
      """
        "devDependencies": {
          "bootstrap": "^5.0.0",
      """
    )

    project
  end

  def edit_app_js(project) do
    Generator.replace_content(
      "assets/js/app.js",
      """
      // CoreJS
      import "core-js/stable"
      import "regenerator-runtime/runtime"
      """,
      """
      // CoreJS
      import "core-js/stable"
      import "regenerator-runtime/runtime"

      // Bootstrap
      import "bootstrap/dist/js/bootstrap";
      """
    )

    project
  end

  def edit_app_scss(project) do
    Generator.replace_content(
      "assets/css/app.scss",
      """
      @import './screens';
      """,
      """
      @import './screens';

      @import './vendor/bootstrap';
      """
    )

    project
  end

  defp copy_bootstrap(
         %Project{web_module: web_module, web_path: _web_path, web_test_path: _web_test_path} =
           project
       ) do
    Generator.copy_file(
      [
        {:eex, "assets/css_bootstrap/vendor/_bootstrap.scss.eex", "assets/css/vendor/_bootstrap.scss"}
      ],
      web_module: web_module
    )

    project
  end
end
