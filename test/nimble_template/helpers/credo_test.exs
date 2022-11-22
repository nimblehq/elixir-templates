defmodule NimbleTemplate.CredoHelperTest do
  use NimbleTemplate.AddonCase, async: false

  alias NimbleTemplate.CredoHelper

  describe "disable_rule/2" do
    test "prepends credo rule disabling in the given file", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        File.write!("sample_module.exs", """
        defmodule SampleModule do
          def foo, do: "bar"
        end
        """)

        CredoHelper.disable_rule("sample_module.exs", "Credo.Check.Readability.RedundantBlankLines")

        assert_file("sample_module.exs", fn file ->
          assert file == """
                 # credo:disable-for-this-file Credo.Check.Readability.RedundantBlankLines
                 defmodule SampleModule do
                   def foo, do: "bar"
                 end
                 """
        end)
      end)
    end
  end
end
