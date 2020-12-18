defmodule Nimble.Phx.Gen.Template.Live.Template do
  alias Nimble.Phx.Gen.Template.Project
  alias Nimble.Phx.Gen.Template.Web.Template, as: WebTemplate

  def apply(%Project{} = project) do
    WebTemplate.apply(project)

    project
  end
end
