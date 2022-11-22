defmodule NimbleTemplate.Addons.Phoenix.Web.HeexFormatter do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    Generator.replace_content!(".formatter.exs", "\"*.{ex,exs}\"", "\"*.{heex,ex,exs}\"")

    Generator.replace_content!(
      ".formatter.exs",
      "\"{config,lib,test}/**/*.{ex,exs}\"",
      "\"{config,lib,test}/**/*.{heex,ex,exs}\""
    )

    Generator.replace_content!(
      ".formatter.exs",
      """
      import_deps: [:ecto, :phoenix],
      """,
      """
      import_deps: [:ecto, :phoenix],
      plugins: [Phoenix.LiveView.HTMLFormatter],
      """
    )

    project
  end
end
