defmodule NimbleTemplate.Addons.Phoenix.Api.Config do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    edit_files(project)
  end

  defp edit_files(%Project{} = project) do
    edit_config_prod(project)

    project
  end

  def edit_config_prod(%Project{otp_app: otp_app, web_module: web_module} = project) do
    Generator.replace_content(
      "config/prod.exs",
      """
      config :#{otp_app}, #{web_module}.Endpoint,
      """,
      """
      config :#{otp_app}, #{web_module}.Endpoint.Anchor
      """
    )

    Generator.delete_content(
      "config/prod.exs",
      "config :#{otp_app}, #{web_module}.Endpoint.Anchor"
    )

    Generator.delete_content(
      "config/prod.exs",
      "cache_static_manifest: \"priv/static/cache_manifest.json\""
    )

    project
  end
end
