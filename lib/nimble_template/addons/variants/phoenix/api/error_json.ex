defmodule NimbleTemplate.Addons.Phoenix.Api.ErrorJSON do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    project
    |> delete_files!()
    |> copy_files!()
  end

  defp delete_files!(%Project{web_path: web_path, web_test_path: web_test_path} = project) do
    File.rm!("#{web_path}/controllers/error_json.ex")
    File.rm!("#{web_test_path}/controllers/error_json_test.exs")

    project
  end

  defp copy_files!(
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
      {:eex, "lib/otp_app_web/controllers/error_json.ex.eex",
       "#{web_path}/controllers/error_json.ex"},
      {:eex, "test/otp_app_web/controllers/error_json_test.exs.eex",
       "#{web_test_path}/controllers/error_json_test.exs"}
    ]

    Generator.copy_file!(files, binding)

    project
  end
end
