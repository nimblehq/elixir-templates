defmodule Nimble.Template.Addons.Dialyxir do
  use Nimble.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    Generator.inject_mix_dependency(
      {:dialyxir, latest_package_version(:dialyxir), only: [:dev], runtime: false}
    )

    project
  end
end
