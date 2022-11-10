defmodule NimbleTemplate.Addons.AsdfToolVersion do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(
        %Project{
          erlang_version: erlang_version,
          elixir_asdf_version: elixir_asdf_version,
          node_asdf_version: node_asdf_version,
          web_project?: web_project?
        } = project,
        _opts
      ) do
    Generator.copy_file!([{:eex, ".tool-versions.eex", ".tool-versions"}],
      erlang_version: erlang_version,
      elixir_asdf_version: elixir_asdf_version
    )

    if web_project? do
      Generator.append_content!(
        ".tool-versions",
        """
        nodejs #{node_asdf_version}
        """
      )
    end

    project
  end
end
