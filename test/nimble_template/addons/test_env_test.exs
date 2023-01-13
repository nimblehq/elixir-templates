defmodule NimbleTemplate.Addons.TestEnvTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    test "injects the DB_HOST ENV", %{project: project, test_project_path: test_project_path} do
      in_test_project!(test_project_path, fn ->
        Addons.TestEnv.apply!(project)

        assert_file("config/test.exs", fn file ->
          assert file =~ "hostname: System.get_env(\"DB_HOST\") || \"localhost\","
        end)
      end)
    end

    test "adds codebase alias", %{project: project, test_project_path: test_project_path} do
      in_test_project!(test_project_path, fn ->
        Addons.TestEnv.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       codebase: [
                         "deps.unlock --check-unused",
                         "format --check-formatted"
                       ],
                 """
        end)
      end)
    end

    test "adds codebase.fix alias", %{project: project, test_project_path: test_project_path} do
      in_test_project!(test_project_path, fn ->
        Addons.TestEnv.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       "codebase.fix": [
                         "deps.clean --unlock --unused",
                         "format"
                       ],
                 """
        end)
      end)
    end

    test "adds `Code.put_compiler_option(:warnings_as_errors, true)` into `test/test_helper.exs`",
         %{project: project, test_project_path: test_project_path} do
      in_test_project!(test_project_path, fn ->
        Addons.TestEnv.apply!(project)

        assert_file("test/test_helper.exs", fn file ->
          assert file =~ """
                 Code.put_compiler_option(:warnings_as_errors, true)

                 ExUnit.start()
                 """
        end)
      end)
    end

    test "sets line_length to 100 in .formatter.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        Addons.TestEnv.apply!(project)

        assert_file(".formatter.exs", fn file ->
          assert file =~ """
                 [
                   line_length: 100,
                 """
        end)
      end)
    end
  end

  describe "#apply!/2 with mix_project" do
    @describetag mix_project?: true

    test "adds codebase and codebase.fix alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        Addons.TestEnv.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ "aliases: aliases()"

          assert file =~ """
                   defp aliases do
                     [
                       codebase: [
                         "deps.unlock --check-unused",
                         "format --check-formatted"
                       ],
                       "codebase.fix": [
                         "deps.clean --unlock --unused",
                         "format"
                       ]
                     ]
                   end
                 """
        end)
      end)
    end

    test "adds elixirc_paths", %{project: project, test_project_path: test_project_path} do
      in_test_project!(test_project_path, fn ->
        Addons.TestEnv.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ "elixirc_paths: elixirc_paths(Mix.env()),"

          assert file =~ """
                   # Specifies which paths to compile per environment.
                   defp elixirc_paths(:test), do: ["lib", "test/support"]
                   defp elixirc_paths(_), do: ["lib"]
                 """
        end)
      end)
    end

    test "adds `Code.put_compiler_option(:warnings_as_errors, true)` into `test/test_helper.exs`",
         %{project: project, test_project_path: test_project_path} do
      in_test_project!(test_project_path, fn ->
        Addons.TestEnv.apply!(project)

        assert_file("test/test_helper.exs", fn file ->
          assert file =~ """
                 Code.put_compiler_option(:warnings_as_errors, true)

                 ExUnit.start()
                 """
        end)
      end)
    end

    test "sets line_length to 100 in .formatter.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        Addons.TestEnv.apply!(project)

        assert_file(".formatter.exs", fn file ->
          assert file =~ """
                 [
                   line_length: 100,
                 """
        end)
      end)
    end
  end
end
