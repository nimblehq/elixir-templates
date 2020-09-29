defmodule Nimble.Phx.Gen.Template.Template do
  alias Nimble.Phx.Gen.Template.{Project, Addons}
  alias Nimble.Phx.Gen.Template.Api.Template, as: ApiTemplate
  alias Nimble.Phx.Gen.Template.Web.Template, as: WebTemplate

  def apply(%Project{} = project) do
    common_setup(project)

    if Project.api?(project) do
      ApiTemplate.apply(project)
    else
      WebTemplate.apply(project)
    end

    if Mix.shell().yes?("\nFetch and install dependencies?"), do: Mix.shell().cmd("mix deps.get")
  end

  # Common setup for both API and Web projects
  defp common_setup(%Project{} = project) do
    project
    |> Addons.Makefile.apply()
    |> Addons.Docker.apply()

    if host_on_github?() do
      if Addons.Github.generate_github_template?(),
        do: Addons.Github.apply(project, %{github_template: true})

      if Addons.Github.generate_github_action?(),
        do: Addons.Github.apply(project, %{github_action: true})
    end

    project
    |> Addons.TestEnv.apply()
    |> Addons.Credo.apply()
    |> Addons.Dialyxir.apply()
    |> Addons.ExCoveralls.apply()
    |> Addons.ExMachina.apply()
    |> Addons.Mox.apply()
  end

  defp host_on_github?(), do: Mix.shell().yes?("\nWill you host this project on Github?")
end
