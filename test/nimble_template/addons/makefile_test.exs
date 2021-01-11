defmodule Nimble.Template.Addons.MakefileTest do
  use Nimble.Template.AddonCase

  describe "#apply/2" do
    test "copies the Makefile", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.Makefile.apply(project)

        assert_file("Makefile")
      end)
    end
  end
end
