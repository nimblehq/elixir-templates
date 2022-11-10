defmodule NimbleTemplate.Templates.Mix.Template do
  @moduledoc false

  import NimbleTemplate.{AddonHelper, GithubHelper}

  alias NimbleTemplate.Addons
  alias NimbleTemplate.Projects.Project

  def apply!(%Project{} = project) do
    project
    |> apply_default_mix_addons()
    |> apply_optional_mix_addons()
  end

  defp apply_default_mix_addons(project) do
    project
    |> Addons.AsdfToolVersion.apply!()
    |> Addons.Readme.apply!()
    |> Addons.TestEnv.apply!()
    |> Addons.Credo.apply!()
    |> Addons.Dialyxir.apply!()
    |> Addons.ExCoveralls.apply!()
    |> Addons.Faker.apply!()
    |> Addons.Git.apply!()
    |> Addons.TestInteractive.apply!()
    |> Addons.Iex.apply!()
  end

  defp apply_optional_mix_addons(project) do
    if host_on_github?() do
      if generate_github_template?(),
        do: Addons.Github.apply!(project, %{github_template: true})

      generate_github_action_test? = generate_github_action_test?()

      if generate_github_action_test?,
        do: Addons.Github.apply!(project, %{github_action_test: true})

      generate_github_wiki? = generate_github_wiki?()

      if generate_github_wiki?,
        do: Addons.Github.apply!(project, %{github_wiki: true})

      if generate_github_workflows_readme?(),
        do:
          Addons.Github.apply!(project, %{
            github_workflows_readme: true,
            with_test_workflow?: generate_github_action_test?,
            with_github_wiki?: generate_github_wiki?,
            with_deploy_to_heroku_workflow?: false
          })
    end

    if install_addon_prompt?("Mimic"), do: Addons.Mimic.apply!(project)

    project
  end
end
