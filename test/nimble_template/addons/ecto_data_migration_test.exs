defmodule NimbleTemplate.Addons.EctoDataMigrationTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "adds `ecto.migrate_all` into mix aliases", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.EctoDataMigration.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       "ecto.migrate_all": [
                         "ecto.migrate --migrations-path=priv/repo/migrations --migrations-path=priv/repo/data_migrations"
                       ],
                 """
        end)
      end)
    end

    test "defines defp migrate", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.EctoDataMigration.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp migrate(_) do
                     if Mix.env() == :test do
                       Mix.Task.run("ecto.migrate", ["--quiet"])
                     else
                       Mix.Task.run("ecto.migrate_all", [])
                     end
                   end
                 """
        end)
      end)
    end

    test "adjusts the `ecto.setup` alias by using `&migrate/1`", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.EctoDataMigration.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                 "ecto.setup": ["ecto.create", &migrate/1, "run priv/repo/seeds.exs"],
                 """
        end)
      end)
    end

    test "creates the data_migrations directory", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.EctoDataMigration.apply(project)

        assert_file("priv/repo/data_migrations/.keep")
      end)
    end
  end
end
