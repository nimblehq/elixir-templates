defmodule NimbleTemplate.Addons.Phoenix.Web.NimbleJSTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag required_addons: [:TestEnv, :"Phoenix.Web.NodePackage", :"Phoenix.Web.EsLint"]

    test "copies Nimble JS structure", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.NimbleJS.apply(project)

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

    test "updates assets/js/app.js", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.NimbleJS.apply(project)

        assert_file("assets/js/app.js", fn file ->
          assert file =~ """

                 // Application
                 import "./initializers/";

                 import "./screens/";
                 """

          assert file =~ "\"./vendor/topbar\""
          assert file =~ "\"./vendor/some-package.js\""
          assert file =~ "assets/js/vendor"

          refute file =~ "\"../vendor/topbar\""
          refute file =~ "\"../vendor/some-package.js\""
          refute file =~ "assets/vendor"
        end)
      end)
    end

    test "moves assets/vendor/topbar.js into assets/js/vendor/topbar.js", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.NimbleJS.apply(project)

        assert_file("assets/js/vendor/topbar.js")
        refute_file("assets/vendor/topbar.js")
      end)
    end

    test "updates .eslintrc.json config", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.NimbleJS.apply(project)

        assert_file("assets/.eslintrc.json", fn file ->
          assert file =~ """
                   "ignorePatterns": [
                     "/js/vendor/topbar.js"
                   ]
                 """
        end)
      end)
    end
  end
end
