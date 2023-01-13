defmodule NimbleTemplate.Addons.Phoenix.Gettext do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    edit_mix!(project)
  end

  defp edit_mix!(%Project{} = project) do
    Generator.replace_content!(
      "mix.exs",
      """
            codebase: [
      """,
      """
            codebase: [
              "gettext.extract --check-up-to-date",
      """
    )

    Generator.replace_content!(
      "mix.exs",
      """
            "codebase.fix": [
      """,
      """
            "codebase.fix": [
              "gettext.extract --merge --no-fuzzy",
      """
    )

    project
  end
end
