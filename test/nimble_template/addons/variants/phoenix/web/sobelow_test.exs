defmodule NimbleTemplate.Addons.Phoenix.Web.SobelowTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:sobelow, "0.8"}]
    @describetag required_addons: [:TestEnv]

    test "copies the .sobelow-conf", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Sobelow.apply(project)

        assert_file(".sobelow-conf")
      end)
    end

    test "injects sobelow to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Sobelow.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:sobelow, "~> 0.8", [only: [:dev, :test], runtime: false]},
                 """
        end)
      end)
    end

    test "adds sobelow codebase alias", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        WebAddons.Sobelow.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       codebase: [
                         "sobelow --config",
                 """
        end)
      end)
    end
  end
end
