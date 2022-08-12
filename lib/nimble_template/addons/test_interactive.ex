defmodule NimbleTemplate.Addons.TestInteractive do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    Generator.inject_mix_dependency({:mix_test_interactive, "~> 1.2", only: :dev, runtime: false})

    add_dev_config(project)
  end

  defp add_dev_config(project) do
    Generator.inject_content(
      "config/dev.exs",
      """
      config :phoenix, :plug_init_mode, :runtime
      """,
      """

      config :mix_test_interactive,
        clear: true
      """
    )

    project
  end
end
