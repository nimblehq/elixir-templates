defmodule NimbleTemplate.Addons.Readme do
  use NimbleTemplate.Addon

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
           web_project?: web_project?,
           mix_project?: mix_project?,
           erlang_version: erlang_version,
           elixir_version: elixir_version
         } = project
       ) do
    template_file_path =
      if mix_project? do
        "README.md.mix.eex"
      else
        "README.md.eex"
      end

    Generator.copy_file([{:eex, template_file_path, "README.md"}],
      erlang_version: erlang_version,
      elixir_version: elixir_version,
      web_project?: web_project?
    )

    project
  end
end
