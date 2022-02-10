defmodule NimbleTemplate.Addons.Phoenix.Api.JsonApiTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:jsonapi, "1.3.0"}]

    test "injects jsonapi to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        ApiAddons.JsonApi.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ "{:jsonapi, \"~> 1.3.0\"}"
        end)
      end)
    end

    test "adds config for jsonapi in config/config.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        ApiAddons.JsonApi.apply(project)

        assert_file("config/config.exs", fn file ->
          assert file =~ "config :jsonapi, remove_links: true"
        end)
      end)
    end
  end
end
