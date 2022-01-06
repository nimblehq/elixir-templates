defmodule NimbleTemplate.Addons.Phoenix.Web.CoreJSTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "adds core-js into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.CoreJS.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                   "dependencies": {
                     "core-js": "^3.7.0",
                 """
        end)
      end)
    end

    test "imports core-js into app.js", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        WebAddons.CoreJS.apply(project)

        assert_file("assets/js/app.js", fn file ->
          assert file =~ """
                 // CoreJS
                 import "core-js/stable"
                 import "regenerator-runtime/runtime"
                 """
        end)
      end)
    end
  end

  describe "#apply/2 to a Live project" do
    @describetag live_project?: true

    test "adds core-js into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.CoreJS.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                   "dependencies": {
                     "core-js": "^3.7.0",
                 """
        end)
      end)
    end
  end
end
