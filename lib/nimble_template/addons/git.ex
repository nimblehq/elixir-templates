defmodule NimbleTemplate.Addons.Git do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    Generator.append_content(".gitignore", """
    # Mac OS
    .DS_Store

    # IDE
    .idea
    .vscode

    # Iex
    .iex.exs
    """)

    project
  end
end
