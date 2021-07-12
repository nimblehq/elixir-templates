defmodule NimbleTemplate.Addons.Phoenix.Web.GithubWiki do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    file_path = ".github/workflows/publish_wiki.yml"

    Generator.copy_file([{:text, file_path, file_path}])

    project
  end
end
