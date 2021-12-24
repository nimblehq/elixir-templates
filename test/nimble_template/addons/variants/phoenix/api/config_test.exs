defmodule NimbleTemplate.Addons.Phoenix.Api.ConfigTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "removes cache_static_manifest setting in config/prod.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsApi.Config.apply(project)

        assert_file("config/prod.exs", fn file ->
          refute file =~ "cache_static_manifest: \"priv/static/cache_manifest.json\""
        end)
      end)
    end
  end
end
