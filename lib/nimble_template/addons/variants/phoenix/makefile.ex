defmodule NimbleTemplate.Addons.Phoenix.Makefile do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    Generator.copy_file([{:text, "Makefile", "Makefile"}])

    project
  end
end
