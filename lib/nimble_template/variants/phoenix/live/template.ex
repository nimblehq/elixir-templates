defmodule NimbleTemplate.Phoenix.Live.Template do
  @moduledoc false

  alias NimbleTemplate.Phoenix.Web.Template, as: WebTemplate
  alias NimbleTemplate.Project

  def apply(%Project{} = project) do
    WebTemplate.apply(project)

    project
  end
end
