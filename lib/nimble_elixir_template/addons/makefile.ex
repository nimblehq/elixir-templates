defmodule Nimble.Elixir.Template.Addons.Makefile do
  use Nimble.Elixir.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    Generator.copy_file([{:text, "Makefile", "Makefile"}])

    project
  end
end
