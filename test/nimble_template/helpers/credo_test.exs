defmodule NimbleTemplate.CredoHelperTest do
  use NimbleTemplate.AddonCase, async: false

  alias NimbleTemplate.CredoHelper

  describe "suppress_credo_warnings_for_base_project/1" do
    test "prepends credo rule disabling in the given file", %{
      test_project_path: test_project_path,
      project: project
    } do
      in_test_project!(test_project_path, fn ->
        CredoHelper.suppress_credo_warnings_for_base_project(project)

        assert_file("#{test_project_path}/lib/nimble_template.ex", fn file ->
          assert file =~ """
                 # credo:disable-for-this-file CompassCredoPlugin.Check.DoSingleExpression
                 """
        end)
      end)
    end
  end

  describe "suppress_credo_warnings_for_phoenix_project/1" do
    test "prepends credo rule disabling in the given file", %{
      test_project_path: test_project_path,
      project: project
    } do
      in_test_project!(test_project_path, fn ->
        CredoHelper.suppress_credo_warnings_for_phoenix_project(project)

        assert_file(
          "#{test_project_path}/lib/nimble_template_web/controllers/page_controller.ex",
          fn file ->
            assert file =~ """
                   # credo:disable-for-this-file CompassCredoPlugin.Check.DoSingleExpression
                   """
          end
        )

        assert_file("#{test_project_path}/lib/nimble_template_web/telemetry.ex", fn file ->
          assert file =~ """
                 # credo:disable-for-this-file CompassCredoPlugin.Check.DoSingleExpression
                 """
        end)

        assert_file("#{test_project_path}/lib/nimble_template_web/views/error_view.ex", fn file ->
          assert file =~ """
                 # credo:disable-for-this-file CompassCredoPlugin.Check.DoSingleExpression
                 """
        end)
      end)
    end
  end
end
