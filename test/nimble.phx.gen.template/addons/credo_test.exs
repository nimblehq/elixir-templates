defmodule Nimble.Phx.Gen.Template.Addons.CredoTest do
  use Nimble.Phx.Gen.Template.AddonCase

  setup %{project: project, test_project_path: test_project_path} do
    in_test_project(test_project_path, fn ->
      Addons.TestEnv.apply(project, %{})
    end)

    {:ok, project: Nimble.Phx.Gen.Template.Project.info(), test_project_path: test_project_path}
  end

  describe "#apply/2" do
    test "copies the .credo.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Credo.apply(project, %{})

        assert_file(".credo.exs")
      end)
    end

    test "injects credo to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Credo.apply(project, %{})

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:credo, \"~> 1.4\", [only: [:dev, :test], runtime: false]},
                 """
        end)
      end)
    end

    test "adds credo codebase alias", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.Credo.apply(project, %{})

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       codebase: [\"format --check-formatted\", \"credo\"],
                 """
        end)
      end)
    end
  end
end
