defmodule NimbleTemplate.Addons.Phoenix.HealthPlug do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(
         %Project{
           web_module: web_module,
           base_module: base_module,
           web_path: web_path,
           web_test_path: web_test_path,
           otp_app: otp_app
         } = project
       ) do
    binding = [
      web_module: web_module,
      base_module: base_module,
      otp_app: otp_app
    ]

    files = [
      {:eex, "lib/otp_app_web/plugs/health_plug.ex.eex", "#{web_path}/plugs/health_plug.ex"},
      {:eex, "test/otp_app_web/plugs/health_plug_test.exs.eex",
       "#{web_test_path}/plugs/health_plug_test.exs"},
      {:eex, "test/otp_app_web/requests/_health/liveness_request_test.exs.eex",
       "#{web_test_path}/requests/_health/liveness_request_test.exs"},
      {:eex, "test/otp_app_web/requests/_health/readiness_request_test.exs.eex",
       "#{web_test_path}/requests/_health/readiness_request_test.exs"}
    ]

    Generator.copy_file(files, binding)

    project
  end

  defp edit_files(project) do
    project
    |> edit_config()
    |> edit_router()
    |> edit_test_helper()
  end

  defp edit_config(%Project{web_module: web_module, otp_app: otp_app} = project) do
    Generator.replace_content(
      "config/config.exs",
      """
      config :#{otp_app}, #{web_module}.Endpoint,
      """,
      """
      config :#{otp_app}, #{web_module}.Endpoint,
        health_path: "/_health",
      """
    )

    Generator.replace_content(
      "config/runtime.exs",
      """
        config :#{otp_app}, #{web_module}.Endpoint,
      """,
      """
        config :#{otp_app}, #{web_module}.Endpoint,
          health_path: System.fetch_env!("HEALTH_PATH"),
      """
    )

    project
  end

  defp edit_router(%Project{web_path: web_path, web_module: web_module, otp_app: otp_app} = project) do
    Generator.replace_content(
      "#{web_path}/router.ex",
      """
        # coveralls-ignore-start
        pipeline :api do
          plug :accepts, ["json"]
        end

        # coveralls-ignore-stop
      """,
      """
        # coveralls-ignore-start
        pipeline :api do
          plug :accepts, ["json"]
        end

        # coveralls-ignore-stop

        forward Application.get_env(:#{otp_app}, #{web_module}.Endpoint)[:health_path], #{web_module}.HealthPlug
      """
    )

    project
  end

  defp edit_test_helper(project) do
    Generator.replace_content(
      "test/test_helper.exs",
      """
      ExUnit.start()
      """,
      """
      Mimic.copy(Ecto.Adapters.SQL)

      ExUnit.start()
      """
    )

    project
  end
end
