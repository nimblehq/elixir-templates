defmodule Nimble.Phx.Gen.Template.Template do
  alias Nimble.Phx.Gen.Template.Api.Template, as: ApiTemplate
  alias Nimble.Phx.Gen.Template.Web.Template, as: WebTemplate
  alias Nimble.Phx.Gen.Template.{Addons, Project}

  def apply(%Project{} = project) do
    project
    |> common_setup()
    |> variant_setup()

    if Mix.shell().yes?("\nFetch and install dependencies?"), do: Mix.shell().cmd("mix deps.get")
  end

  # Common setup for both API and Web projects
  defp common_setup(%Project{} = project) do
    project
    |> Addons.ElixirVersion.apply()
    |> Addons.Makefile.apply()
    |> Addons.Docker.apply()
    |> Addons.MixRelease.apply()
    |> Addons.TestEnv.apply()
    |> Addons.Credo.apply()
    |> Addons.Dialyxir.apply()
    |> Addons.ExCoveralls.apply()
    |> Addons.ExMachina.apply()
    |> Addons.Mimic.apply()

    if host_on_github?() do
      if generate_github_template?(),
        do: Addons.Github.apply(project, %{github_template: true})

      if generate_github_action?(),
        do: Addons.Github.apply(project, %{github_action: true})
    end

    if install_addon_prompt?("Oban"), do: Addons.Oban.apply(project)

    project
  end

  defp variant_setup(%Project{api_project?: true} = project), do: ApiTemplate.apply(project)
  defp variant_setup(%Project{api_project?: false} = project), do: WebTemplate.apply(project)

  defp host_on_github?(), do: Mix.shell().yes?("\nWill you host this project on Github?")

  defp generate_github_template?(),
    do:
      Mix.shell().yes?(
        "\nDo you want to generate the .github/ISSUE_TEMPLATE and .github/PULL_REQUEST_TEMPLATE?"
      )

  defp generate_github_action?(),
    do: Mix.shell().yes?("\nDo you want to generate the Github Action workflow?")

  defp install_addon_prompt?(addon),
    do: Mix.shell().yes?("\nWould you like to add the #{addon} addon?")
end
