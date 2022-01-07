defmodule NimbleTemplate.Templates.Phoenix.Api.Template do
  @moduledoc false

  alias NimbleTemplate.Addons.Phoenix.Api
  alias NimbleTemplate.Projects.Project

  def apply(%Project{} = project) do
    apply_default_api_addons(project)
  end

  defp apply_default_api_addons(project) do
    project
    |> Api.Config.apply()
    |> Api.ParamsValidation.apply()
    |> Api.ErrorView.apply()
  end
end
