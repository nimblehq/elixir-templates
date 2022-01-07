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
        "gettext.check": [
          "gettext.extract-and-merge",
          ~S/cmd [ -z \"$(git diff --exit-code priv\/gettext)\" ] || echo "The localization files POs, POTs are NOT up-to-date."/
        ],
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
            "codebase.fix": [
      """,
      """
            "codebase.fix": [
              "gettext.extract-and-merge",
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
        codebase: [
      """,
      """
        codebase: [
          "gettext.check",
      """
    )

    project
  end
end
