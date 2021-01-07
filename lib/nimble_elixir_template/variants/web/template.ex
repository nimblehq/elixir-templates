defmodule Nimble.Elixir.Template.Web.Template do
  alias Nimble.Elixir.Template.Addons.Web
  alias Nimble.Elixir.Template.Project

  def apply(%Project{} = project) do
    project
    |> Web.Assets.apply()
    |> Web.CoreJS.apply()
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()

    project
  end
end
