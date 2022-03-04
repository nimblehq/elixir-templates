defmodule NimbleTemplate.Addons.Phoenix.Gettext do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    edit_mix(project)
  end

  defp edit_mix(%Project{} = project) do
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
