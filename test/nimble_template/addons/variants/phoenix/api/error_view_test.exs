defmodule NimbleTemplate.Addons.Phoenix.Api.ErrorViewTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "copies the error view files", %{
      project: project,
      test_project_path: project_path
    } do
      in_test_project(project_path, fn ->
        ApiAddons.ErrorView.apply(project)

        assert_file("lib/nimble_template_web/views/error_helpers.ex")
        assert_file("lib/nimble_template_web/views/api/error_view.ex")
        assert_file("test/nimble_template_web/views/error_helpers_test.exs")
        assert_file("test/nimble_template_web/views/api/error_view_test.exs")
        assert_file("test/support/view_case.ex")
      end)
    end
  end
end
