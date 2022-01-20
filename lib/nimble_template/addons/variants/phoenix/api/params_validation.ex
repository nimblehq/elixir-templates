defmodule NimbleTemplate.Addons.Phoenix.Api.ParamsValidation do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp edit_files(project) do
    edit_web_entrypoint(project)
  end

  defp edit_web_entrypoint(%Project{web_module: web_module, web_path: web_entrypoint} = project) do
    Generator.replace_content(
      "#{web_entrypoint}.ex",
      """
        def controller do
          quote do
            use Phoenix.Controller, namespace: #{web_module}

            import Plug.Conn
            import #{web_module}.Gettext
            alias #{web_module}.Router.Helpers, as: Routes
      """,
      """
        def controller do
          quote do
            use Phoenix.Controller, namespace: #{web_module}

            import Plug.Conn
            import #{web_module}.Gettext

            alias #{web_module}.ParamsValidator
            alias #{web_module}.Router.Helpers, as: Routes
      """
    )

    project
  end

  defp copy_files(
         %Project{
           base_module: base_module,
           web_module: web_module,
           web_path: web_path,
           web_test_path: web_test_path
         } = project
       ) do
    binding = [
      web_module: web_module,
      base_module: base_module
    ]

    files = [
      {:eex, "lib/otp_app_web/params/params.ex.eex", "#{web_path}/params/params.ex"},
      {:eex, "lib/otp_app_web/params/params_validator.ex.eex",
       "#{web_path}/params/params_validator.ex"},
      {:eex, "test/otp_app_web/params/params_validator_test.exs.eex",
       "#{web_test_path}/params/params_validator_test.exs"}
    ]

    Generator.copy_file(files, binding)

    project
  end
end
