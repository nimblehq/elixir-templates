defmodule Nimble.Elixir.Template.Addons.Readme do
  use Nimble.Elixir.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> delete_files()
    |> copy_files()
  end

  def delete_files(project) do
    File.rm("README.md")

    project
  end

  defp copy_files(
         %Project{
           api_project?: api_project?,
           erlang_asdf_version: erlang_asdf_version,
           elixir_mix_version: elixir_mix_version
         } = project
       ) do
    Generator.copy_file([{:eex, "README.md.eex", "README.md"}],
      erlang_version: erlang_asdf_version,
      elixir_version: elixir_mix_version,
      web_project?: !api_project?
    )

    project
  end
end
