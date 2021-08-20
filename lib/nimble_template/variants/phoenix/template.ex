defmodule NimbleTemplate.Phoenix.Template do
  @moduledoc false

  import NimbleTemplate.{AddonHelper, GithubHelper}

  alias NimbleTemplate.Phoenix.Api.Template, as: ApiTemplate
  alias NimbleTemplate.Phoenix.Live.Template, as: LiveTemplate
  alias NimbleTemplate.Phoenix.Web.Template, as: WebTemplate
  alias NimbleTemplate.{Addons, Project}

  def apply(%Project{} = project) do
    project
    |> common_setup()
    |> variant_setup()

    Addons.ExUnit.apply(project)

    project
  end

  defp common_setup(%Project{} = project) do
    project
    |> Addons.ElixirVersion.apply()
    |> Addons.Readme.apply()
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
    if install_addon_prompt?("ExVCR"), do: Addons.ExVCR.apply(project)

    project
  end

  defp variant_setup(%Project{api_project?: true} = project), do: ApiTemplate.apply(project)

  defp variant_setup(%Project{web_project?: true, live_project?: false} = project),
    do: WebTemplate.apply(project)

  defp variant_setup(%Project{web_project?: true, live_project?: true} = project),
    do: LiveTemplate.apply(project)
end
