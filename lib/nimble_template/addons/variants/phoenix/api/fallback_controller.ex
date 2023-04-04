defmodule NimbleTemplate.Addons.Phoenix.Api.FallbackController do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    project
    |> edit_files!()
    |> copy_files!()
  end

  defp copy_files!(%Project{web_module: web_module, web_path: web_path} = project) do
    binding = [
      web_module: web_module
    ]

    files = [
      {:eex, "lib/otp_app_web/controllers/api/fallback_controller.ex.eex",
       "#{web_path}/controllers/api/fallback_controller.ex"}
    ]

    Generator.copy_file!(files, binding)

    project
  end

  defp edit_files!(%Project{web_module: web_module, web_path: web_entry_point} = project) do
    Generator.replace_content!(
      "#{web_entry_point}.ex",
      """
        def controller do
          quote do
            use Phoenix.Controller,
              formats: [:html, :json],
              layouts: [html: #{web_module}.Layouts]

            import Plug.Conn
            import #{web_module}.Gettext

            alias #{web_module}.ParamsValidator
      """,
      """
        def controller do
          quote do
            use Phoenix.Controller,
              formats: [:html, :json],
              layouts: [html: #{web_module}.Layouts]

            import Plug.Conn
            import #{web_module}.Gettext

            alias #{web_module}.ParamsValidator

            action_fallback #{web_module}.Api.FallbackController
      """
    )

    project
  end
end
