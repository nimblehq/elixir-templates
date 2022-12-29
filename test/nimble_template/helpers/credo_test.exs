defmodule NimbleTemplate.CredoHelperTest do
  use NimbleTemplate.AddonCase, async: false

  alias NimbleTemplate.CredoHelper

  describe "suppress_credo_warnings_for_base_project/1" do
    test "prepends credo rule disabling in the given file", %{
      test_project_path: test_project_path,
      project: project
    } do
      in_test_project!(test_project_path, fn ->
        sample_module_file = "lib/nimble_template.ex"

        File.write!(sample_module_file, """
        defmodule SampleModule do
          def foo, do: "bar"
        end
        """)

        CredoHelper.suppress_credo_warnings_for_base_project(project)

        assert_file(sample_module_file, fn file ->
          assert file == """
                 # credo:disable-for-this-file CompassCredoPlugin.Check.DoSingleExpression
                 defmodule SampleModule do
                   def foo, do: "bar"
                 end
                 """
        end)
      end)
    end
  end
end
