defmodule NimbleTemplate.Templates.Phoenix.Web.Template do
  @moduledoc false

  import NimbleTemplate.AddonHelper

  alias NimbleTemplate.Addons.Phoenix.Web
  alias NimbleTemplate.Projects.Project

  def apply(%Project{} = project) do
    project
    |> apply_default_web_addons()
    |> apply_optional_web_addons()
  end

  defp apply_default_web_addons(project) do
    project
    |> Web.Assets.apply()
    |> Web.CoreJS.apply()
    |> Web.Prettier.apply()
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()
    |> Web.EsLint.apply()
    |> Web.StyleLint.apply()
  end

  defp apply_optional_web_addons(project) do
    if install_addon_prompt?("SVG Sprite"), do: Web.SvgSprite.apply(project)
    if install_addon_prompt?("Nimble CSS"), do: Web.NimbleCSS.apply(project)
    if install_addon_prompt?("Nimble JS"), do: Web.NimbleJS.apply(project)

    project
  end
end
