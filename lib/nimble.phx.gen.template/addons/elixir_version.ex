defmodule Nimble.Phx.Gen.Template.Addons.ElixirVersion do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(
         %Project{
           erlang_asdf_version: erlang_asdf_version,
           elixir_asdf_version: elixir_asdf_version
         } = project
       ) do
    Generator.copy_file([{:eex, ".tool-versions.eex", ".tool-versions"}],
      erlang_asdf_version: erlang_asdf_version,
      elixir_asdf_version: elixir_asdf_version
    )

    project
  end

  defp edit_files(%Project{elixir_mix_version: elixir_mix_version} = project) do
    Generator.replace_content(
      "mix.exs",
      """
            elixir: "~> 1.7",
      """,
      """
            elixir: "~> #{elixir_mix_version}",
      """
    )

    project
  end
end
