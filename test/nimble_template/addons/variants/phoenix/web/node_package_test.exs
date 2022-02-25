defmodule NimbleTemplate.Addons.Phoenix.Web.NodePackageTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "copies the package.json into assets", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.NodePackage.apply(project)

        assert_file("assets/package.json")
      end)
    end
  end
end
