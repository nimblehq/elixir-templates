defmodule NimbleTemplate.Templates.Phoenix.Live.Template do
  @moduledoc false

  alias NimbleTemplate.Projects.Project
  alias NimbleTemplate.Templates.Phoenix.Web.Template, as: WebTemplate

  def apply(%Project{} = project) do
    apply_web_addons(project)
  end

  defp apply_web_addons(project) do
    WebTemplate.apply(project)
  end
end
