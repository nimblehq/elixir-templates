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

          refute file =~ """

                   # ## Using releases
                   #
                   # If you are doing OTP releases, you need to instruct Phoenix
                   # to start each relevant endpoint:
                   #
                   #     config :nimble_template, NimbleTemplateWeb.Endpoint, server: true
                   #
                   # Then you can assemble a release by calling `mix release`.
                   # See `mix help release` for more information.
                 """

          refute file =~ """
                 # Start the phoenix server if environment is set and running in a release
                 if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
                   config :nimble_template, NimbleTemplateWeb.Endpoint, server: true
                 end

                 """
        end)
      end)
    end
  end
end
