defmodule Nimble.Phx.Gen.Template.Addons.Web.Wallaby do
  use Nimble.Phx.Gen.Template.Addon

  @versions %{
    wallaby: "~> 0.26.2",
    otp_version: "23.0.2",
    elixir_version: "1.10.4"
  }

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files
    |> edit_files
  end

  defp copy_files(%Project{} = project) do
    binding = [
      web_module: project.web_module,
      base_module: project.base_module
    ]

    files = [
      {:eex, "test/support/feature_case.ex.eex", "test/support/feature_case.ex"},
      {:eex, "test/features/home_page/view_home_page_test.exs.eex",
       "#{project.web_test_path}/features/home_page/view_home_page_test.exs"}
    ]

    Generator.copy_file(files, binding)

    if File.exists?(Path.join([".github", "workflows", "test.yml"])) do
      copy_github_action()
    end

    project
  end

  defp copy_github_action do
    binding = [
      otp_version: @versions.otp_version,
      elixir_version: @versions.elixir_version
    ]

    files = [
      {:eex, Path.join(["variants", "web", ".github", "workflows", "test.yml.eex"]),
       Path.join([".github", "workflows", "test.yml"])}
    ]

    Generator.copy_file(files, binding)
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency
    |> edit_mix
    |> edit_test_helper
    |> edit_endpoint
    |> edit_test_config
    |> edit_gitignore
    |> edit_assets_package

    project
  end

  defp inject_mix_dependency(%Project{} = project) do
    Generator.inject_mix_dependency({:wallaby, @versions.wallaby, only: :test, runtime: false})

    project
  end

  defp edit_mix(%Project{} = project) do
    Generator.inject_content(
      "mix.exs",
      """
        defp aliases do
          [
      """,
      """
            "assets.compile": &compile_assets/1,
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
        end
      end
      """,
      """
        end

        defp compile_assets(_) do
          Mix.shell().cmd("npm run --prefix assets build:dev", quiet: true)
        end
      end
      """
    )

    project
  end

  defp edit_test_helper(project) do
    Generator.replace_content(
      "test/test_helper.exs",
      """

      ExUnit.start()
      Ecto.Adapters.SQL.Sandbox.mode(#{project.base_module}.Repo, :manual)
      """,
      """
      {:ok, _} = Application.ensure_all_started(:wallaby)

      ExUnit.start()
      Ecto.Adapters.SQL.Sandbox.mode(#{project.base_module}.Repo, :manual)

      Application.put_env(:wallaby, :base_url, #{project.web_module}.Endpoint.url())
      """
    )

    project
  end

  def edit_endpoint(project) do
    Generator.replace_content(
      "lib/#{project.otp_app}_web/endpoint.ex",
      """
        use Phoenix.Endpoint, otp_app: :#{project.otp_app}
      """,
      """
        use Phoenix.Endpoint, otp_app: :#{project.otp_app}

        if Application.get_env(:#{project.otp_app}, :sql_sandbox) do
          plug Phoenix.Ecto.SQL.Sandbox
        end
      """
    )

    project
  end

  defp edit_test_config(project) do
    Generator.replace_content(
      "config/test.exs",
      """
        server: false
      """,
      """
        server: true

      config :#{project.otp_app}, :sql_sandbox, true

      config :wallaby,
        otp_app: :#{project.otp_app},
        chromedriver: [headless: System.get_env("CHROME_HEADLESS", "true") === "true"],
        screenshot_dir: "tmp/wallaby_screenshots",
        screenshot_on_failure: true
      """
    )

    project
  end

  defp edit_gitignore(project) do
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

  defp edit_assets_package(project) do
    Generator.replace_content(
      "assets/package.json",
      """
          "watch": "webpack --mode development --watch"
      """,
      """
          "watch": "webpack --mode development --watch",
          "build:dev": "webpack --mode development"
      """
    )

    project
  end
end
