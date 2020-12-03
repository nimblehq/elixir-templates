defmodule Nimble.Phx.Gen.Template.Addons.ObanTest do
  use Nimble.Phx.Gen.Template.AddonCase
  use Mimic

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:oban, "2.3"}]

    test "injects credo to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Oban.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:oban, \"~> 2.3\"},
                 """
        end)
      end)
    end

    test "creates Oban migration file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        expect(Calendar, :strftime, fn _datetime, _format -> "20201120074154" end)

        Addons.Oban.apply(project)

        assert_file("priv/repo/migrations/20201120074154_add_oban_jobs_table.exs", fn file ->
          assert file =~ """
                 defmodule NimblePhxGenTemplate.Repo.Migrations.AddObanJobsTable do
                   use Ecto.Migration

                   def up do
                     Oban.Migrations.up()
                   end

                   # We specify `version: 1` in `down`, ensuring that we'll roll all the way back down if
                   # necessary, regardless of which version we've migrated `up` to.
                   def down do
                     Oban.Migrations.down(version: 1)
                   end
                 end
                 """
        end)
      end)
    end

    test "adds Oban configuration into the application.ex", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Oban.apply(project)

        assert_file("lib/nimble_phx_gen_template/application.ex", fn file ->
          assert file =~ """
                 {Oban, oban_config()}
                 """

          assert file =~ """
                   # Conditionally disable crontab, queues, or plugins here.
                   defp oban_config do
                     Application.get_env(:nimble_phx_gen_template, Oban)
                   end
                 """
        end)
      end)
    end

    test "adds Oban configuration into the config/config.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Oban.apply(project)

        assert_file("config/config.exs", fn file ->
          assert file =~ """
                 config :nimble_phx_gen_template, Oban,
                   repo: NimblePhxGenTemplate.Repo,
                   plugins: [Oban.Plugins.Pruner],
                   queues: [default: 10]
                 """
        end)
      end)
    end

    test "adds Oban configuration into the config/test.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Oban.apply(project)

        assert_file("config/test.exs", fn file ->
          assert file =~ """
                 config :nimble_phx_gen_template, Oban, crontab: false, queues: false, plugins: false
                 """
        end)
      end)
    end

    test "creates the worker folder", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Oban.apply(project)

        assert(File.dir?("lib/nimble_phx_gen_template_worker")) == true
      end)
    end
  end
end
