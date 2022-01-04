defmodule NimbleTemplate.Addons.Phoenix.Api.ErrorViewTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "copies the error view files and remove web layout files", %{
      project: project,
      test_project_path: project_path
    } do
      in_test_project(project_path, fn ->
        AddonsApi.ErrorView.apply(project)

        assert_file("lib/nimble_template_web/views/error_helpers.ex")
        assert_file("lib/nimble_template_web/views/error_view.ex")
        assert_file("test/nimble_template_web/views/error_helpers_test.exs")
        assert_file("test/nimble_template_web/views/error_view_test.exs")
        assert_file("test/support/view_case.ex")

        refute_file("lib/nimble_template_web/views/layout_view.ex")
        refute_file("lib/nimble_template_web/views/page_view.ex")
        refute_file("lib/nimble_template_web/views/layout_view_test.exs")
        refute_file("lib/nimble_template_web/views/page_view_test.exs")
        refute_file("lib/nimble_template_web/controllers/page_controller_test.exs")
      end)
    end
  end
end
