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
    Generator.replace_content(
      "assets/package.json",
      """
        "devDependencies": {
      """,
      """
        "devDependencies": {
          "autoprefixer": "^10.4.1",
          "postcss": "^8.4.5",
          "postcss-loader": "^6.2.1",
      """
    )

    project
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:text, "assets/postcss.config.js", "assets/postcss.config.js"}])

    project
  end
end
