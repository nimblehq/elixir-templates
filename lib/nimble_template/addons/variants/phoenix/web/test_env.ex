defmodule NimbleTemplate.Addons.Phoenix.Web.TestEnv do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    edit_mix(project)
  end

  defp edit_mix(project) do
    Generator.replace_content(
      "mix.exs",
      """
            "codebase.fix": ["deps.clean --unlock --unused", "format"],
      """,
      """
            "codebase.fix": [
              "deps.clean --unlock --unused",
              "format",
              "cmd npm run eslint.fix --prefix assets",
              "cmd npm run stylelint.fix --prefix assets"
            ],
      """
    )

    project
  end
end
