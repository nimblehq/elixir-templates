defmodule NimbleTemplate.Web.Template do
  alias NimbleTemplate.Addons.Web
  alias NimbleTemplate.Project

  def apply(%Project{} = project) do
    project
    |> Web.Assets.apply()
    |> Web.CoreJS.apply()
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()

    project
  end
end
