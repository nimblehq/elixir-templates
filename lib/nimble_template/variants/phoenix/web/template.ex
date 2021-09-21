defmodule NimbleTemplate.Phoenix.Web.Template do
  @moduledoc false

  import NimbleTemplate.AddonHelper

  alias NimbleTemplate.Addons.Phoenix.Web
  alias NimbleTemplate.Project

  def apply(%Project{} = project) do
    if install_addon_prompt?("Style guide (KSS)"), do: Web.Kss.apply(project)

    project
    |> Web.Assets.apply()
    |> Web.CoreJS.apply()
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()

    project
  end
end
