defmodule NimbleTemplate.Addons.Phoenix.Api.Config do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    edit_files!(project)
  end

  def edit_config_prod!(%Project{} = project) do
    Generator.delete_content!(
      "config/prod.exs",
      """
      # For production, don't forget to configure the url host
      # to something meaningful, Phoenix uses this information
      # when generating URLs.
      """
    )

    project
  end

  defp edit_files!(%Project{} = project) do
    edit_config_prod!(project)

    project
  end
end
