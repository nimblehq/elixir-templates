defmodule NimbleTemplate.Addons.EctoDataMigration do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([
      {:text, "priv/repo/data_migrations/.keep", "priv/repo/data_migrations/.keep"}
    ])

    project
  end

  defp edit_files(%Project{} = project) do
    edit_mix(project)

    project
  end

  defp edit_mix(project) do
    Generator.inject_content(
      "mix.exs",
      """
        defp aliases do
          [
      """,
      """
            "ecto.migrate_all": [
              "ecto.migrate --migrations-path=priv/repo/migrations --migrations-path=priv/repo/data_migrations"
            ],
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
        end
      end
      """,
      """
        end

        defp migrate(_) do
          if Mix.env() == :test do
            Mix.Task.run("ecto.migrate", ["--quiet"])
          else
            Mix.Task.run("ecto.migrate_all", [])
          end
        end
      end
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
            "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      """,
      """
            "ecto.setup": ["ecto.create", &migrate/1, "run priv/repo/seeds.exs"],
      """
    )

    project
  end
end
