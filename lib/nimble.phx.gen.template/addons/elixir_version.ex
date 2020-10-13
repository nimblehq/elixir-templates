defmodule Nimble.Phx.Gen.Template.Addons.ElixirVersion do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(project) do
    Generator.copy_file([{:text, ".tool-versions", ".tool-versions"}])

    project
  end

  defp edit_files(project) do
    Generator.replace_content(
      "mix.exs",
      """
            elixir: "~> 1.7",
      """,
      """
            elixir: "~> 1.11",
      """
    )

    project
  end
end
