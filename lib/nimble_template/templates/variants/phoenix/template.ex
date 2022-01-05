defmodule NimbleTemplate.Templates.Phoenix.Template do
  @moduledoc false

  import NimbleTemplate.{AddonHelper, GithubHelper}

  alias NimbleTemplate.Templates.Phoenix.Api.Template, as: ApiTemplate
  alias NimbleTemplate.Templates.Phoenix.Live.Template, as: LiveTemplate
  alias NimbleTemplate.Templates.Phoenix.Web.Template, as: WebTemplate
  alias NimbleTemplate.{Addons, Project}

  def apply(%Project{} = project) do
    project
    |> common_setup()
    |> variant_setup()

    Addons.ExUnit.apply(project)

    project
  end

  # credo:disable-for-next-line Credo.Check.Refactor.ABCSize
  defp common_setup(%Project{} = project) do
    project
    |> Addons.ElixirVersion.apply()
    |> Addons.Readme.apply()
    |> Addons.Makefile.apply()
    |> Addons.Docker.apply()
    |> Addons.EctoDataMigration.apply()
    |> Addons.MixRelease.apply()
    |> Addons.TestEnv.apply()
    |> Addons.Credo.apply()
    |> Addons.Dialyxir.apply()
    |> Addons.ExCoveralls.apply()
    |> Addons.ExMachina.apply()
    |> Addons.Mimic.apply()
    |> Addons.Faker.apply()

    if host_on_github?(), do: github_addons_setup(project)
    if install_addon_prompt?("Oban"), do: Addons.Oban.apply(project)
    if install_addon_prompt?("ExVCR"), do: Addons.ExVCR.apply(project)

    project
  end

  defp github_addons_setup(%Project{} = project) do
    if generate_github_template?(),
      do: Addons.Github.apply(project, %{github_template: true})

    generate_github_action_test? = generate_github_action_test?()

    if generate_github_action_test?,
      do: Addons.Github.apply(project, %{github_action_test: true})

    generate_github_action_deploy_heroku? = generate_github_action_deploy_heroku?()

    if generate_github_action_deploy_heroku?,
      do: Addons.Github.apply(project, %{github_action_deploy_heroku: true})

    if generate_github_workflows_readme?(),
      do:
        Addons.Github.apply(project, %{
          github_workflows_readme: true,
          with_test_workflow?: generate_github_action_test?,
          with_deploy_to_heroku_workflow?: generate_github_action_deploy_heroku?
        })

    if generate_github_wiki?(),
      do: Addons.Github.apply(project, %{github_wiki: true})
  end

  defp variant_setup(%Project{api_project?: true} = project), do: ApiTemplate.apply(project)

  defp variant_setup(%Project{web_project?: true, live_project?: false} = project),
    do: WebTemplate.apply(project)

  defp variant_setup(%Project{web_project?: true, live_project?: true} = project),
    do: LiveTemplate.apply(project)
end
