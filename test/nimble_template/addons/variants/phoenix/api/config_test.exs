defmodule NimbleTemplate.Addons.Phoenix.Api.ConfigTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    test "removes cache_static_manifest setting in config/prod.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        ApiAddons.Config.apply!(project)

        assert_file("config/prod.exs", fn file ->
          refute file =~ """
                 # For production, don't forget to configure the url host
                 # to something meaningful, Phoenix uses this information
                 # when generating URLs.
                 """
        end)
      end)
    end
  end
end
