defmodule Nimble.Phx.Gen.Template.Web.Template do
  alias Nimble.Phx.Gen.Template.Project
  alias Nimble.Phx.Gen.Template.Addons.Web

  def apply(%Project{} = project) do
    project
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()

    project
  end
end
