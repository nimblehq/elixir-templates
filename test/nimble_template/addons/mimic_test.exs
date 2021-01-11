defmodule Nimble.Template.Addons.MimicTest do
  use Nimble.Template.AddonCase

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:mimic, "1.3.1"}]

    test "injects mimic to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Mimic.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:mimic, \"~> 1.3.1\", [only: :test]},
                 """
        end)
      end)
    end

    test "stats the mimic in test/test_helper.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Mimic.apply(project)

        assert_file("test/test_helper.exs", fn file ->
          assert file =~ """
                 {:ok, _} = Application.ensure_all_started(:mimic)

                 ExUnit.start()
                 """
        end)
      end)
    end
  end
end
