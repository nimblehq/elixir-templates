defmodule Nimble.Elixir.Template.Live.Template do
  alias Nimble.Elixir.Template.Project
  alias Nimble.Elixir.Template.Web.Template, as: WebTemplate

  def apply(%Project{} = project) do
    WebTemplate.apply(project)

    project
  end
end
