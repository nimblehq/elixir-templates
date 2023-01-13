defmodule NimbleTemplate.Addons.Phoenix.Api.ParamsValidationTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    test "copies the params validation module and test files", %{
      project: project,
      test_project_path: project_path
    } do
      in_test_project!(project_path, fn ->
        ApiAddons.ParamsValidation.apply!(project)

        assert_file("lib/nimble_template_web/params/params.ex")
        assert_file("lib/nimble_template_web/params/params_validator.ex")
        assert_file("test/nimble_template_web/params/params_validator_test.exs")
      end)
    end

    test "adds ParamsValidator alias into the web entry_point", %{
      project: project,
      test_project_path: project_path
    } do
      in_test_project!(project_path, fn ->
        ApiAddons.ParamsValidation.apply!(project)

        assert_file("lib/nimble_template_web.ex", fn file ->
          assert file =~ "alias NimbleTemplateWeb.ParamsValidator"
        end)
      end)
    end
  end
end
