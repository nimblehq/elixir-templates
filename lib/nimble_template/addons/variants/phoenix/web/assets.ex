defmodule NimbleTemplate.Addons.Phoenix.Web.Assets do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    edit_files(project)
  end

  defp edit_files(%Project{} = project) do
    enable_gzip_for_static_assets(project)

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
