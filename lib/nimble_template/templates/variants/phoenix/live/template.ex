defmodule NimbleTemplate.Templates.Phoenix.Live.Template do
  @moduledoc false

  alias NimbleTemplate.Templates.Phoenix.Web.Template, as: WebTemplate
  alias NimbleTemplate.Project

  def apply(%Project{} = project) do
    WebTemplate.apply(project)

    project
  end
end
