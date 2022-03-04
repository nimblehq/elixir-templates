defmodule NimbleTemplate.Addons.Phoenix.Web.Bootstrap do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, opts) do
    project
    |> edit_files(opts)
    |> copy_files()
  end

  defp edit_files(%Project{} = project, opts) do
    project
    |> edit_assets_package()
    |> edit_app_js(opts)
    |> edit_app_scss(opts)
    |> edit_vendor_index(opts)
    |> edit_css_variables(opts)

    project
  end

  defp copy_files(%Project{} = project) do
    copy_bootstrap_vendor(project)

    project
  end

  defp edit_assets_package(%Project{} = project) do
    Generator.replace_content(
      "assets/package.json",
      """
        "dependencies": {
      """,
      """
        "dependencies": {
          "@popperjs/core": "^2.11.2",
          "bootstrap": "5.1.3",
      """
    )

    project
  end

  defp edit_app_js(project, %{with_nimble_js_addon: true}) do
    Generator.replace_content(
      "assets/js/app.js",
      """
      import "phoenix_html"
      """,
      """
      // Bootstrap
      import "bootstrap/dist/js/bootstrap";

      import "phoenix_html"
      """
    )

    project
  end

  defp edit_app_js(project, %{with_nimble_js_addon: false}) do
    Generator.replace_content(
      "assets/js/app.js",
      """
      import "phoenix_html"
      """,
      """
      // Bootstrap
      import "bootstrap/dist/js/bootstrap";

      import "phoenix_html"
      """
    )

    project
  end

  defp edit_app_scss(project, %{with_nimble_css_addon: true}), do: project

  defp edit_app_scss(project, %{with_nimble_css_addon: false}) do
    Generator.replace_content(
      "assets/css/app.scss",
      """
      @import "./phoenix.css";
      """,
      """
      @import "./phoenix.css";

      @import './vendor/';
      """
    )

    project
  end

  defp edit_css_variables(project, %{with_nimble_css_addon: false}) do
    Generator.create_file(
      "assets/css/_variables.scss",
      """
      ////////////////////////////////
      // Shared variables           //
      ////////////////////////////////


      ////////////////////////////////
      // Custom Bootstrap variables //
      ////////////////////////////////
      """
    )

    project
  end

  defp edit_css_variables(project, %{with_nimble_css_addon: true}) do
    Generator.append_content(
      "assets/css/_variables.scss",
      """
      ////////////////////////////////
      // Shared variables           //
      ////////////////////////////////


      ////////////////////////////////
      // Custom Bootstrap variables //
      ////////////////////////////////
      """
    )

    project
  end

  defp edit_vendor_index(project, %{with_nimble_css_addon: true}) do
    Generator.append_content("assets/css/vendor/_index.scss", "@import './bootstrap';")

    project
  end

  defp edit_vendor_index(project, %{with_nimble_css_addon: false}) do
    Generator.make_directory("assets/css/vendor/", false)
    Generator.create_file("assets/css/vendor/_index.scss", "@import './bootstrap';")

    project
  end

  defp copy_bootstrap_vendor(%Project{} = project) do
    Generator.copy_file([
      {:text, "assets/bootstrap_css/vendor/_bootstrap.scss", "assets/css/vendor/_bootstrap.scss"}
    ])

    project
  end
end
