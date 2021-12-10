defmodule NimbleTemplate.Phoenix.Api.Template do
  @moduledoc false

  alias NimbleTemplate.Addons.Phoenix.Api
  alias NimbleTemplate.Project

  def apply(%Project{} = project) do
    Api.Config.apply(project)

    project
  end
end
