defmodule Nimble.Template.Web.Template do
  alias Nimble.Template.Addons.Web
  alias Nimble.Template.Project

  def apply(%Project{} = project) do
    project
    |> Web.Assets.apply()
    |> Web.CoreJS.apply()
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()

    project
  end
end
