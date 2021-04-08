defmodule NimbleTemplate.Phoenix.Live.Template do
  @moduledoc false

  alias NimbleTemplate.Project
  alias NimbleTemplate.Phoenix.Web.Template, as: WebTemplate

  def apply(%Project{} = project) do
    WebTemplate.apply(project)

    project
  end
end
