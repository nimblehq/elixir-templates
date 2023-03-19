defmodule NimbleTemplate.Addons.Phoenix.Api.ErrorJSONTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    test "copies the error JSON files", %{
      project: project,
      test_project_path: project_path
    } do
      in_test_project!(project_path, fn ->
        ApiAddons.ErrorJSON.apply!(project)

        assert_file("lib/nimble_template_web/controllers/error_json.ex")
        assert_file("test/nimble_template_web/controllers/error_json_test.exs")
      end)
    end
  end
end
