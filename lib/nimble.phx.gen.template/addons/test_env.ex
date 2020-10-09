defmodule Nimble.Phx.Gen.Template.Addons.TestEnv do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> edit_mix()
    |> edit_test_config()
    |> edit_test_support_cases()
  end

  defp edit_mix(project) do
    Generator.inject_content(
      "mix.exs",
      """
        defp aliases do
          [
      """,
      """
            codebase: ["format --check-formatted"],
      """
    )

    project
  end

  defp edit_test_config(project) do
    Generator.replace_content(
      "config/test.exs",
      """
        hostname: "localhost",
      """,
      """
        hostname: System.get_env("DB_HOST") || "localhost",
      """
    )

    project
  end

  defp edit_test_support_cases(project) do
    project
    |> edit_test_support_case("test/support/channel_case.ex")
    |> edit_test_support_case("test/support/conn_case.ex")
    |> edit_test_support_case("test/support/data_case.ex")
  end

  defp edit_test_support_case(project, case_path) do
    Generator.inject_content(
      case_path,
      """
        use ExUnit.CaseTemplate
      """,
      """

        alias Ecto.Adapters.SQL.Sandbox
      """
    )

    Generator.replace_content(
      case_path,
      """
          :ok = Ecto.Adapters.SQL.Sandbox.checkout(#{project.base_module}.Repo)
      """,
      """
          :ok = Sandbox.checkout(#{project.base_module}.Repo)
      """
    )

    Generator.replace_content(
      case_path,
      """
        Ecto.Adapters.SQL.Sandbox.mode(#{project.base_module}.Repo, {:shared, self()})
      """,
      """
        Sandbox.mode(#{project.base_module}.Repo, {:shared, self()})
      """
    )

    project
  end
end
