defmodule Nimble.Template.Live.Template do
  alias Nimble.Template.Project
  alias Nimble.Template.Web.Template, as: WebTemplate

  def apply(%Project{} = project) do
    WebTemplate.apply(project)

    project
  end
end
