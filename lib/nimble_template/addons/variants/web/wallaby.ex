defmodule Nimble.Template.Addons.Web.Wallaby do
  use Nimble.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
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
      {:eex, "test/support/feature_case.ex.eex", "test/support/feature_case.ex"},
      {:eex, "test/features/home_page/view_home_page_test.exs.eex",
       "#{web_test_path}/features/home_page/view_home_page_test.exs"}
    ]

    Generator.copy_file(files, binding)

    project
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency()
    |> edit_test_helper()
    |> edit_endpoint()
    |> edit_test_config()
    |> edit_gitignore()

    project
  end

  defp inject_mix_dependency(%Project{} = project) do
    Generator.inject_mix_dependency(
      {:wallaby, latest_package_version(:wallaby), only: :test, runtime: false}
    )

    project
  end

  defp edit_test_helper(%Project{base_module: base_module, web_module: web_module} = project) do
    Generator.replace_content(
      "test/test_helper.exs",
      """
      ExUnit.start()
      Ecto.Adapters.SQL.Sandbox.mode(#{base_module}.Repo, :manual)
      """,
      """
      {:ok, _} = Application.ensure_all_started(:wallaby)

      ExUnit.start()
      Ecto.Adapters.SQL.Sandbox.mode(#{base_module}.Repo, :manual)

      Application.put_env(:wallaby, :base_url, #{web_module}.Endpoint.url())
      """
    )

    project
  end

  def edit_endpoint(%Project{otp_app: otp_app} = project) do
    Generator.replace_content(
      "lib/#{otp_app}_web/endpoint.ex",
      """
        use Phoenix.Endpoint, otp_app: :#{otp_app}
      """,
      """
        use Phoenix.Endpoint, otp_app: :#{otp_app}

        if Application.get_env(:#{otp_app}, :sql_sandbox) do
          plug Phoenix.Ecto.SQL.Sandbox
        end
      """
    )

    project
  end

  defp edit_test_config(%Project{otp_app: otp_app} = project) do
    Generator.replace_content(
      "config/test.exs",
      """
        server: false
      """,
      """
        server: true

      config :#{otp_app}, :sql_sandbox, true

      config :wallaby,
        otp_app: :#{otp_app},
        chromedriver: [headless: System.get_env("CHROME_HEADLESS", "true") === "true"],
        screenshot_dir: "tmp/wallaby_screenshots",
        screenshot_on_failure: true
      """
    )

    project
  end

  defp edit_gitignore(%Project{} = project) do
    Generator.replace_content(
      ".gitignore",
      """
      /_build/
      """,
      """
      /_build/

      # tmp
      **/tmp/
      """
    )

    project
  end
end
