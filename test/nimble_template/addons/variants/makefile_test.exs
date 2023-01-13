defmodule NimbleTemplate.Addons.Phoenix.MakefileTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    test "copies the Makefile", %{project: project, test_project_path: test_project_path} do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.Makefile.apply!(project)

        assert_file("Makefile")
      end)
    end
  end
end
