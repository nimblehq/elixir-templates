defmodule Nimble.Phx.Gen.Template.Web.Template do
  alias Nimble.Phx.Gen.Template.Addons.Web
  alias Nimble.Phx.Gen.Template.Project

  def apply(%Project{} = project) do
    project
    |> Web.Assets.apply()
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()

    project
  end
end
