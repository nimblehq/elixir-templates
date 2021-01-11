defmodule NimbleTemplate.Addons.MixReleaseTest do
  use NimbleTemplate.AddonCase

  describe "#apply/2" do
    test "deletes the import_config \"prod.secret.exs\" in config/prod.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.MixRelease.apply(project)

        assert_file("config/prod.exs", fn file ->
          refute file =~ """
                 # Finally import the config/prod.secret.exs which loads secrets
                 # and configuration from environment variables.
                 import_config "prod.secret.exs"
                 """
        end)
      end)
    end

    test "deletes the prod.secret.exs in config", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.MixRelease.apply(project)

        refute_file("config/prod.secret.exs")
      end)
    end

    test "creates the runtime.exs in config", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.MixRelease.apply(project)

        assert_file("config/runtime.exs", fn file ->
          assert file =~ """
                 import Config

                 if config_env() == :prod do
                 """
        end)
      end)
    end

    test "creates the lib/nimble_template/release_tasks.ex", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.MixRelease.apply(project)

        assert_file("lib/nimble_template/release_tasks.ex", fn file ->
          assert file =~ """
                 defmodule NimbleTemplate.ReleaseTasks do
                   @app :nimble_template

                   def migrate do
                 """
        end)
      end)
    end
  end
end
