defmodule NimbleTemplate.Addons.Faker do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    Generator.inject_mix_dependency!(
      {:faker, latest_package_version(:faker), only: [:dev, :test], runtime: false}
    )

    project
  end
end
