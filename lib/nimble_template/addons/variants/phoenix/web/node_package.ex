defmodule NimbleTemplate.Addons.Phoenix.Web.NodePackage do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    Generator.copy_file([{:text, "assets/package.json", "assets/package.json"}])

    project
  end
end
