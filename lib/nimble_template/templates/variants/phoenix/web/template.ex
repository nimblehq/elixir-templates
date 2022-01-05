defmodule NimbleTemplate.Templates.Phoenix.Web.Template do
  @moduledoc false

  import NimbleTemplate.AddonHelper

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

    if install_addon_prompt?("SVG Sprite"), do: Web.SvgSprite.apply(project)

    project
  end
end
