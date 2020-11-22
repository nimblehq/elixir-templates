defmodule Nimble.Phx.Gen.Template.Web.Template do
  alias Nimble.Phx.Gen.Template.Addons.Web
  alias Nimble.Phx.Gen.Template.Project
  alias Nimble.Phx.Gen.Template.Template, as: MainTemplate

  def apply(%Project{} = project) do
    project
    |> Web.Assets.apply()
    |> Web.Sobelow.apply()
    |> Web.Wallaby.apply()

    if MainTemplate.install_addon_prompt?("CoreJS"), do: Web.CoreJS.apply()

    project
  end
end
