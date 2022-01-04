defmodule NimbleTemplate.Addons.Phoenix.Api.ErrorView do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> delete_files()
    |> copy_files()
    |> remove_page_route()
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
      {:eex, "test/otp_app_web/views/error_helpers_test.exs",
       "#{web_test_path}/views/error_helpers_test.exs"},
      {:eex, "test/otp_app_web/views/error_view_test.exs",
       "#{web_test_path}/views/error_view_test.exs"},
      {:eex, "test/support/view_case.ex.eex", "test/support/view_case.ex"}
    ]

    Generator.copy_file(files, binding)

    project
  end

  defp delete_files(%Project{web_test_path: web_test_path, web_path: web_path} = project) do
    files_to_delete = [
      "#{web_path}/controllers/page_controller.ex",
      "#{web_path}/views/error_view.ex",
      "#{web_path}/views/error_helpers.ex",
      "#{web_path}/views/layout_view.ex",
      "#{web_path}/views/page_view.ex",
      "#{web_test_path}/controllers/page_controller_test.exs",
      "#{web_test_path}/views/error_view_test.exs"
    ]

    Enum.each(files_to_delete, fn path ->
      if File.exists?(path), do: File.rm!(path)
    end)

    project
  end

  defp remove_page_route(%Project{web_path: web_path} = project) do
    Generator.delete_content(
      "#{web_path}/router.ex",
      """
          get "/", PageController, :index
      """
    )

    Generator.delete_content(
      "#{web_path}/router.ex",
      """
        pipeline :browser do
          plug :accepts, ["html"]
          plug :fetch_session
          plug :fetch_flash
          plug :protect_from_forgery
          plug :put_secure_browser_headers
        end
      """
    )

    Generator.replace_content(
      "#{web_path}/router.ex",
      """
            pipe_through :browser
      """,
      """
            pipe_through [:fetch_session, :protect_from_forgery]
      """
    )

    project
  end
end
