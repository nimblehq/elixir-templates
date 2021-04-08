defmodule Nimble.Phx.Gen.Template.Addons.CredoTest do
  use Nimble.Phx.Gen.Template.AddonCase

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:credo, "1.4"}]
    @describetag required_addons: [:TestEnv]

    test "copies the .credo.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Credo.apply(project)

        assert_file(".credo.exs")
      end)
    end

    test "injects credo to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Credo.apply(project)

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
        Addons.Credo.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       codebase: [\"deps.unlock --check-unused\", \"format --check-formatted\", \"credo --strict\"],
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with mix_project" do
    @describetag mix_project?: true
    @describetag mock_latest_package_versions: [{:credo, "1.4"}]
    @describetag required_addons: [:TestEnv]

    test "copies the .credo.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Credo.apply(project)

        assert_file(".credo.exs")
      end)
    end

    test "injects credo to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Credo.apply(project)

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
        Addons.Credo.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       codebase: [\"deps.unlock --check-unused\", \"format --check-formatted\", \"credo --strict\"]
                 """
        end)
      end)
    end
  end
end
