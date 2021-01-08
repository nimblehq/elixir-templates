defmodule Nimble.Phx.Gen.Template.Addons.ElixirVersion do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    copy_files(project)
  end

  defp copy_files(
         %Project{
           erlang_version: erlang_version,
           elixir_asdf_version: elixir_asdf_version
         } = project
       ) do
    Generator.copy_file([{:eex, ".tool-versions.eex", ".tool-versions"}],
      erlang_version: erlang_version,
      elixir_asdf_version: elixir_asdf_version
    )

    project
  end
end
