defmodule Nimble.Phx.Gen.Template.Web.Template do
  import Nimble.Phx.Gen.Template.Template, only: [install_addon_prompt?: 1]

  alias Nimble.Phx.Gen.Template.Addons.Web
  alias Nimble.Phx.Gen.Template.Project

  def apply(%Project{} = project) do
    project
    |> Web.Assets.apply()
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()

    if install_addon_prompt?("CoreJS"), do: Web.CoreJS.apply(project)

    project
  end
end
