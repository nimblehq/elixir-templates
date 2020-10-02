defmodule Nimble.Phx.Gen.Template.Addons.ExCoveralls do
  use Nimble.Phx.Gen.Template.Addon

  @versions %{
    excoveralls: "~> 0.12.2"
  }

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(%Project{otp_app: otp_app} = project) do
    binding = [
      otp_app: otp_app,
      minimum_coverage: 100
    ]

    Generator.copy_file([{:eex, "coveralls.json.eex", "coveralls.json"}], binding)

    project
  end

  defp edit_files(%Project{} = project) do
    project
<<<<<<< HEAD
    |> inject_mix_dependency()
    |> edit_mix()
    |> edit_web_router()
=======
    |> inject_mix_dependency
    |> edit_mix
    |> edit_web_router
>>>>>>> ignore coverall on web router
  end

  defp inject_mix_dependency(project) do
    Generator.inject_mix_dependency({:excoveralls, @versions.excoveralls, only: :test})

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

<<<<<<< HEAD
  defp edit_web_router(%Project{} = project) do
=======
  defp edit_web_router(%Project{api_project?: true} = project),
    do: ignore_ex_coverall_on_api_pipeline(project)

  defp edit_web_router(%Project{api_project?: false} = project) do
>>>>>>> ignore coverall on web router
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
