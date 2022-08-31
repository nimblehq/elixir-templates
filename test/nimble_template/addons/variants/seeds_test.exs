defmodule NimbleTemplate.Addons.Phoenix.SeedsTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "adds the condition into the seeds.exs file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        PhoenixAddons.Seeds.apply(project)

        assert_file("priv/repo/seeds.exs", fn file ->
          assert file =~ """
                 if Mix.env() == :dev || System.get_env("ENABLE_DB_SEED") == "true" do
                 end
                 """
        end)
      end)
    end
  end
end
