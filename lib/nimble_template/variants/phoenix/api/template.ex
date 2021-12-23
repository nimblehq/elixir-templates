defmodule NimbleTemplate.Phoenix.Api.Template do
  @moduledoc false

  alias NimbleTemplate.Addons.Phoenix.Api
  alias NimbleTemplate.Project

  def apply(%Project{} = project) do
    project
    |> Api.Config.apply()
    |> Api.ParamsValidation.apply()
  end
end
