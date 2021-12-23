defmodule NimbleTemplate.Addons.Gettext do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    edit_mix(project)
  end

  defp edit_mix(%Project{mix_project?: true} = project) do
    Generator.inject_content(
      "mix.exs",
      """
        defp aliases do
          [
      """,
      """
        "gettext.extract-and-merge": ["gettext.extract --merge --no-fuzzy"],
      """
    )

    project
  end
end
