defmodule NimbleTemplate.Addons.Phoenix.Web.PostCSS do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    project
    |> edit_files!()
    |> copy_files!()
  end

  defp edit_files!(%Project{} = project) do
    project
    |> edit_package!()
    |> edit_mix!()
    |> edit_phoenix_watcher!()

    project
  end

  defp edit_package!(project) do
    Generator.replace_content!(
      "assets/package.json",
      """
        "devDependencies": {
      """,
      """
        "devDependencies": {
          "postcss": "8.4.19",
          "postcss-scss": "4.0.6",
          "postcss-cli": "9.1.0",
          "postcss-load-config": "3.1.4",
          "autoprefixer": "10.4.5",
      """
    )

    Generator.replace_content!(
      "assets/package.json",
      """
        "scripts": {
      """,
      """
        "scripts": {
          "postcss": "postcss ../priv/static/assets/*.css --dir ../priv/static/assets/ --config ./",
          "postcss.watch": "postcss ../priv/static/assets/*.css --dir ../priv/static/assets/ --config ./ --watch",
      """
    )

    project
  end

  defp edit_mix!(project) do
    Generator.replace_content!(
      "mix.exs",
      """
            "assets.deploy": ["esbuild app --minify", "phx.digest"]
      """,
      """
            "assets.deploy": [
              "esbuild app --minify",
              "cmd npm run postcss --prefix assets",
              "phx.digest"
            ]
      """
    )

    project
  end

  defp edit_phoenix_watcher!(project) do
    Generator.replace_content!(
      "config/dev.exs",
      """
        watchers: [
      """,
      """
        watchers: [
          npm: [
            "run",
            "postcss.watch",
            cd: Path.expand("../assets", __DIR__)
          ],
      """
    )

    project
  end

  defp copy_files!(%Project{} = project) do
    Generator.copy_file!([{:text, "assets/postcss.config.js", "assets/postcss.config.js"}])

    project
  end
end
