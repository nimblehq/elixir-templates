defmodule Nimble.Template.Addons.Makefile do
  use Nimble.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    Generator.copy_file([{:text, "Makefile", "Makefile"}])

    project
  end
end
