defmodule NimbleTemplate.Addons.Phoenix.Api.EmptyBodyParamsPlug do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    project
    |> copy_files!()
    |> edit_files!()
  end

  defp copy_files!(
         %Project{
           web_module: web_module,
           web_path: web_path,
           web_test_path: web_test_path
         } = project
       ) do
    binding = [
      web_module: web_module
    ]

    # files = [
    #   {:eex, "lib/otp_app_web/plugs/check_empty_body_params_plug.ex.eex",
    #    "#{web_path}/plugs/check_empty_body_params_plug.ex"},
    #   {:eex, "test/otp_app_web/plugs/check_empty_body_params_plug_test.exs.eex",
    #    "#{web_test_path}/plugs/check_empty_body_params_plug_test.exs"}
    # ]
    # TODO: Update the test with new ErrorView
    files = [
      {:eex, "lib/otp_app_web/plugs/check_empty_body_params_plug.ex.eex",
       "#{web_path}/plugs/check_empty_body_params_plug.ex"}
    ]

    Generator.copy_file!(files, binding)

    project
  end

  defp edit_files!(%Project{web_path: web_path, web_module: web_module} = project) do
    Generator.replace_content!(
      "#{web_path}/router.ex",
      """
        pipeline :api do
          plug :accepts, ["json"]
        end
      """,
      """
        pipeline :api do
          plug :accepts, ["json"]
          plug #{web_module}.CheckEmptyBodyParamsPlug
        end
      """
    )

    project
  end
end
