defmodule Nimble.Template.AddonsWeb.CoreJSTest do
  use Nimble.Template.AddonCase

  describe "#apply/2" do
    test "adds core-js into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.CoreJS.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                     "core-js": "^3.7.0"
                 """
        end)
      end)
    end

    test "imports core-js into app.js", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        AddonsWeb.CoreJS.apply(project)

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
end
