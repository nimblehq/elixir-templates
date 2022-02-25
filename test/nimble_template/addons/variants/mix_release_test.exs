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
  end
end
