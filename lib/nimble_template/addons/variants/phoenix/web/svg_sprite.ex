defmodule NimbleTemplate.Addons.Phoenix.Web.SvgSprite do
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
    |> edit_web_entrypoint()
    |> edit_wiki_sidebar()

    project
  end

  defp copy_files(%Project{} = project) do
    project
    |> copy_icon_helper()
    |> copy_wiki_documentation()

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
          "svg-sprite.generate-icon": "svg-sprite --shape-id-generator \\"icon-%s\\" --symbol --symbol-dest static/images --symbol-sprite icon-sprite.svg static/images/icons/*.svg",
      """
    )

    Generator.replace_content(
      "assets/package.json",
      """
        "devDependencies": {
      """,
      """
        "devDependencies": {
          "svg-sprite": "^1.5.3",
      """
    )

    project
  end

  defp edit_web_entrypoint(%Project{web_module: web_module, web_path: web_path} = project) do
    Generator.replace_content(
      "#{web_path}.ex",
      """
            # Include shared imports and aliases for views
            unquote(view_helpers())
      """,
      """
            import #{web_module}.IconHelper

            # Include shared imports and aliases for views
            unquote(view_helpers())
      """
    )

    project
  end

  defp edit_wiki_sidebar(project) do
    if has_github_wiki_directory?() do
      Generator.replace_content(
        ".github/wiki/_Sidebar.md",
        """
        - [[Getting Started]]
        """,
        """
        - [[Getting Started]]

        ## Operations

        - [[Icon Sprite]]
        """
      )
    end

    project
  end

  defp copy_icon_helper(
         %Project{web_module: web_module, web_path: web_path, web_test_path: web_test_path} =
           project
       ) do
    Generator.copy_file(
      [
        {:eex, "lib/otp_app_web/helpers/icon_helper.ex.eex", "#{web_path}/helpers/icon_helper.ex"},
        {:eex, "test/otp_app_web/helpers/icon_helper_test.exs.eex",
         "#{web_test_path}/helpers/icon_helper_test.exs"}
      ],
      web_module: web_module
    )

    project
  end

  defp copy_wiki_documentation(%Project{} = project) do
    if has_github_wiki_directory?() do
      Generator.copy_file([{:text, ".github/wiki/Icon-Sprite.md", ".github/wiki/Icon-Sprite.md"}])
    end

    project
  end

  defp has_github_wiki_directory?, do: File.dir?(".github/wiki/")
end
