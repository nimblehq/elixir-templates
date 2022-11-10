defmodule NimbleTemplate.Addons.Phoenix.Web.DartSass do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @dart_sass_version "1.49.11"

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    project
    |> inject_mix_dependency!()
    |> edit_config!()
    |> edit_mix!()
    |> edit_app_js!()
    |> rename_app_css!()
  end

  defp inject_mix_dependency!(%Project{} = project) do
    Generator.inject_mix_dependency!(
      {:dart_sass, latest_package_version(:dart_sass), runtime: "Mix.env() == :dev"}
    )

    Generator.replace_content!(
      "mix.exs",
      "runtime: \"Mix.env() == :dev\"",
      "runtime: Mix.env() == :dev"
    )

    project
  end

  defp edit_config!(%Project{} = project) do
    Generator.replace_content!(
      "config/config.exs",
      """
      # Configure esbuild (the version is required)
      """,
      """
      # Configure dart_sass (the version is required)
      config :dart_sass,
        version: "#{@dart_sass_version}",
        app: [
          args: ~w(
            --load-path=./node_modules
            css/app.scss
            ../priv/static/assets/app.css
            ),
          cd: Path.expand("../assets", __DIR__)
        ]

      # Configure esbuild (the version is required)
      """
    )

    Generator.replace_content!(
      "config/dev.exs",
      """
        watchers: [
      """,
      """
        watchers: [
          app_sass: {
            DartSass,
            :install_and_run,
            [:app, ~w(--embed-source-map --source-map-urls=absolute --watch)]
          },
      """
    )

    project
  end

  defp edit_mix!(project) do
    Generator.replace_content!(
      "mix.exs",
      """
            "assets.deploy": [
              "esbuild app --minify",
              "cmd npm run postcss --prefix assets",
              "phx.digest"
            ]
      """,
      """
            "assets.deploy": [
              "esbuild app --minify",
              "sass app --no-source-map --style=compressed",
              "cmd npm run postcss --prefix assets",
              "phx.digest"
            ]
      """
    )

    project
  end

  defp edit_app_js!(project) do
    Generator.delete_content!(
      "assets/js/app.js",
      """
      // We import the CSS which is extracted to its own file by esbuild.
      // Remove this line if you add a your own CSS build pipeline (e.g postcss).
      import "../css/app.css"

      """
    )

    project
  end

  defp rename_app_css!(project) do
    Generator.rename_file!(
      "assets/css/app.css",
      "assets/css/app.scss"
    )

    project
  end
end
