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
    |> Addons.Makefile.apply()
    |> Addons.Docker.apply()
    |> Addons.TestEnv.apply()
    |> Addons.Credo.apply()
    |> Addons.Dialyxir.apply()
    |> Addons.ExCoveralls.apply()
    |> Addons.ExMachina.apply()
    |> Addons.Mox.apply()

    if host_on_github?() do
      if generate_github_template?(),
        do: Addons.Github.apply(project, %{github_template: true})

      if generate_github_action?(),
        do: Addons.Github.apply(project, %{github_action: true})
    end

    project
  end

  def variant_setup(%Project{api_project?: true} = project), do: ApiTemplate.apply(project)
  def variant_setup(%Project{api_project?: false} = project), do: WebTemplate.apply(project)

  defp host_on_github?(), do: Mix.shell().yes?("\nWill you host this project on Github?")

  def generate_github_template?(),
    do:
      Mix.shell().yes?(
        "\nDo you want to generate the .github/ISSUE_TEMPLATE and .github/PULL_REQUEST_TEMPLATE?"
      )

  def generate_github_action?(),
    do: Mix.shell().yes?("\nDo you want to generate the Github Action workflow?")
end
