defmodule NimbleTemplate.Addons.Phoenix.MixReleaseTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "creates the lib/nimble_template/release_tasks.ex", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        PhoenixAddons.MixRelease.apply(project)

        assert_file("lib/nimble_template/release_tasks.ex", fn file ->
          assert file =~ """
                 defmodule NimbleTemplate.ReleaseTasks do
                   @app :nimble_template

                   def migrate do
                     load_app()

                     for repo <- repos() do
                       schema_migrations = Ecto.Migrator.migrations_path(repo, "migrations")
                       data_migrations = Ecto.Migrator.migrations_path(repo, "data_migrations")

                       {:ok, _, _} =
                         Ecto.Migrator.with_repo(
                           repo,
                           &Ecto.Migrator.run(&1, [schema_migrations, data_migrations], :up, all: true)
                         )
                     end
                   end
                 """
        end)
      end)
    end

    test "adjusts the config/runtime.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        PhoenixAddons.MixRelease.apply(project)

        assert_file("config/runtime.exs", fn file ->
          assert file =~ """
                   config :nimble_template, NimbleTemplateWeb.Endpoint,
                     server: true,
                 """

          assert file =~ """
                   host =
                     System.get_env("PHX_HOST") ||
                       raise \"\"\"
                       Environment variable PHX_HOST is missing.
                       Set the Heroku endpoint to this variable.
                       \"\"\"
                 """

          refute file =~ """

                  # ## Using releases
                  #
                  # If you use `mix release`, you need to explicitly enable the server
                  # by passing the PHX_SERVER=true when you start it:
                  #
                  #     PHX_SERVER=true bin/nimble_template start
                  #
                  # Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
                  # script that automatically sets the env var above.
                  if System.get_env("PHX_SERVER") do
                    config :nimble_template, NimbleTemplateWeb.Endpoint, server: true
                  end
                 """
        end)
      end)
    end
  end
end
