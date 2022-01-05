defmodule NimbleTemplate.Addons.Phoenix.Web.Assets do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    edit_files(project)
  end

  defp edit_files(%Project{} = project) do
    project
    |> edit_mix()
    |> edit_assets_package()
    |> enable_gzip_for_static_assets()

    project
  end

  defp edit_mix(%Project{} = project) do
    Generator.inject_content(
      "mix.exs",
      """
        defp aliases do
          [
      """,
      """
            "assets.compile": &compile_assets/1,
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
        end
      end
      """,
      """
        end

        defp compile_assets(_) do
          Mix.shell().cmd("npm run --prefix assets build:dev", quiet: true)
        end
      end
      """
    )

    project
  end

  defp edit_assets_package(%Project{} = project) do
    Generator.replace_content(
      "assets/package.json",
      """
        "scripts": {
      """,
      """
        "scripts": {
          "build:dev": "webpack --mode development",
      """
    )

    project
  end

  defp enable_gzip_for_static_assets(%Project{web_path: web_path} = project) do
    Generator.replace_content(
      "#{web_path}/endpoint.ex",
      """
          gzip: false,
      """,
      """
          gzip: true,
      """
    )

    project
  end
end
