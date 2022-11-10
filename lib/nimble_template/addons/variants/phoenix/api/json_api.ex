defmodule NimbleTemplate.Addons.Phoenix.Api.JsonApi do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    edit_files!(project)
  end

  def inject_mix_dependency!(project) do
    Generator.inject_mix_dependency!({:jsonapi, latest_package_version(:jsonapi)})

    project
  end

  def edit_config!(project) do
    Generator.replace_content!(
      "config/config.exs",
      """
      # Import environment specific config. This must remain at the bottom
      # of this file so it overrides the configuration defined above.
      """,
      """
      config :jsonapi, remove_links: true

      # Import environment specific config. This must remain at the bottom
      # of this file so it overrides the configuration defined above.
      """
    )

    project
  end

  defp edit_files!(%Project{} = project) do
    project
    |> inject_mix_dependency!()
    |> edit_config!()
  end
end
