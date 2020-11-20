defmodule Nimble.Phx.Gen.Template.Addons.Readme do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> delete_default_readme_file()
    |> copy_files()
  end

  def delete_default_readme_file(project) do
    Generator.delete_file("README.md")

    project
  end

  defp copy_files(
         %Project{
           erlang_asdf_version: erlang_asdf_version,
           elixir_mix_version: elixir_mix_version
         } = project
       ) do
    Generator.copy_file([{:eex, "README.md.eex", "README.md"}],
      erlang_version: erlang_asdf_version,
      elixir_version: elixir_mix_version
    )

    project
  end
end
