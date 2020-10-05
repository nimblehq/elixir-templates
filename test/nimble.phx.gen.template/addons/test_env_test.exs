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
  end
end
