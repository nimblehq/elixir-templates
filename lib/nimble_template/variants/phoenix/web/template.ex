defmodule NimbleTemplate.Phoenix.Web.Template do
  @moduledoc false

  alias NimbleTemplate.Addons.Phoenix.Web
  alias NimbleTemplate.Project

  def apply(%Project{} = project) do
    project
    |> Web.Assets.apply()
    |> Web.CoreJS.apply()
    |> Web.Prettier.apply()
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()
    |> Web.EsLint.apply()
    |> Web.StyleLint.apply()

    project
  end
end
