defmodule NimbleTemplate.Addons.Makefile do
  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    Generator.copy_file([{:text, "Makefile", "Makefile"}])

    project
  end
end
