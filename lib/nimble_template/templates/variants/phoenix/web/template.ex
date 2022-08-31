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

  defp apply_optional_web_addons(project) do
    if install_addon_prompt?("SVG Sprite"), do: Web.SvgSprite.apply(project)

    if install_addon_prompt?("Dart Sass") do
      Web.DartSass.apply(project)

      apply_dart_sass_requires_addons(project)
    else
      if install_addon_prompt?("Nimble JS"), do: Web.NimbleJS.apply(project)
    end

    project
  end

  # These addons depend on the DartSass
  defp apply_dart_sass_requires_addons(project) do
    with_nimble_css_addon =
      if install_addon_prompt?("Nimble CSS") do
        Web.NimbleCSS.apply(project)

        true
      else
        false
      end

    with_nimble_js_addon =
      if install_addon_prompt?("Nimble JS") do
        Web.NimbleJS.apply(project)

        true
      else
        false
      end

    if install_addon_prompt?("Bootstrap"),
      do:
        Web.Bootstrap.apply(project, %{
          with_nimble_css_addon: with_nimble_css_addon,
          with_nimble_js_addon: with_nimble_js_addon
        })
  end
end
