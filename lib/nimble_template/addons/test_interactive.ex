defmodule NimbleTemplate.Addons.TestInteractive do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    Generator.inject_mix_dependency(
      {:mix_test_interactive, "~> 1.0", only: :dev, runtime: false}
    )

    project
  end
end
