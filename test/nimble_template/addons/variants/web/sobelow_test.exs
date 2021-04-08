defmodule NimbleTemplate.AddonsWeb.SobelowTest do
  use NimbleTemplate.AddonCase

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:credo, "0.26.2"}, {:sobelow, "0.8"}]
    @describetag required_addons: [:TestEnv, :Credo]

    test "copies the .sobelow-conf", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Sobelow.apply(project)

        assert_file(".sobelow-conf")
      end)
    end

    test "injects sobelow to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Sobelow.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:sobelow, \"~> 0.8\", [only: [:dev, :test], runtime: false]},
                 """
        end)
      end)
    end

    test "adds sobelow codebase alias", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Sobelow.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       codebase: [
                         \"deps.unlock --check-unused\",
                         \"format --check-formatted\",
                         \"credo --strict\",
                         \"sobelow --config\"
                       ],
                 """
        end)
      end)
    end
  end
end
