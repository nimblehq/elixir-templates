defmodule NimbleTemplate.Addons.Phoenix.Api.ErrorView do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> delete_files()
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
      {:eex, "lib/otp_app_web/views/error_helpers.ex", "#{web_path}/views/error_helpers.ex"},
      {:eex, "lib/otp_app_web/views/error_view.ex", "#{web_path}/views/error_view.ex"},
      {:eex, "test/otp_app_web/views/error_helpers_test.exs", "#{web_test_path}/views/error_helpers_test.exs"},
      {:eex, "test/otp_app_web/views/error_view_test.exs", "#{web_test_path}/views/error_view_test.exs"},
      {:eex, "test/support/view_case.ex.eex", "test/support/view_case.ex"}
    ]

    Generator.copy_file(files, binding)

    project
  end

  defp delete_files(%Project{ web_test_path: web_test_path, web_path: web_path } = project) do
    File.rm("#{web_path}/views/layout_view.ex")
    File.rm("#{web_path}/views/page_view.ex")
    File.rm("#{web_test_path}/views/layout_view_test.exs")
    File.rm("#{web_test_path}/views/page_view_test.exs")
    File.rm("#{web_test_path}/controllers/page_controller_test.exs")

    project
  end
end
