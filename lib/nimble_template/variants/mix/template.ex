defmodule NimbleTemplate.Mix.Template do
  @moduledoc false

  import NimbleTemplate.Template,
    only: [
      host_on_github?: 0,
      generate_github_template?: 0,
      generate_github_action?: 0,
      install_addon_prompt?: 1
    ]

  alias NimbleTemplate.{Addons, Project}

  def apply(%Project{} = project) do
    project
    |> Addons.ElixirVersion.apply()
    |> Addons.Readme.apply()
    |> Addons.TestEnv.apply()
    |> Addons.Credo.apply()
    |> Addons.Dialyxir.apply()
    |> Addons.ExCoveralls.apply()

    if host_on_github?() do
      if generate_github_template?(),
        do: Addons.Github.apply(project, %{github_template: true})

      if generate_github_action?(),
        do: Addons.Github.apply(project, %{github_action: true})
    end

    if install_addon_prompt?("Mimic"), do: Addons.Mimic.apply(project)

    project
  end
end
