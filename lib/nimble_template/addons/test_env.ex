defmodule Nimble.Template.Addons.TestEnv do
  use Nimble.Template.Addon

  @impl true
  def do_apply(%Project{mix_project?: true} = project, _opts) do
    project
    |> edit_mix()
    |> edit_formatter_exs()
    |> edit_test_helper()
  end

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> edit_mix()
    |> edit_formatter_exs()
    |> edit_test_helper()
    |> edit_test_config()
    |> edit_test_support_cases()
  end

  defp edit_mix(%Project{mix_project?: true} = project) do
    Generator.replace_content(
      "mix.exs",
      """
            deps: deps()
      """,
      """
            elixirc_paths: elixirc_paths(Mix.env()),
            aliases: aliases(),
            deps: deps()
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
        # Run "mix help deps" to learn about dependencies.
      """,
      """
        defp aliases do
          [
            codebase: ["deps.unlock --check-unused", "format --check-formatted"]
          ]
        end

        # Specifies which paths to compile per environment.
        defp elixirc_paths(:test), do: ["lib", "test/support"]
        defp elixirc_paths(_), do: ["lib"]

        # Run "mix help deps" to learn about dependencies.
      """
    )

    project
  end

  defp edit_mix(project) do
    Generator.inject_content(
      "mix.exs",
      """
        defp aliases do
          [
      """,
      """
            codebase: ["deps.unlock --check-unused", "format --check-formatted"],
      """
    )

    project
  end

  defp edit_test_helper(%Project{} = project) do
    Generator.replace_content(
      "test/test_helper.exs",
      """
      ExUnit.start()
      """,
      """
      Code.put_compiler_option(:warnings_as_errors, true)

      ExUnit.start()
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

  defp edit_formatter_exs(project) do
    Generator.inject_content(
      ".formatter.exs",
      "[",
      String.slice(
        """

          line_length: 100,
        """,
        0..-2
      )
    )

    project
  end

  defp edit_test_support_cases(project) do
    project
    |> edit_test_support_case("channel_case")
    |> edit_test_support_case("conn_case")
    |> edit_test_support_case("data_case")
  end

  defp edit_test_support_case(project, support_case_name) do
    support_case_path = "test/support/" <> support_case_name <> ".ex"

    Generator.inject_content(
      support_case_path,
      """
        use ExUnit.CaseTemplate
      """,
      """

        alias Ecto.Adapters.SQL.Sandbox
      """
    )

    Generator.replace_content(
      support_case_path,
      """
          :ok = Ecto.Adapters.SQL.Sandbox.checkout(#{project.base_module}.Repo)
      """,
      """
          :ok = Sandbox.checkout(#{project.base_module}.Repo)
      """
    )

    Generator.replace_content(
      support_case_path,
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
