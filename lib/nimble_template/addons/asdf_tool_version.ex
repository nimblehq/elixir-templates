defmodule NimbleTemplate.Addons.AsdfToolVersion do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(
        %Project{
          erlang_version: erlang_version,
          elixir_asdf_version: elixir_asdf_version
        } = project,
        _opts
      ) do
    Generator.copy_file([{:eex, ".tool-versions.eex", ".tool-versions"}],
      erlang_version: erlang_version,
      elixir_asdf_version: elixir_asdf_version
    )

    project
  end
end
