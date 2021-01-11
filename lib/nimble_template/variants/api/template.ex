defmodule NimbleTemplate.Api.Template do
  @moduledoc false

  alias NimbleTemplate.Project

  def apply(%Project{} = project) do
    project
  end
end
