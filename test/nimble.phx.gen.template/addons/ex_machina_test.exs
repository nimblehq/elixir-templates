defmodule Nimble.Phx.Gen.Template.Addons.ExMachinaTest do
  use Nimble.Phx.Gen.Template.AddonCase

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:ex_machina, "2.4"}]

    test "copies the test/support/factory.ex", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExMachina.apply(project)

        assert_file("test/support/factory.ex")
      end)
    end

    test "injects ex_machina to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExMachina.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:ex_machina, \"~> 2.4\", [only: :test]},
                 """
        end)
      end)
    end

    test "adds test/factories into elixirc_paths", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExMachina.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                 defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
                 """
        end)
      end)
    end

    test "updates test/test_helper.exs", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.ExMachina.apply(project)

        assert_file("test/test_helper.exs", fn file ->
          assert file =~ """
                 {:ok, _} = Application.ensure_all_started(:ex_machina)

                 ExUnit.start()
                 """
        end)
      end)
    end

    test "adds Factory module", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.ExMachina.apply(project)

        assert_file("test/support/data_case.ex", fn file ->
          assert file =~ "import NimblePhxGenTemplate.Factory"
        end)

        assert_file("test/support/channel_case.ex", fn file ->
          assert file =~ "import NimblePhxGenTemplate.Factory"
        end)

        assert_file("test/support/conn_case.ex", fn file ->
          assert file =~ "import NimblePhxGenTemplate.Factory"
        end)
      end)
    end
  end
end
