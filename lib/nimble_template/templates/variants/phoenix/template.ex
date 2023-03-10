defmodule NimbleTemplate.Templates.Phoenix.Template do
  @moduledoc false

  import NimbleTemplate.{AddonHelper, GithubHelper}

  alias NimbleTemplate.Addons
  alias NimbleTemplate.Addons.Phoenix, as: PhoenixAddons
  alias NimbleTemplate.Addons.Phoenix.Web, as: WebAddons
  alias NimbleTemplate.Projects.Project
  alias NimbleTemplate.Templates.Phoenix.Api.Template, as: ApiTemplate
  alias NimbleTemplate.Templates.Phoenix.Live.Template, as: LiveTemplate
  alias NimbleTemplate.Templates.Phoenix.Web.Template, as: WebTemplate

  def pre_apply(%Project{} = project) do
    project
    |> install_addon_prompt(PhoenixAddons.Oban)
    |> install_addon_prompt(PhoenixAddons.ExVCR)
    |> pre_apply_variant_prompt()
  end

  def apply!(%Project{} = project) do
    project
    |> apply_phoenix_common_setup()
    |> apply_phoenix_variant_setup()
  end

  defp pre_apply_variant_prompt(%Project{web_project?: true} = project) do
    project
    |> install_addon_prompt(WebAddons.SvgSprite, "SVG Sprite")
    |> install_addon_prompt(WebAddons.DartSass, "Dart Sass")
    |> dart_sass_additional_addons_prompt()
    |> install_addon_prompt(WebAddons.NimbleJS, "Nimble JS")
  end

  defp pre_apply_variant_prompt(project), do: project

  defp dart_sass_additional_addons_prompt(%Project{optional_addons: optional_addons} = project) do
    if WebAddons.DartSass in optional_addons do
      project
      |> install_addon_prompt(WebAddons.NimbleCSS, "Nimble CSS")
      |> install_addon_prompt(WebAddons.Bootstrap)
    else
      project
    end
  end

  defp apply_phoenix_common_setup(%Project{} = project) do
    project
    |> apply_default_common_phoenix_addons()
    |> apply_optional_common_phoenix_addons()
  end

  defp apply_default_common_phoenix_addons(project) do
    project
    |> apply_default_common_addons()
    |> apply_default_phoenix_addons()
  end

  defp apply_default_common_addons(project) do
    project
    |> Addons.AsdfToolVersion.apply!()
    |> Addons.Readme.apply!()
    |> Addons.TestEnv.apply!()
    |> Addons.Credo.apply!()
    |> Addons.Dialyxir.apply!()
    |> Addons.ExCoveralls.apply!()
    |> Addons.Mimic.apply!()
    |> Addons.Faker.apply!()
    |> Addons.Git.apply!()
    |> Addons.TestInteractive.apply!()
    |> Addons.Iex.apply!()
  end

  defp apply_default_phoenix_addons(project) do
    project
    |> PhoenixAddons.ExMachina.apply!()
    |> PhoenixAddons.Makefile.apply!()
    |> PhoenixAddons.Docker.apply!()
    |> PhoenixAddons.EctoDataMigration.apply!()
    |> PhoenixAddons.MixRelease.apply!()
    |> PhoenixAddons.HealthPlug.apply!()
    |> PhoenixAddons.Gettext.apply!(project)
    |> PhoenixAddons.Seeds.apply!(project)
  end

  defp apply_optional_common_phoenix_addons(project) do
    project
    |> apply_optional_common_addons()
    |> apply_optional_phoenix_addons()
  end

  defp apply_optional_common_addons(project) do
    if host_on_github?(), do: github_addons_setup(project)

    project
  end

  defp apply_optional_phoenix_addons(%Project{optional_addons: optional_addons} = project) do
    if PhoenixAddons.Oban in optional_addons, do: PhoenixAddons.Oban.apply!(project)
    if PhoenixAddons.ExVCR in optional_addons, do: PhoenixAddons.ExVCR.apply!(project)

    project
  end

  defp github_addons_setup(%Project{} = project) do
    if generate_github_template?(),
      do: Addons.Github.apply!(project, %{github_template: true})

    generate_github_action_test? = generate_github_action_test?()

    if generate_github_action_test?,
      do: Addons.Github.apply!(project, %{github_action_test: true})

    generate_github_action_deploy_heroku? = generate_github_action_deploy_heroku?()

    if generate_github_action_deploy_heroku?,
      do: Addons.Github.apply!(project, %{github_action_deploy_heroku: true})

    generate_github_wiki? = generate_github_wiki?()

    if generate_github_workflows_readme?(),
      do:
        Addons.Github.apply!(project, %{
          github_workflows_readme: true,
          with_test_workflow?: generate_github_action_test?,
          with_github_wiki?: generate_github_wiki?,
          with_deploy_to_heroku_workflow?: generate_github_action_deploy_heroku?
        })

    if generate_github_wiki?,
      do: Addons.Github.apply!(project, %{github_wiki: true})
  end

  defp apply_phoenix_variant_setup(%Project{api_project?: true} = project),
    do: ApiTemplate.apply!(project)

  defp apply_phoenix_variant_setup(%Project{web_project?: true, live_project?: false} = project),
    do: WebTemplate.apply!(project)

  defp apply_phoenix_variant_setup(%Project{web_project?: true, live_project?: true} = project),
    do: LiveTemplate.apply!(project)
end
