defmodule NimbleTemplate.Addons.Phoenix.Web.PostCSS do
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
    |> edit_package()
    |> edit_webpack_config()

    project
  end

  defp edit_package(project) do
    Generator.replace_content(
      "assets/package.json",
      """
        "devDependencies": {
      """,
      """
        "devDependencies": {
          "autoprefixer": "^10.4.1",
          "postcss": "^8.4.5",
          "postcss-loader": "^4.2.0",
      """
    )

    project
  end

  defp edit_webpack_config(project) do
    Generator.replace_content(
      "assets/webpack.config.js",
      """
                  MiniCssExtractPlugin.loader,
                  'css-loader',
      """,
      """
                  MiniCssExtractPlugin.loader,
                  'css-loader',
                  'postcss-loader',
      """
    )

    project
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:text, "assets/postcss.config.js", "assets/postcss.config.js"}])

    project
  end
end
