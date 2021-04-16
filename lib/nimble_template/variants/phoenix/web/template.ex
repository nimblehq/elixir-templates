defmodule NimbleTemplate.Phoenix.Web.Template do
  @moduledoc false

  alias NimbleTemplate.Addons.Phoenix.Web
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
