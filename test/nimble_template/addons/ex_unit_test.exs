defmodule NimbleTemplate.Addons.ExUnitTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    test "sets `ExUnit.start(capture_log: true)` in `test/test_helper.exs`",
         %{project: project, test_project_path: test_project_path} do
      in_test_project!(test_project_path, fn ->
        Addons.ExUnit.apply!(project)

        assert_file("test/test_helper.exs", fn file ->
          assert file =~ "ExUnit.start(capture_log: true)"
        end)
      end)
    end
  end
end
