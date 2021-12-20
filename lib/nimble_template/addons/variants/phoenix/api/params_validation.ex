defmodule NimbleTemplate.Addons.Phoenix.Api.ParamsValidation do
  @moduledoc false

  use NimbleTemplate.Addon

  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
  end

  defp copy_files(
         %Project{web_module: web_module, base_module: base_module, web_test_path: web_test_path} =
           project
       ) do
    binding = [
      web_module: web_module,
      base_module: base_module
    ]

    files = [
      {:eex, "lib/otp_app_web/params/params.ex.eex", "#{web_module}/params/params.ex"},
      {:eex, "lib/otp_app_web/params/params_validator.ex.eex",
       "#{web_module}/params/params_validator.ex"},
      {:eex, "test/otp_app_web/params/params_validator_test.exs.eex",
       "test/#{web_test_path}/params/params_validator_test.exs"}
    ]

    Generator.copy_file(files, binding)

    project
  end
end
