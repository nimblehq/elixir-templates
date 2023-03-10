defmodule NimbleTemplate.Templates.Phoenix.Web.Template do
  @moduledoc false

  alias NimbleTemplate.Addons.Phoenix.Web
  alias NimbleTemplate.Projects.Project

  def apply!(%Project{} = project) do
    project
    |> apply_default_web_addons()
    |> apply_optional_web_addons()
  end

  defp apply_default_web_addons(project) do
    project
    |> Web.NodePackage.apply!()
    |> Web.CoreComponents.apply!()
    |> Web.Assets.apply!()
    |> Web.CoreJS.apply!()
    |> Web.Prettier.apply!()
    |> Web.Sobelow.apply!()
    |> Web.Wallaby.apply!()
    |> Web.EsLint.apply!()
    |> Web.StyleLint.apply!()
    |> Web.EsBuild.apply!()
    |> Web.PostCSS.apply!()
  end

  defp apply_optional_web_addons(%Project{optional_addons: optional_addons} = project) do
    with_nimble_css_addon? = Web.NimbleCSS in optional_addons
    with_nimble_js_addon? = Web.NimbleJS in optional_addons

    if Web.SvgSprite in optional_addons, do: Web.SvgSprite.apply!(project)
    if Web.DartSass in optional_addons, do: Web.DartSass.apply!(project)
    if with_nimble_css_addon?, do: Web.NimbleCSS.apply!(project)
    if with_nimble_js_addon?, do: Web.NimbleJS.apply!(project)

    if Web.Bootstrap in optional_addons,
      do:
        Web.Bootstrap.apply!(project, %{
          with_nimble_css_addon: with_nimble_css_addon?,
          with_nimble_js_addon: with_nimble_js_addon?
        })

    project
  end
end
