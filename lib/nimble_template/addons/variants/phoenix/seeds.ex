defmodule NimbleTemplate.Addons.Phoenix.Seeds do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    edit_seeds_file(project)

    project
  end

  defp edit_seeds_file(project) do
    Generator.append_content("priv/repo/seeds.exs", """
    if Mix.env() == :dev || System.get_env("ENABLE_DB_SEED") == "true" do
    end
    """)

    project
  end
end
