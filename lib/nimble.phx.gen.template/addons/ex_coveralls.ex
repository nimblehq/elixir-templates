defmodule Nimble.Phx.Gen.Template.Addons.ExCoveralls do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(%Project{otp_app: otp_app, mix_project?: mix_project?} = project) do
    binding = [
      otp_app: otp_app,
      minimum_coverage: 100
    ]

    template_file_path =
      if mix_project? do
        "coveralls.json.mix.eex"
      else
        "coveralls.json.eex"
      end

    Generator.copy_file([{:eex, template_file_path, "coveralls.json"}], binding)

    project
  end

  defp edit_files(%Project{mix_project?: true} = project) do
    project
    |> inject_mix_dependency()
    |> edit_mix()

    project
  end

  defp edit_files(%Project{live_project?: live_project?} = project) do
    project
    |> inject_mix_dependency()
    |> edit_mix()
    |> edit_web_router()

    if live_project?, do: edit_page_live(project)

    project
  end

  defp inject_mix_dependency(project) do
    Generator.inject_mix_dependency(
      {:excoveralls, latest_package_version(:excoveralls), only: :test}
    )

    project
  end

  defp edit_mix(project) do
    Generator.replace_content(
      "mix.exs",
      """
            deps: deps()
      """,
      """
            deps: deps(),
            test_coverage: [tool: ExCoveralls],
            preferred_cli_env: [
              lint: :test,
              coverage: :test,
              coveralls: :test,
              "coveralls.html": :test
            ]
      """
    )

    Generator.inject_content(
      "mix.exs",
      """
        defp aliases do
          [
      """,
      """
            coverage: ["coveralls.html --raise"],
      """
    )

    project
  end

  defp edit_page_live(%Project{web_path: web_path, web_module: web_module} = project) do
    Generator.replace_content(
      "#{web_path}/live/page_live.ex",
      """
      defmodule #{web_module}.PageLive do
      """,
      """
      # coveralls-ignore-start
      defmodule #{web_module}.PageLive do
      """
    )

    project
  end

  defp edit_web_router(%Project{} = project) do
    project
    |> ignore_ex_coverall_on_api_pipeline()
    |> ignore_ex_coverall_on_live_dashboard()
  end

  defp ignore_ex_coverall_on_api_pipeline(%Project{web_path: web_path} = project) do
    Generator.replace_content(
      "#{web_path}/router.ex",
      """
        pipeline :api do
          plug :accepts, ["json"]
        end
      """,
      """
        # coveralls-ignore-start
        pipeline :api do
          plug :accepts, ["json"]
        end

        # coveralls-ignore-stop
      """
    )

    project
  end

  defp ignore_ex_coverall_on_live_dashboard(
         %Project{web_path: web_path, web_module: web_module} = project
       ) do
    Generator.replace_content(
      "#{web_path}/router.ex",
      """
            live_dashboard "/dashboard", metrics: #{web_module}.Telemetry
      """,
      """
            # coveralls-ignore-start
            live_dashboard "/dashboard", metrics: #{web_module}.Telemetry
            # coveralls-ignore-stop
      """
    )

    project
  end
end
