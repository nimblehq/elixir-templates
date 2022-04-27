defmodule NimbleTemplate.Addons.Phoenix.Web.EsBuildTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "renames esbuild namespace to app in the mix assets.deploy alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.EsBuild.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ "\"assets.deploy\": [\"esbuild app --minify\","
        end)
      end)
    end

    test "renames esbuild namespace to app in the config.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.EsBuild.apply(project)

        assert_file("config/config.exs", fn file ->
          assert file =~ """
                 config :esbuild,
                   version: "0.14.0",
                   app: [
                     args:
                 """
        end)
      end)
    end

    test "renames esbuild namespace to app in the development watcher", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.EsBuild.apply(project)

        assert_file("config/dev.exs", fn file ->
          assert file =~ "esbuild: {Esbuild, :install_and_run, [:app,"
        end)
      end)
    end
  end
end
