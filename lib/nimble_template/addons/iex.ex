defmodule NimbleTemplate.Addons.Iex do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{base_module: base_module, web_project?: web_project?} = project, _opts) do
    Generator.copy_file!([{:eex, ".iex.exs.eex", ".iex.exs"}],
      base_module: base_module,
      web_project?: web_project?
    )

    project
  end
end
