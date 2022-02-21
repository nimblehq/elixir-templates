defmodule NimbleTemplate.Addons.Phoenix.Web.NimbleCSS do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @dart_sass_version "1.49.8"

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> remove_default_phoenix_structure()
    |> copy_nimble_structure()
    |> edit_app_js()
    |> edit_style_lint_rc()
    |> inject_mix_dependency()
    |> edit_config()
    |> edit_mix()
  end

  defp inject_mix_dependency(%Project{} = project) do
    Generator.inject_mix_dependency(
      {:dart_sass, latest_package_version(:dart_sass), runtime: "Mix.env() == :dev"}
    )

    Generator.replace_content(
      "mix.exs",
      "runtime: \"Mix.env() == :dev\"",
      "runtime: Mix.env() == :dev"
    )

    project
  end

  defp edit_config(%Project{} = project) do
    Generator.replace_content(
      "config/config.exs",
      """
      # Configure esbuild (the version is required)
      """,
      """
      # Configure dart_sass (the version is required)
      config :dart_sass,
        version: "#{@dart_sass_version}",
        default: [
          args: ~w(css/app.scss ../priv/static/assets/app.css),
          cd: Path.expand("../assets", __DIR__)
        ]

      # Configure esbuild (the version is required)
      """
    )

    Generator.replace_content(
      "config/dev.exs",
      """
        watchers: [
      """,
      """
        watchers: [
          sass: {
            DartSass,
            :install_and_run,
            [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]
          },
      """
    )

    project
  end

  defp edit_mix(project) do
    Generator.replace_content(
      "mix.exs",
      """
            "assets.deploy": ["esbuild default --minify", "phx.digest"]
      """,
      """
            "assets.deploy": [
              "esbuild default --minify",
              "sass default --no-source-map --style=compressed",
              "phx.digest"
            ]
      """
    )

    project
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
    Generator.delete_content(
      "assets/js/app.js",
      "import \"../css/app.css\""
    )

    project
  end

  defp edit_style_lint_rc(project) do
    Generator.replace_content(
      "assets/.stylelintrc.json",
      """
        "ignoreFiles": [
          "css/app.css",
          "css/phoenix.css"
        ],
      """,
      """
        "ignoreFiles": [],
      """
    )

    project
  end
end
