defmodule NimbleTemplate.Addons.TestInteractive do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    latest_version = latest_package_version(:mix_test_interactive)

    Generator.inject_mix_dependency!(
      {:mix_test_interactive, latest_version, only: :dev, runtime: false}
    )

    add_dev_config!(project)
  end

  defp add_dev_config!(%Project{mix_project?: true} = project), do: project

  defp add_dev_config!(project) do
    Generator.append_content!(
      "config/dev.exs",
      """
      config :mix_test_interactive,
        clear: true
      """
    )

    project
  end
end
