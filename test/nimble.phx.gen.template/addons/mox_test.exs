defmodule Nimble.Phx.Gen.Template.Addons.MoxTest do
  use Nimble.Phx.Gen.Template.AddonCase

  setup %{project: project, test_project_path: test_project_path} do
    mock_latest_package_version(:mox, "1.0.0")

    {:ok, project: project, test_project_path: test_project_path}
  end

  describe "#apply/2" do
    test "copies the test/support/mock.ex", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Mox.apply(project)

        assert_file("test/support/mock.ex")
      end)
    end

    test "injects mox to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Mox.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:mox, \"~> 1.0.0\", [only: :test]},
                 """
        end)
      end)
    end

    test "updates test/test_helper.exs", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.Mox.apply(project)

        assert_file("test/test_helper.exs", fn file ->
          assert file =~ """
                 {:ok, _} = Application.ensure_all_started(:mox)

                 ExUnit.start()
                 """
        end)
      end)
    end
  end
end
