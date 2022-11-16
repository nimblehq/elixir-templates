defmodule NimbleTemplate.Templates.Phoenix.Web.Template do
  @moduledoc false

  import NimbleTemplate.AddonHelper

  alias NimbleTemplate.Addons.Phoenix.Web
  alias NimbleTemplate.Projects.Project

  def pre_apply(%Project{} = project) do
    project
    |> install_addon_prompt(Web.SvgSprite, "SVG Sprite")
    |> install_addon_prompt(Web.DartSass, "Dart Sass")
    |> dart_sass_additional_addons_prompt()
    |> install_addon_prompt(Web.NimbleJS, "Nimble JS")
  end

  def apply(%Project{} = project) do
    project
    |> apply_default_web_addons()
    |> apply_optional_web_addons()
  end

  defp dart_sass_additional_addons_prompt(%Project{addons: addons} = project) do
    if Web.DartSass in addons do
      project
      |> install_addon_prompt(Web.NimbleCSS, "Nimble CSS")
      |> install_addon_prompt(Web.Bootstrap)
    else
      project
    end
  end

  defp apply_default_web_addons(project) do
    project
    |> Web.NodePackage.apply()
    |> Web.Assets.apply()
    |> Web.CoreJS.apply()
    |> Web.Prettier.apply()
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()
    |> Web.EsLint.apply()
    |> Web.StyleLint.apply()
    |> Web.EsBuild.apply()
    |> Web.PostCSS.apply()
    |> Web.HeexFormatter.apply()
  end

  defp apply_optional_web_addons(%Project{addons: addons} = project) do
    with_nimble_css_addon? = Web.NimbleCSS in addons
    with_nimble_js_addon? = Web.NimbleJS in addons

    if Web.SvgSprite in addons, do: Web.SvgSprite.apply(project)
    if Web.DartSass in addons, do: Web.DartSass.apply(project)
    if with_nimble_css_addon?, do: Web.NimbleCSS.apply(project)
    if with_nimble_js_addon?, do: Web.NimbleJS.apply(project)

    if Web.Bootstrap in addons,
      do:
        Web.Bootstrap.apply(project, %{
          with_nimble_css_addon: with_nimble_css_addon?,
          with_nimble_js_addon: with_nimble_js_addon?
        })

    project
  end
end
