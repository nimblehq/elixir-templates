defmodule NimbleTemplate.Mix.Template do
  @moduledoc false

  import NimbleTemplate.{AddonHelper, GithubHelper}

  alias NimbleTemplate.{Addons, Project}

  def apply(%Project{} = project) do
    project
    |> Addons.ElixirVersion.apply()
    |> Addons.Readme.apply()
    |> Addons.TestEnv.apply()
    |> Addons.Credo.apply()
    |> Addons.Dialyxir.apply()
    |> Addons.ExCoveralls.apply()
    |> Addons.Faker.apply()

    if host_on_github?() do
      if generate_github_template?(),
        do: Addons.Github.apply(project, %{github_template: true})

      if generate_github_action?(),
        do: Addons.Github.apply(project, %{github_action: true})

      if generate_github_wiki?(),
        do: Addons.Github.apply(project, %{github_wiki: true})
    end

    if install_addon_prompt?("Mimic"), do: Addons.Mimic.apply(project)

    Addons.ExUnit.apply(project)

    project
  end
end
