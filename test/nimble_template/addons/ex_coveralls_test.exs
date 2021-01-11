defmodule NimbleTemplate.Addons.ExCoverallsTest do
  use NimbleTemplate.AddonCase

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:excoveralls, "0.12.2"}]

    test "copies the coveralls.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExCoveralls.apply(project)

        assert_file("coveralls.json")
      end)
    end

    test "injects excoveralls to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExCoveralls.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:excoveralls, \"~> 0.12.2\", [only: :test]},
                 """
        end)
      end)
    end

    test "sets ExCoveralls tool", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.ExCoveralls.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                     deps: deps(),
                       test_coverage: [tool: ExCoveralls],
                       preferred_cli_env: [
                         lint: :test,
                         coverage: :test,
                         coveralls: :test,
                         "coveralls.html": :test
                       ]
                 """
        end)
      end)
    end

    test "adds coverage alias", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.ExCoveralls.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       coverage: [\"coveralls.html --raise\"],
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with mix_project" do
    @describetag mix_project?: true
    @describetag required_addons: [:TestEnv]
    @describetag mock_latest_package_versions: [{:excoveralls, "0.12.2"}]

    test "copies the coveralls.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExCoveralls.apply(project)

        assert_file("coveralls.json")
      end)
    end

    test "injects excoveralls to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExCoveralls.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:excoveralls, \"~> 0.12.2\", [only: :test]},
                 """
        end)
      end)
    end

    test "sets ExCoveralls tool", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.ExCoveralls.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                     deps: deps(),
                       test_coverage: [tool: ExCoveralls],
                       preferred_cli_env: [
                         lint: :test,
                         coverage: :test,
                         coveralls: :test,
                         "coveralls.html": :test
                       ]
                 """
        end)
      end)
    end

    test "adds coverage alias", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.ExCoveralls.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       coverage: [\"coveralls.html --raise\"],
                 """
        end)
      end)
    end
  end
end
