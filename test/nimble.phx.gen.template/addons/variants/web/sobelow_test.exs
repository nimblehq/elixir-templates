defmodule Nimble.Phx.Gen.Template.Addons.Web.SobelowTest do
  use Nimble.Phx.Gen.Template.AddonCase

  @moduletag pre_setup: [:TestEnv, :Credo]

  describe "#apply/2" do
    test "copies the .sobelow-conf", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Web.Sobelow.apply(project)

        assert_file(".sobelow-conf")
      end)
    end

    test "injects sobelow to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Web.Sobelow.apply(project)

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
        Addons.Web.Sobelow.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       codebase: [\"format --check-formatted\", \"credo\", \"sobelow --config\"],
                 """
        end)
      end)
    end
  end
end
