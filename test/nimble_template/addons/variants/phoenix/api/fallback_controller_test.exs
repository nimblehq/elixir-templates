defmodule NimbleTemplate.Addons.Phoenix.Api.FallbackControllerTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag required_addons: [:"Phoenix.Api.ParamsValidation"]

    test "copies the FallbackController module", %{
      project: project,
      test_project_path: project_path
    } do
      in_test_project(project_path, fn ->
        ApiAddons.FallbackController.apply(project)

        assert_file("lib/nimble_template_web/controllers/api/fallback_controller.ex")
      end)
    end

    test "adds FallbackController alias into the web entry_point", %{
      project: project,
      test_project_path: project_path
    } do
      in_test_project(project_path, fn ->
        ApiAddons.FallbackController.apply(project)

        assert_file("lib/nimble_template_web.ex", fn file ->
          assert file =~ "action_fallback NimbleTemplateWeb.Api.FallbackController"
        end)
      end)
    end
  end
end
