defmodule Nimble.Phx.Gen.Template.Addons.TestEnvTest do
  use Nimble.Phx.Gen.Template.AddonCase

  describe "#apply/2" do
    test "injects the DB_HOST ENV", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.TestEnv.apply(project)

        assert_file("config/test.exs", fn file ->
          assert file =~ "hostname: System.get_env(\"DB_HOST\") || \"localhost\","
        end)
      end)
    end

    test "adds codebase alias", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.TestEnv.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       codebase: [\"format --check-formatted\"],
                 """
        end)
      end)
    end

    test "sets line_length to 100 in .formatter.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.TestEnv.apply(project)

        assert_file(".formatter.exs", fn file ->
          assert file =~ """
                 [
                   line_length: 100,
                 """
        end)
      end)
    end

    test "creates alias Ecto.Adapters.SQL.Sandbox in test support case", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.TestEnv.apply(project)

        Enum.each(["channel_case", "conn_case", "data_case"], fn support_case_name ->
          assert_file("test/support/" <> support_case_name <> ".ex", fn file ->
            assert file =~ "alias Ecto.Adapters.SQL.Sandbox"
            assert file =~ "Sandbox.checkout(#{project.base_module}.Repo)"
            assert file =~ "Sandbox.mode(#{project.base_module}.Repo, {:shared, self()})"
          end)
        end)
      end)
    end
  end
end
