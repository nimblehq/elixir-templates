defmodule NimbleTemplate.Addons.Phoenix.Web.NimbleJSTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "copies Nimble JS structure", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.NimbleJS.apply(project)

        assert_directory("assets/js/adapters")
        assert_directory("assets/js/components")
        assert_directory("assets/js/config")
        assert_directory("assets/js/helpers")
        assert_directory("assets/js/initializers")
        assert_directory("assets/js/lib")
        assert_directory("assets/js/screens")

        assert_file("assets/js/app.js")
      end)
    end

    test "imports initializers and screens in assets/js/app.js", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.NimbleJS.apply(project)

        assert_file("assets/js/app.js", fn file ->
          assert file =~ """

                 // Application
                 import "./initializers/";

                 import "./screens/";
                 """
        end)
      end)
    end
  end
end
